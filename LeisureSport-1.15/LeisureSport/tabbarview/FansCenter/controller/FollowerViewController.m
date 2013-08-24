//
//  FollowerViewController.m
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-7.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "FollowerViewController.h"
#import "LSUtil.h"
#import "FansCenterFetcher.h"
#import "Follower.h"
#import "UserDetailController.h"
#import "LeisureSportAppDelegate.h"
#import "UIImageView+WebCache.h"
#import "UserInfoPlistIO.h"

@implementation FollowerViewController
@synthesize myUserID;

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    //获取数据
    if (myUserID && needReload) {
        if (followerArray) {
            [followerArray release];
            followerArray = nil;
        }
        followerArray = [[FansCenterFetcher fetchFollowerWithUserID:myUserID Time:[LSUtil now] Count:10 Index:@"" Online:@"true"] mutableCopy];
        //更新表格
        [followerTableView reloadData];
        
        needReload = NO;
    }  
    //取消菊花等待状态
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[self.view viewWithTag:ACTIVITY_TAG];
    [activityIndicator stopAnimating];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460-44-48)];
    view.backgroundColor = [UIColor colorWithPatternImage:GREEN_BG_IMAGE];
    
    UIImageView *palegreenBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 368)];
    [palegreenBg setImage: IMAGEWITHCONTENTSOFFILE(@"palegreenbg")];
    [view addSubview:palegreenBg];
    [palegreenBg release];
    
	self.view=view;
	[view release];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    needReload = YES;
    firstLoad = YES;
    //添加左导航键
    UIButton * backButton=[UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"返回按钮按下.png"] forState:UIControlStateHighlighted];
	[backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
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

  
	
    self.title = @"关注";
    
    followerTableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 10, 300, 348) style:UITableViewStylePlain];
	followerTableView.delegate=self;
	followerTableView.dataSource=self;
    followerTableView.allowsSelection = YES;   
    followerTableView.backgroundView = INNER_BG_VIEW_AUTORELEASE;
	[followerTableView setSeparatorColor:[UIColor clearColor]];
    
    //刷新控件
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[followerTableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
    
    [self.view addSubview:followerTableView];
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
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
    if (indexPath.row == [followerArray count])
        return 44;
    else
        return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [followerArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //在表格最后添加更多单元格
    if (indexPath.row == [followerArray count]) {
        NSString *CellIdentifier = @"MoreCell";
        UITableViewCell *loadMoreCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (loadMoreCell == nil) {
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
        if (firstLoad) {
            [activityIndicator startAnimating];
            promptLabel.text = @"加载中...";
            firstLoad = NO;
        } else {
            promptLabel.text = @"更多";
        }
        
        [loadMoreCell addSubview:activityIndicator];
        [activityIndicator release];
        [loadMoreCell addSubview:promptLabel];
        [promptLabel release];
        return  loadMoreCell;
    }
    
    Follower *follower = [followerArray objectAtIndex:indexPath.row];   
    
	static NSString *cellID = @"ICell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
	} else {
        //由于重用单元格 需要删除原来单元格的内容
        for (UIView *view in [cell subviews]){
            [view removeFromSuperview];
        }
    }
    
    //头像       
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    //使用SDWebImage的图片缓存机制
    [imgView setImageWithURL:IMAGE_URL(follower.ImageID) placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
    [cell addSubview:imgView];
    [imgView release];
    
    //昵称
    UILabel *nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.frame = CGRectMake(60, 5, 240, 20);
    nickNameLabel.text = follower.NickName;
    nickNameLabel.font = [UIFont systemFontOfSize:17.0f];
    nickNameLabel.backgroundColor = [UIColor clearColor];
    nickNameLabel.textColor = [UIColor blueColor];
    [cell addSubview: nickNameLabel];
    [nickNameLabel release];
    
    //简介
    UILabel *introduceLabel = [[UILabel alloc] init];
    introduceLabel.frame = CGRectMake(60, 30, 240, 20);
    NSString *info = [NSString stringWithFormat:@"个人介绍：%@",follower.PersonelInfo];
    introduceLabel.text = info;
    introduceLabel.font = [UIFont systemFontOfSize:13.0f];
    introduceLabel.backgroundColor = [UIColor clearColor];
    introduceLabel.textColor = [UIColor blueColor];
    [cell addSubview: introduceLabel];
    [introduceLabel release];
    
    //间隔条
    UIImageView *seporatorImageView = [[UIImageView alloc] initWithImage:IMAGEWITHCONTENTSOFFILE(@"间隔条")];
    seporatorImageView.frame = CGRectMake(0, 59, 300, 1);
    [cell addSubview:seporatorImageView];
    [seporatorImageView release];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [followerArray count]) {
        UILabel *promptLabel = (UILabel *)[self.view viewWithTag: MORE_LABEL_TAG];
        promptLabel.text = @"加载中...";
        //激活菊花
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[self.view viewWithTag:ACTIVITY_TAG];
        [activityIndicator startAnimating];
        [self performSelectorInBackground:@selector(loadMore) withObject:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    Follower *follower = [followerArray objectAtIndex:indexPath.row];
    
    UserDetailController *userDetailController = [[UserDetailController alloc] init];
    userDetailController.userID = follower.UserID;
    userDetailController.myUserID = myUserID;
    [self.navigationController pushViewController:userDetailController animated:YES];
    [userDetailController release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//返回
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

//更多
-(void)loadMore{
    Follower *lastfollower = [followerArray lastObject];
    if (lastfollower) {
        NSAutoreleasePool * pool=[[NSAutoreleasePool alloc] init];
        NSMutableArray *tmpArray = nil;
        if (myUserID) {
            tmpArray = [[FansCenterFetcher fetchFollowerWithUserID:myUserID Time:lastfollower.LastLoginTime Count:5 Index:lastfollower.UserID Online:lastfollower.isOnLine] mutableCopy];
        }
        for (int i=0; i<[tmpArray count]; i++) {
            [followerArray addObject:[tmpArray objectAtIndex:i]];
        }
        [tmpArray release];
        [pool release];        
    }
    
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[self.view viewWithTag:ACTIVITY_TAG];
    [activityIndicator stopAnimating];
    [self performSelectorOnMainThread:@selector(updateTable) withObject:nil waitUntilDone:YES];
}

//更新表格
-(void)updateTable{
    [followerTableView reloadData];
}

-(void)requestData{
	NSAutoreleasePool * pool=[[NSAutoreleasePool alloc] init];
    if (followerArray) {
        [followerArray release];
        followerArray = nil;
    }
    followerArray = [[FansCenterFetcher fetchFollowerWithUserID:myUserID Time:[LSUtil now] Count:10 Index:@"" Online:@"true"] mutableCopy];
	[pool release];
	
	//回到主线程跟新界面
	[self performSelectorOnMainThread:@selector(dosomething) withObject:nil waitUntilDone:YES];
    
}

-(void)dosomething
{
	[followerTableView reloadData];
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
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading: followerTableView];
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
	
	_refreshHeaderView = nil;
    [followerTableView release];
    [followerArray release];
    [super dealloc];
}

@end
