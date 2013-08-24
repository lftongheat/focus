//
//  TVLiveViewController.m
//  DelightSports
//
//  Created by ACE hitsz302 on 12-5-18.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "TVLiveController.h"
#import "LeisureSportAppDelegate.h"
#import "LSUtil.h"
#import "TVLiveFetcher.h"
#import "TVLiveCell.h"
#import "GameLive.h"
#import "MatchDetailsConrroller.h"
#import "UIImageView+WebCache.h"


@implementation TVLiveController


#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [activityIndicator startAnimating];  
}

- (void)viewDidAppear:(BOOL)animated
{
	//加载数据
    if ([LSUtil connectedToNetwork]) {
        if (tvLiveArray) {
            [tvLiveArray release];
            tvLiveArray = nil;
        }
        tvLiveArray = [TVLiveFetcher fetchLive];
        [tvLiveTableView reloadData];
    }
    
    
    //加载结束
    [activityIndicator stopAnimating];    

    UIView *view = (UIView *)[self.view viewWithTag:108];
    [view removeFromSuperview];
    
    if([tvLiveArray count]==0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"暂无数据";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.5];
        
    }
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 368)];
	
    view.backgroundColor = [UIColor colorWithPatternImage:GREEN_BG_IMAGE];
    
	self.view=view;
	[view release];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    //返回首页按钮
    UIButton * backButton=[UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"首页按钮" ofType:@"png"]] forState:0];
	[backButton addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
	backButton.frame=CGRectMake(3,3, 49, 31);
	
    //刷新按钮
    UIButton * refreshButton=[UIButton buttonWithType:UIButtonTypeCustom];
	[refreshButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"刷新按钮" ofType:@"png"]] forState:0];
    [refreshButton addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
	refreshButton.frame=CGRectMake(303,3, 41, 41);
    
    
	UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.leftBarButtonItem = back;
    self.navigationItem.rightBarButtonItem = refresh;
    [back release];
    [refresh release];
	
    //导航栏设置
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NaviBarBg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    if ([self.tabBarController.tabBar respondsToSelector:@selector(setBackgroundImage:)]) {
        [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"TabBarBg.png"]];
    }
    self.title = @"电视直播";
    
    UIImageView *topBg = PALEGREEN_BG_VIEW;
    topBg.frame = CGRectMake(0, 0, 320, 365);

    [self.view addSubview:topBg];
    topBg.userInteractionEnabled = YES;
    
    //直播列表
    tvLiveTableView =[[UITableView alloc] initWithFrame:CGRectMake(5, 5, 310, 350) style:UITableViewStyleGrouped];
    tvLiveTableView.backgroundColor = [UIColor clearColor];
	tvLiveTableView.delegate=self;
	tvLiveTableView.dataSource=self;
    tvLiveTableView.allowsSelection = YES;
	
    [topBg addSubview:tvLiveTableView];
    
    
    [topBg release];
    
    //创建UIActivityIndicatorView背底半透明View    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.8];
    [self.view addSubview:view];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:activityIndicator];
    [view release];

}

-(void) refreshAction//刷新事件
{

    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	HUD.delegate = self;
	[HUD show:YES];
    

    //加载数据
    if ([LSUtil connectedToNetwork]) {
        if (tvLiveArray) {
            [tvLiveArray release];
            tvLiveArray = nil;
        }
        tvLiveArray = [TVLiveFetcher fetchLive];
        [tvLiveTableView reloadData];
    }
    
    //加载结束
    [HUD hide:YES];
    
    if([tvLiveArray count]==0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"暂无数据";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.5];
        
    }

}


- (void)backToHome//返回首页
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [tvLiveArray count];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TVLiveCell *cell = (TVLiveCell *)[tableView dequeueReusableCellWithIdentifier:@"TVLiveCell"];
	if (!cell) 
	{
		cell = [[[NSBundle mainBundle] loadNibNamed:@"TVLiveCell" owner:self options:nil] lastObject];
        //		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    GameLive *live = [tvLiveArray objectAtIndex:indexPath.section];
    NSURL *homeImgUrl = [NSURL URLWithString: live.HomeTeamImageUrl];
    //cell.homeTeamImg.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:homeImgUrl]];
    [cell.homeTeamImg setImageWithURL:homeImgUrl placeholderImage:[UIImage imageNamed:@"没有图片时替代.png"]];
    NSURL *awayImgUrl = [NSURL URLWithString: live.AwayTeamImageUrl];
    //cell.awayTeamImg.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:awayImgUrl]];
    [cell.awayTeamImg setImageWithURL:awayImgUrl placeholderImage:[UIImage imageNamed:@"没有图片时替代.png"]];
    
    
    
    cell.gameTime.text=live.GameTime;
    cell.homeTeamName.text=live.HomeName;
    cell.awayTeamName.text=live.AwayName;
    if([live.IsFinished isEqualToString:@"3"])
    {
        cell.isFinished.text = @"已结束";
    }else if([live.IsFinished isEqualToString:@"0"])
    {
        cell.isFinished.text = @"未开始";
    }else
    {
        cell.isFinished.text = @"进行中";
    }
    //cell.liveTVAll.adjustsFontSizeToFitWidth = YES;
    cell.liveTVAll.text=live.TVLiveAll;
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GameLive *gamelive = [tvLiveArray objectAtIndex:indexPath.section];
    NSString *gameID = gamelive.GameID;
    
    //跳转到赛事详情
    MatchDetailsConrroller *matchDetails = [[MatchDetailsConrroller alloc] initWithFrame:0 gameID:gameID];
    [self.navigationController pushViewController:matchDetails animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[hud removeFromSuperview];
	[hud release];
	hud = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	//_refreshHeaderView=nil;
}

- (void)dealloc {
    [tvLiveTableView release];
    [tvLiveArray release];
    
//    [remindNoData release];
    [activityIndicator release];
    [super dealloc];
}

@end
