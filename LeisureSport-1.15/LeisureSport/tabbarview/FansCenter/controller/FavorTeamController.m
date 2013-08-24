//
//  FavorTeamController.m
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-5.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "FavorTeamController.h"
#import "LSUtil.h"
#import "Team.h"
#import "FansCenterFetcher.h"
#import "LeisureSportAppDelegate.h"

@implementation FavorTeamController
@synthesize listContent, filteredListContent,searchDisplayController;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)dealloc{
	[listContent release];
	[filteredListContent release];
	
	[super dealloc];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (listContent) {
        [listContent release];
        listContent = nil;
    }
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    listContent = [[FansCenterFetcher fetchFavorTeam:[LeisureSportAppDelegate userID]] mutableCopy];
//    [pool release];
    [teamTableView reloadData];
    
    [HUD hide:YES];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460-44-48)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:GREEN_BG_IMAGE];
    self.title = @"选择球队";
    UIImageView *palegreenBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 368)];
    [palegreenBg setImage: IMAGEWITHCONTENTSOFFILE(@"palegreenbg")];
    [self.view addSubview:palegreenBg];
    [palegreenBg release];
    
    //添加左导航键
    UIButton * backButton=[UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage:[UIImage imageNamed:@"返回按钮.png"] forState:0];
    [backButton setImage:[UIImage imageNamed:@"返回按钮按下.png"] forState:UIControlStateHighlighted];
	[backButton addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
	backButton.frame=CGRectMake(3,3, 48, 30);
	
	UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = back;
    [back release];

	filteredListContent = [[NSMutableArray alloc] init];
    teamTableView=[[UITableView alloc] initWithFrame:CGRectMake(5, 5, 310, 358) style:UITableViewStylePlain];
	teamTableView.delegate=self;
	teamTableView.dataSource=self;
	teamTableView.scrollEnabled=YES;
    teamTableView.allowsSelection = NO;
    teamTableView.userInteractionEnabled = YES;  
    teamTableView.backgroundColor = [UIColor clearColor];
    [teamTableView setSeparatorColor:[UIColor clearColor]];
    
    
	UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
																					target:self
																					action:@selector(searchBar:)];
	self.navigationItem.rightBarButtonItem = rightBarButton;
    [rightBarButton release];
	
	UISearchBar *mySearchBar = [[UISearchBar alloc] init];
	mySearchBar.delegate = self;
	[mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[mySearchBar sizeToFit];
    teamTableView.tableHeaderView = mySearchBar;
	/*
	 fix the search bar width problem in landscape screen
	 */
	if (UIInterfaceOrientationLandscapeRight == [[UIDevice currentDevice] orientation] ||
		UIInterfaceOrientationLandscapeLeft == [[UIDevice currentDevice] orientation])
	{
		teamTableView.tableHeaderView.frame = CGRectMake(0.f, 0.f, 480.f, 44.f);
	}
	else
	{
		teamTableView.tableHeaderView.frame = CGRectMake(0.f, 0.f, 320.f, 44.f);
	}
	/*
	 set up the searchDisplayController programically
	 */
	searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
	[self setSearchDisplayController:searchDisplayController];
	[searchDisplayController setDelegate:self];
	[searchDisplayController setSearchResultsDataSource:self];    
	[mySearchBar release];

	teamTableView.scrollEnabled = YES;
    
    [self.view addSubview:teamTableView];
	[teamTableView release];
    
    
    //
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.delegate = self;
	[HUD show:YES];
}


//返回球迷社区首页
- (void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	/*
	 Hide the search bar
	 */
	[self.tableView setContentOffset:CGPointMake(0, 44.f) animated:NO];
	
	
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UITableView data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [filteredListContent count];
    }
	else
	{
        return [listContent count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{	
	static NSString *cellID = @"focusCell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
    
	Team *favorTeam = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        favorTeam = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        favorTeam = [self.listContent objectAtIndex:indexPath.row];
    }
    
    //由于重用单元格 需要删除原来单元格的内容
    for (UIView *view in [cell subviews]){
        [view removeFromSuperview];
    }
    
    //名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = favorTeam.Name;
    nameLabel.textColor = [UIColor blueColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.frame = CGRectMake(25, 10, 180, 30);
    [cell addSubview:nameLabel];
    [nameLabel release];
    
    //星号按钮
    UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([@"true" isEqualToString:favorTeam.isfocus]) {
        [starButton setImage:IMAGEWITHCONTENTSOFFILE(@"黄色星") forState: UIControlStateNormal];
        [starButton addTarget:self action:@selector(unfocus:) forControlEvents:UIControlEventTouchUpInside];
    } else{
        [starButton setImage:IMAGEWITHCONTENTSOFFILE(@"灰色星") forState: UIControlStateNormal];  
        [starButton addTarget:self action:@selector(focus:) forControlEvents:UIControlEventTouchUpInside];
    }
    starButton.tag = 100 + indexPath.row;
    starButton.frame = CGRectMake(245, 15, 23, 23);
    [cell addSubview:starButton];

    //间隔条
    UIImageView *seporatorImageView = [[UIImageView alloc] initWithImage:IMAGEWITHCONTENTSOFFILE(@"间隔条")];
    seporatorImageView.frame = CGRectMake(20, 43, 250, 1);
    [cell addSubview:seporatorImageView];
    [seporatorImageView release];
	return cell;
}


//关注
- (void)focus: (id)sender
{
    Team *favorTeam = nil;
    if (isSearching){
        for (int i=0; i<[filteredListContent count]; i++) {
            if([sender tag] == 100+i){
                favorTeam = [filteredListContent objectAtIndex:i];
                UIButton *starButton = (UIButton *)[self.view viewWithTag:[sender tag]];
                [FansCenterFetcher focusTeam:favorTeam.TeamID AndUserID:[LeisureSportAppDelegate userID] Operation:0];
                [starButton addTarget:self action:@selector(unfocus:) forControlEvents:UIControlEventTouchUpInside];
                [starButton setImage:[UIImage imageNamed:@"黄色星.png"] forState: UIControlStateNormal];
            
                //从服务器更新搜索结果
                [self searchFromServer];
            }
        }
        
    }else{
        for (int i=0; i<[listContent count]; i++) {
            if([sender tag] == 100+i){
                favorTeam = [listContent objectAtIndex:i];
                UIButton *starButton = (UIButton *)[self.view viewWithTag:[sender tag]];
                [FansCenterFetcher focusTeam:favorTeam.TeamID AndUserID:[LeisureSportAppDelegate userID] Operation:0];
                [starButton addTarget:self action:@selector(unfocus:) forControlEvents:UIControlEventTouchUpInside];
                [starButton setImage:[UIImage imageNamed:@"黄色星.png"] forState: UIControlStateNormal];
                
            }
        }
        //更新关注的球队数据
        if (listContent) {
            [listContent release];
            listContent = nil;
        }
        listContent = [[FansCenterFetcher fetchFavorTeam:[LeisureSportAppDelegate userID]] mutableCopy];
        [teamTableView reloadData];
    }
    
}

//取消关注
- (void)unfocus: (id)sender
{
    Team *favorTeam = nil;
    if (isSearching){
        for (int i=0; i<[filteredListContent count]; i++) {
            if([sender tag] == 100+i){
                favorTeam = [filteredListContent objectAtIndex:i];
                UIButton *starButton = (UIButton *)[self.view viewWithTag:[sender tag]];
                [FansCenterFetcher focusTeam:favorTeam.TeamID AndUserID:[LeisureSportAppDelegate userID] Operation:1];
                [starButton addTarget:self action:@selector(focus:) forControlEvents:UIControlEventTouchUpInside];
                [starButton setImage:[UIImage imageNamed:@"灰色星.png"] forState: UIControlStateNormal];
                //从服务器更新搜索结果
                [self searchFromServer];
            }
        }
        
    }else{
        for (int i=0; i<[listContent count]; i++) {
            if([sender tag] == 100+i){
                favorTeam = [listContent objectAtIndex:i];
                UIButton *starButton = (UIButton *)[self.view viewWithTag:[sender tag]];
                [FansCenterFetcher focusTeam:favorTeam.TeamID AndUserID:[LeisureSportAppDelegate userID] Operation:1];
                [starButton addTarget:self action:@selector(focus:) forControlEvents:UIControlEventTouchUpInside];
                [starButton setImage:[UIImage imageNamed:@"灰色星.png"] forState: UIControlStateNormal];                
            }
        }
        //更新关注的球队数据
        if (listContent) {
            [listContent release];
            listContent = nil;
        }
        listContent = [[FansCenterFetcher fetchFavorTeam:[LeisureSportAppDelegate userID]] mutableCopy];
        [teamTableView reloadData];
    }
    
}


#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects];// First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (Team *team in listContent)
	{
        NSComparisonResult result = [team.Name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
        {
            [self.filteredListContent addObject:team];
        }
	}

}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
	/*
     Bob: Because the searchResultsTableView will be released and allocated automatically, so each time we start to begin search, we set its delegate here.
     */
    isSearching = YES;
	[self.searchDisplayController.searchResultsTableView setDelegate:self];
//    searchDisplayController.searchResultsTableView.backgroundColor = [UIColor colorWithPatternImage:GREEN_BG_IMAGE];
//    searchDisplayController.searchResultsTableView.backgroundView = PALEGREEN_BG_VIEW;
    
//    [searchDisplayController.searchResultsTableView setSeparatorColor:[UIColor clearColor]];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
	/*
	 Hide the search bar
	 */
    isSearching = NO;
    //更新关注的球队数据
    if (listContent) {
        [listContent release];
        listContent = nil;
    }
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    listContent = [[FansCenterFetcher fetchFavorTeam:[LeisureSportAppDelegate userID]] mutableCopy];
    [pool release];
    [teamTableView reloadData];
	[self.tableView setContentOffset:CGPointMake(0, 44.f) animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if ([filteredListContent count] < 1) {
        searchKey = [searchBar.text mutableCopy];
        //从服务器搜索
        [self searchFromServer];
    }

}

#pragma mark -

-(void)searchBar:(id)sender{
	[searchDisplayController setActive:YES animated:YES];
}


//从服务器搜索
- (void)searchFromServer
{
    [filteredListContent removeAllObjects];
    if (filteredListContent) {
        [filteredListContent release];
        filteredListContent = nil;
    }
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    filteredListContent = [[FansCenterFetcher searchTeamWithUserID:[LeisureSportAppDelegate userID] Key:searchKey] mutableCopy];
    [pool release];
    [self.searchDisplayController.searchResultsTableView setDelegate:self];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}
@end
