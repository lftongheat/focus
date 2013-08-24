//
//  CommentViewController.m
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-7.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "CommentViewController.h"
#import "LSUtil.h"
#import "FansCenterFetcher.h"
#import "Comment.h"
#import "LeisureSportAppDelegate.h"
#import "UIImageView+WebCache.h"
#import "MatchDetailsConrroller.h"

@implementation CommentViewController
@synthesize myUserID;

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)viewDidAppear:(BOOL)animated
{
    //获取数据
    if (myUserID && needReload) {
        if (commentArray) {
            [commentArray release];
            commentArray = nil;
        }
        commentArray = [[FansCenterFetcher fetchCommentWithUserID:myUserID Time:[LSUtil now] Count:20 Index:@""] mutableCopy];
        //更新表格
        [commentTableView reloadData];
        needReload = NO;
    }  
    //取消菊花等待状态
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[self.view viewWithTag:ACTIVITY_TAG];
    [activityIndicator stopAnimating];
}

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
    
	
    self.title = @"说说";
    
    commentTableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 10, 300, 348) style:UITableViewStylePlain];
	commentTableView.delegate=self;
	commentTableView.dataSource=self;
    commentTableView.allowsSelection = YES;    
	commentTableView.backgroundView = INNER_BG_VIEW_AUTORELEASE;
    [commentTableView setSeparatorColor:[UIColor clearColor]];
    
    //刷新控件
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[commentTableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
    
    [self.view addSubview:commentTableView];
	
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
    if (indexPath.row == [commentArray count])
        return 44;
    else
        return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [commentArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //在表格最后添加更多单元格
    if (indexPath.row == [commentArray count]) {
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
    
    Comment *comment = [commentArray objectAtIndex:indexPath.row];
    
    static NSString *cellID = @"ICell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
	} 
    else {
        //由于重用单元格 需要删除原来单元格的内容
        for (UIView *view in [cell subviews]){
            [view removeFromSuperview];
        }
    }
    
    //头像       
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
    //使用SDWebImage的图片缓存机制
    [imgView setImageWithURL:IMAGE_URL([LeisureSportAppDelegate userImageID]) placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
    [cell addSubview:imgView];
    [imgView release];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(70, 5, 230, 20);
    NSString *title = [NSString stringWithFormat:@"评论 %@ vs %@",comment.HomeTeamName, comment.AwayTeamName];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:17.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blueColor];
    [cell addSubview: titleLabel];
    [titleLabel release];
    
    //内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.frame = CGRectMake(70, 30, 230, 20);
    contentLabel.text = comment.Contents;
    contentLabel.font = [UIFont systemFontOfSize:13.0f];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textColor = [UIColor grayColor];
    [cell addSubview: contentLabel];
    [contentLabel release];
    
    //简介
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.frame = CGRectMake(70, 50, 228, 20);
    timeLabel.text = comment.time;
    timeLabel.textAlignment = UITextAlignmentRight;
    timeLabel.font = [UIFont systemFontOfSize:13.0f];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor grayColor];
    [cell addSubview: timeLabel];
    [timeLabel release];
    
    //间隔条
    UIImageView *seporatorImageView = [[UIImageView alloc] initWithImage:IMAGEWITHCONTENTSOFFILE(@"间隔条")];
    seporatorImageView.frame = CGRectMake(0, 69, 300, 1);
    [cell addSubview:seporatorImageView];
    [seporatorImageView release];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [commentArray count]) {
        UILabel *promptLabel = (UILabel *)[self.view viewWithTag: MORE_LABEL_TAG];
        promptLabel.text = @"加载中...";
        //激活菊花
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[self.view viewWithTag:ACTIVITY_TAG];
        [activityIndicator startAnimating];
        [self performSelectorInBackground:@selector(loadMore) withObject:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    Comment *comment = [commentArray objectAtIndex:indexPath.row];
    MatchDetailsConrroller *controller = [[MatchDetailsConrroller alloc] initWithFrame:2 gameID:comment.GameID];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//返回
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//更多
-(void)loadMore{
    Comment *last = [commentArray lastObject];
    if (last) {
        NSAutoreleasePool * pool=[[NSAutoreleasePool alloc] init];
        NSMutableArray *tmpArray = [[FansCenterFetcher fetchCommentWithUserID:myUserID Time:last.time Count:10 Index:last.CommentID] mutableCopy];
        for (int i=0; i<[tmpArray count]; i++) {
            [commentArray addObject:[tmpArray objectAtIndex:i]];
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
    [commentTableView reloadData];
}


-(void)requestData{
	NSAutoreleasePool * pool=[[NSAutoreleasePool alloc] init];
    if (commentArray) {
        [commentArray release];
        commentArray = nil;
    }
    commentArray = [[FansCenterFetcher fetchCommentWithUserID:myUserID Time:[LSUtil now] Count:10 Index:@""] mutableCopy];
	[pool release];
	
	//回到主线程跟新界面
	[self performSelectorOnMainThread:@selector(dosomething) withObject:nil waitUntilDone:YES];
    
}

-(void)dosomething
{
	[commentTableView reloadData];
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
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading: commentTableView];
//	NSLog(@"end");
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
	[myUserID release];
	_refreshHeaderView = nil;
    [commentTableView release];
    [commentArray release];
    [super dealloc];
}

@end
