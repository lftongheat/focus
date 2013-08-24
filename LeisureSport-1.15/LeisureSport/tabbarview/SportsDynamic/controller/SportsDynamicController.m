//
//  SportsdynamicViewController.m
//  DelightSports
//
//  Created by ACE hitsz302 on 12-5-18.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "SportsDynamicController.h"
#import "LeisureSportAppDelegate.h"
#import "SportsDynamicFetcher.h"
#import "SportsNews.h"
#import "NewsViewController.h"
#import "LSUtil.h"

#import "UIImageView+WebCache.h"

@implementation SportsDynamicController

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewdidappear");
    if ([LSUtil connectedToNetwork] && needReload) {
        NSLog(@"needReload");
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        //加载数据
        newsArray = [[SportsDynamicFetcher fetchNewsWithTime:[LSUtil now] Count:10] mutableCopy];
        [pool release];

        //更新表格
        [sportsTableView reloadData];
        needReload = NO;
    }
    //取消菊花等待状态
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[self.view viewWithTag:ACTIVITY_TAG];
    [activityIndicator stopAnimating];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    NSLog(@"loadView");
    
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 368)];	
    view.backgroundColor = [UIColor colorWithPatternImage:GREEN_BG_IMAGE];    
    UIImage *sdbgImg = IMAGEWITHCONTENTSOFFILE(@"体坛背景");
    UIImageView *sdbgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 368)];
    [sdbgView setImage:sdbgImg];
    [view addSubview:sdbgView];
    [sdbgView release];
    
	self.view=view;
	[view release];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];    
    self.title = @"体坛动态";
    
    needReload = YES;
    //首页按钮
    UIButton * backButton=[UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage:[UIImage imageNamed:@"首页按钮.png"] forState:0];
    [backButton setImage:[UIImage imageNamed:@"首页按钮按下.png"] forState:UIControlStateHighlighted];
	[backButton addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
	backButton.frame=CGRectMake(3,3, 48, 30);
	
    //刷新按钮
    UIButton * refreshButton=[UIButton buttonWithType:UIButtonTypeCustom];
	[refreshButton setImage:[UIImage imageNamed:@"刷新按钮.png"] forState:UIControlStateNormal];
    [refreshButton setImage:[UIImage imageNamed:@"刷新按钮按下.png"] forState:UIControlStateHighlighted];
	[refreshButton addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
	refreshButton.frame=CGRectMake(303,3, 48, 30);
    
	UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.leftBarButtonItem = back;
    self.navigationItem.rightBarButtonItem = refresh;
    [back release];
    [refresh release];
    
    
    //    self.title = @"体坛动态";
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NaviBarBg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    if ([self.tabBarController.tabBar respondsToSelector:@selector(setBackgroundImage:)]) {
        [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"TabBarBg.png"]];
    }
    
    //表格
    sportsTableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 10, 300, 348) style:UITableViewStylePlain];
	sportsTableView.delegate=self;
	sportsTableView.dataSource=self;
    sportsTableView.allowsSelection = YES;
    sportsTableView.backgroundView = INNER_BG_VIEW_AUTORELEASE;
    [sportsTableView setSeparatorColor:[UIColor clearColor]];
    
    //刷新控件
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[sportsTableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
    
    [self.view addSubview:sportsTableView];
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void)backToHome
{
	LeisureSportAppDelegate *app=[[UIApplication sharedApplication] delegate];
	
	[app gotoController:LSHomeViewController selection:OthersController];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [newsArray count])
        return 44;
    else
        return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [newsArray count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //在表格最后添加更多单元格
    if (indexPath.row == [newsArray count]) {
        NSString *CellIdentifier = @"MoreCell";
        UITableViewCell *loadMoreCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!loadMoreCell) {
            loadMoreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            loadMoreCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        //由于重用单元格 需要删除原来单元格的内容
        for (UIView *view in [loadMoreCell subviews]){
            [view removeFromSuperview];
        }
        
        UILabel *promptLabel = [[UILabel alloc] init];
        promptLabel.frame = CGRectMake(130, 10, 100, 20);
        promptLabel.tag = MORE_LABEL_TAG;
        promptLabel.font = [UIFont systemFontOfSize:13];
        //菊花
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame = CGRectMake(20.0f, 5.0f, 32.0f, 32.0f);
        activityIndicator.tag = ACTIVITY_TAG;
        if ([LSUtil connectedToNetwork] && indexPath.row == 0) {
            [activityIndicator startAnimating];
            promptLabel.text = @"加载中...";
        } else {
            promptLabel.text = @"更多";
        }
        
        [loadMoreCell addSubview:activityIndicator];
        [activityIndicator release];
        [loadMoreCell addSubview:promptLabel];
        [promptLabel release];
        return  loadMoreCell;
    }
    SportsNews *news = [newsArray objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString: news.ImageUrl];
    
	static NSString *cellID = @"ICell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
	}
    //由于重用单元格 需要删除原来单元格的内容
    for (UIView *view in [cell subviews]){
        [view removeFromSuperview];
    }

    //图片
    if (url) {
        UIImageView *bgImageView = [[UIImageView alloc] init];
        bgImageView.frame = CGRectMake(5, 5, 80, 80);
        bgImageView.image = IMAGEWITHCONTENTSOFFILE(@"图片背景");
    
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
        //使用SDWebImage的图片缓存机制
        [imgView setImageWithURL:url placeholderImage:IMAGEWITHCONTENTSOFFILE(@"没有图片时替代")];
        [bgImageView addSubview:imgView];
        [imgView release];
        
        
        [cell addSubview:bgImageView];
        [bgImageView release];
    }
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(90, 0, 200, 20);
    titleLabel.text = news.Title;
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    [cell addSubview: titleLabel];
    [titleLabel release];
    
    //简介
    UILabel *introLabel = [[UILabel alloc] init];
    introLabel.frame = CGRectMake(90, 21, 200, 60);
    introLabel.text = news.ShortIntro;
    introLabel.font = [UIFont systemFontOfSize:10.0f];
    introLabel.numberOfLines = 0;
    introLabel.lineBreakMode = UILineBreakModeWordWrap;
    introLabel.backgroundColor = [UIColor clearColor];
    [cell addSubview: introLabel];
    [introLabel release];
    
    //间隔条
    UIImageView *seporatorImageView = [[UIImageView alloc] initWithImage:IMAGEWITHCONTENTSOFFILE(@"间隔条")];
    seporatorImageView.frame = CGRectMake(0, 89, 300, 1);
    [cell addSubview:seporatorImageView];
    [seporatorImageView release];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [newsArray count]) {
        UILabel *promptLabel = (UILabel *)[self.view viewWithTag:MORE_LABEL_TAG];
        promptLabel.text = @"加载中...";
        //激活菊花
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[self.view viewWithTag:ACTIVITY_TAG];
        [activityIndicator startAnimating];
        [self performSelectorInBackground:@selector(loadMore) withObject:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        return;
    }
    SportsNews *news = [newsArray objectAtIndex:indexPath.row];
    
    NewsViewController *newsVC = [[NewsViewController alloc] init];
    newsVC.urlStr = news.Url;
    [self.navigationController pushViewController:newsVC animated:YES];
    [newsVC release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//更多
-(void)loadMore{
    SportsNews *news = [newsArray lastObject];
    if (news) {
        NSAutoreleasePool * pool=[[NSAutoreleasePool alloc] init];
        NSMutableArray *tmpArray = [[SportsDynamicFetcher fetchNewsWithTime:news.PostTime Count:5 Index:news.NewsID] mutableCopy];
        for (int i=0; i<[tmpArray count]; i++) {
            [newsArray addObject:[tmpArray objectAtIndex:i]];
        }
        [tmpArray release];
        [pool release];
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[self.view viewWithTag:ACTIVITY_TAG];
        [activityIndicator stopAnimating];
        [self performSelectorOnMainThread:@selector(updateTable) withObject:nil waitUntilDone:YES];
    }
}

//更新表格
-(void)updateTable{
    [sportsTableView reloadData];    
}


//请求数据
-(void)requestData{
	NSAutoreleasePool * pool=[[NSAutoreleasePool alloc] init];
    if (newsArray) {
        [newsArray release];
        newsArray = nil;
    }
    newsArray = [[SportsDynamicFetcher fetchNewsWithTime:[LSUtil now] Count:10] mutableCopy];
	[pool release];
	
	//回到主线程跟新界面
	[self performSelectorOnMainThread:@selector(finishRequest) withObject:nil waitUntilDone:YES];
    
}

//完成请求
-(void)finishRequest
{
	
    //	int count=[newsArray count];
	
    //大于一定数量即完全隐藏下拉刷新控件
    //	if(100*count>800)
    //	{
    //		sportsTableView.contentSize=CGSizeMake(320, 100*count);
    //		_refreshHeaderView.frame=CGRectMake(0, sportsTableView.contentSize.height, 320, 480);
    //	}
	[sportsTableView reloadData];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    NSLog(@"start");
    //打开线程，读取网络图片
	[NSThread detachNewThreadSelector:@selector(requestData) toTarget:self withObject:nil];
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading: sportsTableView];
	NSLog(@"end");
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    //	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	_refreshHeaderView=nil;
}

- (void)dealloc {
	NSLog(@"dealloc");
	_refreshHeaderView = nil;
    [sportsTableView release];
    [newsArray release];
    [super dealloc];
}

@end