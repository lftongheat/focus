//
//  FavorLeagueController.m
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-5.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "FavorLeagueController.h"
#import "LSUtil.h"
#import "FansCenterFetcher.h"
#import "LeagueInfo.h"
#import "LeisureSportAppDelegate.h"

@implementation FavorLeagueController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)dealloc{
	[leagueArray release];
    [favorLeagueArray release];
	[super dealloc];
}

- (void)viewDidAppear:(BOOL)animated
{    
    //从本地获取关注的联赛
    favorLeagueArray = [[FansCenterFetcher getFavorLeagueByUserID:[LeisureSportAppDelegate userID]] mutableCopy];
    
    //获取联赛信息
    leagueArray = [[FansCenterFetcher fetchLeagues] mutableCopy];
    [leagueTableView reloadData];
    
    [HUD hide:YES];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460-44-48)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:GREEN_BG_IMAGE];
    self.title = @"选择赛事";
    UIImageView *palegreenBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 368)];
    [palegreenBg setImage: IMAGEWITHCONTENTSOFFILE(@"palegreenbg")];
    [self.view addSubview:palegreenBg];
    [palegreenBg release];
    
    UIButton * backButton=[UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage:[UIImage imageNamed:@"返回按钮.png"] forState:0];
    [backButton setImage:[UIImage imageNamed:@"返回按钮按下.png"] forState:UIControlStateHighlighted];
	[backButton addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
	backButton.frame=CGRectMake(3,3, 48, 30);
	
	UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = back;
    [back release];  
    
    leagueTableView=[[UITableView alloc] initWithFrame:CGRectMake(5, 5, 310, 358) style:UITableViewStylePlain];
	leagueTableView.delegate=self;
	leagueTableView.dataSource=self;
	leagueTableView.scrollEnabled=YES;
    leagueTableView.allowsSelection = NO;
    leagueTableView.userInteractionEnabled = YES;  
    leagueTableView.backgroundColor = [UIColor clearColor];
    [leagueTableView setSeparatorColor:[UIColor clearColor]];
    leagueTableView.scrollEnabled = YES;
    
    [self.view addSubview:leagueTableView];
	[leagueTableView release];
    
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
    return [leagueArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	static NSString *cellID = @"focusCell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
	LeagueInfo *leagueInfo = [leagueArray objectAtIndex:indexPath.row];
    
    //由于重用单元格 需要删除原来单元格的内容
    for (UIView *view in [cell subviews]){
        [view removeFromSuperview];
    }
    
    //名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = leagueInfo.Name;
    nameLabel.textColor = [UIColor blueColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.frame = CGRectMake(25, 10, 180, 30);
    [cell addSubview:nameLabel];
    [nameLabel release];
    
    //星号按钮
    UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (favorLeagueArray && [favorLeagueArray containsObject:leagueInfo.LeaugeID]) {
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
    for (int i=0; i<[leagueArray count]; i++) {
        if([sender tag] == 100+i){
            LeagueInfo *leagueInfo = [leagueArray objectAtIndex:i];
            UIButton *starButton = (UIButton *)[self.view viewWithTag:[sender tag]];
            [FansCenterFetcher updateFavorLeagueWithOperation:1 LeaugeID:leagueInfo.LeaugeID UserID:[LeisureSportAppDelegate userID]];          
            [starButton addTarget:self action:@selector(unfocus:) forControlEvents:UIControlEventTouchUpInside];
            [starButton setImage:[UIImage imageNamed:@"黄色星.png"] forState: UIControlStateNormal];
            
            //更新关注的联赛数据
            favorLeagueArray = [[FansCenterFetcher getFavorLeagueByUserID:[LeisureSportAppDelegate userID]] mutableCopy];

            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"操作成功";
            hud.margin = 10.f;
            hud.yOffset = 150.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:2];
        }
    }
}

//取消关注
- (void)unfocus: (id)sender
{
    for (int i=0; i<[leagueArray count]; i++) {
        if([sender tag] == 100+i){
            LeagueInfo *leagueInfo = [leagueArray objectAtIndex:i];
            UIButton *starButton = (UIButton *)[self.view viewWithTag:[sender tag]];
            [FansCenterFetcher updateFavorLeagueWithOperation:0 LeaugeID:leagueInfo.LeaugeID UserID:[LeisureSportAppDelegate userID]];
            [starButton addTarget:self action:@selector(focus:) forControlEvents:UIControlEventTouchUpInside];
            [starButton setImage:[UIImage imageNamed:@"灰色星.png"] forState: UIControlStateNormal];
            
            //更新关注的联赛数据
            favorLeagueArray = [[FansCenterFetcher getFavorLeagueByUserID:[LeisureSportAppDelegate userID]] mutableCopy];        
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"操作成功";
            hud.margin = 10.f;
            hud.yOffset = 150.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:2];
        }
    }
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
