//
//  MatchDetails.m
//  LeisureSport
//
//  Created by 高 峰 on 12-6-1.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "MatchDetailsConrroller.h"
#import "DetailsCommentCustomCell.h"
#import "LSUtil.h"
#import "DetailInfo.h"
#import "IWatchFetcher.h"
#import "GameComments.h"
#import "CommentPublish.h"
#import "UserInfoPlistIO.h"
#import "LoginViewController.h"
#import "LeisureSportAppDelegate.h"
#import "UserDetailController.h"
#import "UIButton+WebCache.h"
#import "QuizChartView.h"
#import "DetailsSupportCell.h"

@implementation MatchDetailsConrroller

@synthesize topView;
@synthesize bottomView;
@synthesize detailsSementedControl;
@synthesize detailsTableView;
@synthesize webView;
@synthesize currentGameID;
@synthesize detailArray;
@synthesize currentGameDetail;
@synthesize comment;
@synthesize bottomBg;
@synthesize segmentedNumber;


- (id) initWithFrame:(NSInteger)selected gameID:(NSString *)gameid//初始化，参数为分段按钮选项和当前比赛的ID
{
    if(selected==0)
    {
        segmentedNumber=0;
    }else if(selected==1)
    {
        segmentedNumber=1;
    }else if(selected==2)
    {
        segmentedNumber=2;
    }
    currentGameID=gameid;
    return self;
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) dealloc
{
    [topView release];
    [bottomView release];
    [detailsSementedControl release];
    [detailArray release];
    //[currentGameDetail release];///////////////////////////////!!!!!

    [comment release];
    [bottomBg release];
    _refreshHeaderView=nil;
    [usrID release];

    [LastA release];
    [lastB release];
    [tmpArray release];
    [super dealloc];

}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    if(LastA)
    {
        [LastA release];
        LastA = nil;
    }
    if(lastB)
    {
        [lastB release];
        lastB=nil;
    }
    LastA=@"50";
    lastB=@"50";
    isfIRST = 0;

    [self refreshAction];

}

- (void)viewDidAppear:(BOOL)animated
{
    
    //加载结束
   // [activityIndicator stopAnimating]; 
        
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
    
    if(usrID)
    {
        [usrID release];
        usrID=nil;
    }
    
    UserInfoPlistIO *userInfoPlistIO = [[UserInfoPlistIO alloc] init];
    usrID = [[userInfoPlistIO readUserID:@""] mutableCopy];
    [userInfoPlistIO release];
    
    
    NSLog(@"usrID%@",usrID);
	
    //添加左导航键
    UIButton * backButton=[UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"返回按钮按下.png"] forState:UIControlStateHighlighted];
	[backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	backButton.frame=CGRectMake(3,3, 48, 30);
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = back;
    [back release];
    
    //刷新按钮
    UIButton * refreshButton=[UIButton buttonWithType:UIButtonTypeCustom];
	[refreshButton setImage:[UIImage imageNamed:@"刷新按钮.png"] forState:UIControlStateNormal];
    [refreshButton setImage:[UIImage imageNamed:@"刷新按钮按下.png"] forState:UIControlStateHighlighted];
    [refreshButton addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
	refreshButton.frame=CGRectMake(303,3, 41, 41);
    
    
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.rightBarButtonItem = refresh;
    [refresh release];
    
    
    
    self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:(82.0/255.0) green:(81.0/255.0) blue:(81.0/255.0) alpha:1];
    self.title = @"赛事详情";
    
    
    //显示比赛双方、比赛时间、比分、比赛类别
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    UIImageView *top = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    top.image = [UIImage imageNamed:@"头条.png"];
    
    UILabel *teamA = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
    teamA.textAlignment = UITextAlignmentCenter;
    teamA.backgroundColor = [UIColor clearColor];
    //teamA.font = [UIFont boldSystemFontOfSize:15];
    teamA.textColor = [UIColor whiteColor];
    teamA.adjustsFontSizeToFitWidth = YES;
    [teamA setTag:151];
   // teamA.text = currentGameDetail.HomeName;
    
    UILabel *score = [[UILabel alloc] initWithFrame:CGRectMake(125, 0, 70, 30)];
    score.textAlignment = UITextAlignmentCenter;
    score.adjustsFontSizeToFitWidth = YES;
    score.backgroundColor = [UIColor clearColor];

    [score setTag:152];
//    score.text = [[currentGameDetail.HomeTeamScore stringByAppendingString:@"-"]stringByAppendingString:currentGameDetail.AwayTeamScore];
    
    UILabel *teamB = [[UILabel alloc] initWithFrame:CGRectMake(205, 0, 100, 30)];
    teamB.textAlignment = UITextAlignmentCenter;
    teamB.backgroundColor = [UIColor clearColor];
    teamB.textColor = [UIColor whiteColor];
    teamB.adjustsFontSizeToFitWidth = YES;
    [teamB setTag:153];
//    teamB.text = currentGameDetail.AwayName;
    
    
    [topView addSubview:top];
    [topView addSubview:teamA];
    [topView addSubview:score];
    [topView addSubview:teamB];
    [teamA release];
    [score release];
    [teamB release];
    [top release];
    
    [self.view addSubview:topView];
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(20, 27, 280, 30)];
    UIImageView *bottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
    bottom.image = [UIImage imageNamed:@"头条下.png"];
    
    UIImageView *star = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 15, 15)];
    star.backgroundColor = [UIColor clearColor];
    star.image = [UIImage imageNamed:@"黄色星.png"];
    
    UILabel *league = [[UILabel alloc] initWithFrame:CGRectMake(45, 2, 45, 25)];
    league.backgroundColor = [UIColor clearColor];
    league.textColor = [UIColor blueColor];
    league.adjustsFontSizeToFitWidth = YES;
    [league setTag:154];
//    league.text = currentGameDetail.Name;
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 110, 30)];
    time.backgroundColor = [UIColor clearColor];
    time.textColor = [UIColor blueColor];
    time.adjustsFontSizeToFitWidth = YES;
    [time setTag:155];
//    time.text = currentGameDetail.GameTime;
    
    UILabel *proceedOrFinished = [[UILabel alloc] initWithFrame:CGRectMake(210, 2, 50, 25)];
    proceedOrFinished.backgroundColor = [UIColor clearColor];
    proceedOrFinished.textColor = [UIColor blueColor];
    proceedOrFinished.adjustsFontSizeToFitWidth = YES;
    [proceedOrFinished setTag:156];
//    if([currentGameDetail.IsFinished isEqualToString:@"3"])
//    {
//        proceedOrFinished.text = @"已结束";
//    }else if([currentGameDetail.IsFinished isEqualToString:@"0"])
//    {
//        proceedOrFinished.text = @"未开始";
//    }else
//    {
//        proceedOrFinished.text = @"进行中";
//    }
    
//    [currentGameDetail release];
    
    [bottomView addSubview:bottom];
    [bottomView addSubview:star];
    [bottomView addSubview:league];
    [bottomView addSubview:time];
    [bottomView addSubview:proceedOrFinished];
    
    [bottom release];
    [star release];
    [league release];
    [time release];
    [proceedOrFinished release];
    
    [self.view addSubview:bottomView];
    
    bottomBg = PALEGREEN_BG_VIEW;
    bottomBg.frame = CGRectMake(0, 60, 320, 310);
    bottomBg.userInteractionEnabled = YES;
    
    //初始化分段按钮
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"分析",@"赛况",@"评论", nil];
    detailsSementedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    detailsSementedControl.frame = CGRectMake(20, 15, 280, 40);
    detailsSementedControl.selectedSegmentIndex = segmentedNumber;
    detailsSementedControl.tintColor = [UIColor redColor];
    detailsSementedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    //segmentedContorller.momentary = YES;
    [bottomBg addSubview:detailsSementedControl];
    [detailsSementedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [segmentedArray release];
    
    if(segmentedNumber==2)
    {
        detailsTableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 55, 300, 245) style:UITableViewStyleGrouped];
    }else
    {
        detailsTableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 50, 300, 250) style:UITableViewStyleGrouped];
    }

    detailsTableView.backgroundColor = [UIColor clearColor];
//    detailsTableView.clipsToBounds = NO;
	detailsTableView.delegate=self;
	detailsTableView.dataSource=self;
    if(segmentedNumber==2)
    {
        detailsTableView.scrollEnabled=YES;
        detailsTableView.allowsSelection = YES;
    }else
    {
        detailsTableView.scrollEnabled=NO;
        detailsTableView.allowsSelection = NO;
    }
	
    detailsTableView.sectionFooterHeight = 0;
    detailsTableView.sectionHeaderHeight = 5;
    detailsTableView.userInteractionEnabled = YES;
    
    //如果为获取评论tableview，为其添加下拉刷新
    if(segmentedNumber==2)
    {
        if (_refreshHeaderView == nil) {
            
            EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.detailsTableView.bounds.size.height, self.view.frame.size.width, self.detailsTableView.bounds.size.height)];
            view.delegate = self;
            [detailsTableView addSubview:view];
            _refreshHeaderView = view;
            [view release];
            
        }
        
        
        [bottomBg addSubview:detailsTableView];
        [self.view addSubview:bottomBg];
        [detailsTableView release];
        
        
        //  update the last update date
        [_refreshHeaderView refreshLastUpdatedDate];
    }else
    {
        [bottomBg addSubview:detailsTableView];
        [self.view addSubview:bottomBg];
        [detailsTableView release];
    }
    

    comment = [[ CommentPublish alloc] initWithFrame:CGRectMake(0, 340, 320, 130) Delegate:(id)self];

    [self.view addSubview:comment];
     
    //分段按钮为分析或评论时，隐藏赛况新闻
    if(segmentedNumber==0||segmentedNumber==1)
    {
        [comment setHidden:YES];
    }
    

   
}

- (void) segmentAction:(UISegmentedControl *) sender//分段按钮事件
{
    [comment.commentView resignFirstResponder];
    segmentedNumber = detailsSementedControl.selectedSegmentIndex;
    if(segmentedNumber==0||segmentedNumber==2)
    {
        [detailsTableView removeFromSuperview];
        //[webView removeFromSuperview];
        if(segmentedNumber==2)
        {
            
            detailsTableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 55, 300, 245) style:UITableViewStyleGrouped];
        }else
        {
            detailsTableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 50, 300, 250) style:UITableViewStyleGrouped];
        }
        detailsTableView.backgroundColor = [UIColor clearColor];
        detailsTableView.delegate=self;
        detailsTableView.dataSource=self;
        if(segmentedNumber==2)
        {
            detailsTableView.scrollEnabled=YES;
            detailsTableView.allowsSelection = YES;
        }else
        {
            detailsTableView.scrollEnabled=NO;
            detailsTableView.allowsSelection = NO;
        }
        detailsTableView.sectionFooterHeight = 0;
        detailsTableView.sectionHeaderHeight = 5;
        
        detailsTableView.userInteractionEnabled = YES;
        
        //为评论列表添加下拉刷新
        if(segmentedNumber==2)
        {
            if (_refreshHeaderView == nil) {
                
                EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.detailsTableView.bounds.size.height, self.view.frame.size.width, self.detailsTableView.bounds.size.height)];
                view.delegate = self;
                [detailsTableView addSubview:view];
                _refreshHeaderView = view;
                [view release];
                
            }
            
            [bottomBg addSubview:detailsTableView];
            [detailsTableView release];
            
            
            //  update the last update date
            [_refreshHeaderView refreshLastUpdatedDate];
           // _refreshHeaderView = nil;
        }else
        {
            _refreshHeaderView = nil;
            [bottomBg addSubview:detailsTableView];
            [detailsTableView release];
        }
        
        
        if(segmentedNumber==2)
        {
            [comment setHidden:NO];
        }else
        {
            [comment setHidden:YES];
        }
        [webView setHidden:YES];
        
    }else
    {
        //添加赛况新闻
        _refreshHeaderView=nil;
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 60, 300, 237)];
        NSString *urlString = currentGameDetail.Report;
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *reqObject = [NSURLRequest requestWithURL:url];
        webView.backgroundColor = [UIColor clearColor];
        [webView setDelegate:self];
        [webView loadRequest:reqObject];
        [bottomBg addSubview:webView];
        [webView release];
        [comment setHidden:YES];
    }
    [self refreshAction];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{ 
    if(segmentedNumber==0)
    {
	    return 2; 
    }else if(segmentedNumber==2)
    {
        return 1;
    }else
    {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
	//return [UIFont familyNames].count;
    if(segmentedNumber==0)
    {
        return 1;
    }else if(segmentedNumber==2)
    {
        return [detailArray count]+1;
    }else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(segmentedNumber==0)
    {
        if(indexPath.section==0)
        {
            static NSString *cellID = @"ICell";
            UITableViewCell *cell1 = [tView dequeueReusableCellWithIdentifier:cellID];
            if (!cell1){
                cell1 = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
            }
            //由于重用单元格 需要删除原来单元格的内容
            for (UIView *view in [cell1 subviews]){
                [view removeFromSuperview];
            }

            cell1.backgroundView = [[UIView alloc] initWithFrame:CGRectZero]; 
            [cell1.backgroundView release];
            
            UIImageView *bg = [[UIImageView alloc] init];
            bg.frame = CGRectMake(10, -3, 280, 116);
            
            
            
            UIImageView *bg1 = [[UIImageView alloc] init];
            bg1.frame = CGRectMake(0, 15, 280, 26);
            bg1.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"上框-320" ofType:@"png"]];
            [bg addSubview:bg1];
            [bg1 release];
            
            UIImageView *bg2 = [[UIImageView alloc] init];
            bg2.frame = CGRectMake(0, 38, 280, 26);
            bg2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"中框-320" ofType:@"png"]];
            [bg addSubview:bg2];
            [bg2 release];
            
            UIImageView *bg3 = [[UIImageView alloc] init];
            bg3.frame = CGRectMake(0, 64, 280, 27);
            bg3.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"下框-320" ofType:@"png"]];
            [bg addSubview:bg3];
            [bg3 release];
            
            UIImageView *bg4 = [[UIImageView alloc] init];
            bg4.frame = CGRectMake(0, 91, 280, 28);
            bg4.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"中框-320" ofType:@"png"]];
            [bg addSubview:bg4];
            [bg4 release];
            
            UILabel *teamA = [[UILabel alloc] init];
            teamA.frame = CGRectMake(89, 17, 82, 21);
            teamA.font = [UIFont systemFontOfSize:17.0f];
            teamA.adjustsFontSizeToFitWidth=YES;
            teamA.backgroundColor = [UIColor clearColor];
            teamA.textAlignment = UITextAlignmentCenter;
            teamA.text = currentGameDetail.HomeName;
            [bg addSubview:teamA];
            [teamA release];
            
            UILabel *teamB = [[UILabel alloc] init];
            teamB.frame = CGRectMake(190, 17, 82, 21);
            teamB.font = [UIFont systemFontOfSize:17.0f];
            teamB.adjustsFontSizeToFitWidth=YES;
            teamB.backgroundColor = [UIColor clearColor];
            teamB.textAlignment = UITextAlignmentCenter;
            teamB.text = currentGameDetail.AwayName;
            [bg addSubview:teamB];
            [teamB release];
            
            UILabel *RecentPerformance = [[UILabel alloc] init];
            RecentPerformance.frame = CGRectMake(10, 40, 62, 21);
            RecentPerformance.font = [UIFont systemFontOfSize:17.0f];
            RecentPerformance.adjustsFontSizeToFitWidth=YES;
            RecentPerformance.backgroundColor = [UIColor clearColor];
            RecentPerformance.textAlignment = UITextAlignmentCenter;
            RecentPerformance.text =@"最近战绩";
            [bg addSubview:RecentPerformance];
            [RecentPerformance release];
            
            UILabel *teamARecentPerformance = [[UILabel alloc] init];
            teamARecentPerformance.frame = CGRectMake(89, 40, 82, 21);
            teamARecentPerformance.font = [UIFont systemFontOfSize:17.0f];
            teamARecentPerformance.adjustsFontSizeToFitWidth=YES;
            teamARecentPerformance.backgroundColor = [UIColor clearColor];
            teamARecentPerformance.textAlignment = UITextAlignmentCenter;
            teamARecentPerformance.text = currentGameDetail.HomeRecentGameBox;
            [bg addSubview:teamARecentPerformance];
            [teamARecentPerformance release];
            
            UILabel *teamBRecentPerformance = [[UILabel alloc] init];
            teamBRecentPerformance.frame = CGRectMake(190, 40, 82, 21);
            teamBRecentPerformance.font = [UIFont systemFontOfSize:17.0f];
            teamBRecentPerformance.adjustsFontSizeToFitWidth=YES;
            teamBRecentPerformance.backgroundColor = [UIColor clearColor];
            teamBRecentPerformance.textAlignment = UITextAlignmentCenter;
            teamBRecentPerformance.text = currentGameDetail.AwayRecentGameBox;
            [bg addSubview:teamBRecentPerformance];
            [teamBRecentPerformance release];
            
            UILabel *RecentAgainst = [[UILabel alloc] init];
            RecentAgainst.frame = CGRectMake(10, 67, 62, 21);
            RecentAgainst.font = [UIFont systemFontOfSize:17.0f];
            RecentAgainst.adjustsFontSizeToFitWidth=YES;
            RecentAgainst.backgroundColor = [UIColor clearColor];
            RecentAgainst.textAlignment = UITextAlignmentCenter;
            RecentAgainst.text =@"最近交手";
            [bg addSubview:RecentAgainst];
            [RecentAgainst release];
            
            UILabel *teamARecentAgainst = [[UILabel alloc] init];
            teamARecentAgainst.frame = CGRectMake(89, 67, 82, 21);
            teamARecentAgainst.font = [UIFont systemFontOfSize:17.0f];
            //teamARecentPerformance.adjustsFontSizeToFitWidth=YES;
            teamARecentAgainst.backgroundColor = [UIColor clearColor];
            teamARecentAgainst.textAlignment = UITextAlignmentCenter;
            teamARecentAgainst.text = currentGameDetail.HomeBetweenRecentGameBox;
            [bg addSubview:teamARecentAgainst];
            [teamARecentAgainst release];
            
            UILabel *teamBRecentAgainst = [[UILabel alloc] init];
            teamBRecentAgainst.frame = CGRectMake(190, 67, 82, 21);
            teamBRecentAgainst.font = [UIFont systemFontOfSize:17.0f];
            //teamARecentPerformance.adjustsFontSizeToFitWidth=YES;
            teamBRecentAgainst.backgroundColor = [UIColor clearColor];
            teamBRecentAgainst.textAlignment = UITextAlignmentCenter;
            teamBRecentAgainst.text = currentGameDetail.AwayBetweenRecentGameBox;
            [bg addSubview:teamBRecentAgainst];
            [teamBRecentAgainst release];
            
            UILabel *SeasonPerformance = [[UILabel alloc] init];
            SeasonPerformance.frame = CGRectMake(10, 94, 62, 21);
            SeasonPerformance.font = [UIFont systemFontOfSize:17.0f];
            SeasonPerformance.adjustsFontSizeToFitWidth=YES;
            SeasonPerformance.backgroundColor = [UIColor clearColor];
            SeasonPerformance.textAlignment = UITextAlignmentCenter;
            SeasonPerformance.text =@"赛季战绩";
            [bg addSubview:SeasonPerformance];
            [SeasonPerformance release];
            
            UILabel *teamASeasonPerformance = [[UILabel alloc] init];
            teamASeasonPerformance.frame = CGRectMake(89, 94, 82, 21);
            teamASeasonPerformance.font = [UIFont systemFontOfSize:17.0f];
            //teamARecentPerformance.adjustsFontSizeToFitWidth=YES;
            teamASeasonPerformance.backgroundColor = [UIColor clearColor];
            teamASeasonPerformance.textAlignment = UITextAlignmentCenter;
            teamASeasonPerformance.text = currentGameDetail.HomeSeasonGameBox;
            [bg addSubview:teamASeasonPerformance];
            [teamASeasonPerformance release];
            
            UILabel *teamBSeasonPerformance = [[UILabel alloc] init];
            teamBSeasonPerformance.frame = CGRectMake(190, 94, 82, 21);
            teamBSeasonPerformance.font = [UIFont systemFontOfSize:17.0f];
            //teamARecentPerformance.adjustsFontSizeToFitWidth=YES;
            teamBSeasonPerformance.backgroundColor = [UIColor clearColor];
            teamBSeasonPerformance.textAlignment = UITextAlignmentCenter;
            teamBSeasonPerformance.text = currentGameDetail.AwaySeasonGameBox;
            [bg addSubview:teamBSeasonPerformance];
            [teamBSeasonPerformance release];
            
            UIImageView *bg5 = [[UIImageView alloc] init];
            bg5.frame = CGRectMake(134, 0, 47, 24);
            bg5.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"主队-320" ofType:@"png"]];
            [bg addSubview:bg5];
            [bg5 release];
            
            UILabel *teamAA = [[UILabel alloc] init];
            teamAA.frame = CGRectMake(136, 0, 42, 21);
            teamAA.font = [UIFont systemFontOfSize:17.0f];
            //teamARecentPerformance.adjustsFontSizeToFitWidth=YES;
            teamAA.backgroundColor = [UIColor clearColor];
            teamAA.textAlignment = UITextAlignmentCenter;
            teamAA.text = @"主队";
            [bg addSubview:teamAA];
            [teamAA release];
            
            UIImageView *bg6 = [[UIImageView alloc] init];
            bg6.frame = CGRectMake(235, 0, 47, 24);
            bg6.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"客队-320" ofType:@"png"]];
            [bg addSubview:bg6];
            [bg6 release];
            
            UILabel *teamBB = [[UILabel alloc] init];
            teamBB.frame = CGRectMake(237, 0, 42, 21);
            teamBB.font = [UIFont systemFontOfSize:17.0f];
            //teamARecentPerformance.adjustsFontSizeToFitWidth=YES;
            teamBB.backgroundColor = [UIColor clearColor];
            teamBB.textAlignment = UITextAlignmentCenter;
            teamBB.text = @"客队";
            [bg addSubview:teamBB];
            [teamBB release];
            
            [cell1 addSubview:bg];
            [bg release];


            return (UITableViewCell *) cell1;
            
        }else if(indexPath.section==1)
        {
            
            static NSString *cellID = @"ICell1";
            UITableViewCell *cell2 = [tView dequeueReusableCellWithIdentifier:cellID];
            if (!cell2){
                cell2 = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
            }
//            //由于重用单元格 需要删除原来单元格的内容
//            for (UIView *view in [cell2 subviews]){
//                [view removeFromSuperview];
//            }
            
            DetailsSupportCell *myCell = [[DetailsSupportCell alloc] init];
            myCell.frame = CGRectMake(9, 0, 282, 121);
            if([currentGameDetail.HomeUserBetsPointCount isEqualToString:@"0"]&&[currentGameDetail.AwayUserBetsPointCount isEqualToString:@"0"])
            {
                if(isfIRST>=1)
                {
                    [myCell initializeCell:(id)self homeSupport:@"50" awaySupport:@"50" aBegin:@"50" bBegin:@"50" aNumber:@"0" bNumber:@"0"];
                    isfIRST=-1;
                }
                isfIRST++;
                
                
            }else
            {
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = kCFNumberFormatterNoStyle;//取整（默认）
                NSNumber *tempA= [[NSNumber alloc] init];
                NSNumber *tempB= [[NSNumber alloc] init];
                tempA = [formatter numberFromString:currentGameDetail.HomeUserBetsPointCount];
                tempB = [formatter numberFromString:currentGameDetail.AwayUserBetsPointCount];
                
                float a = [tempA floatValue];
                float b = [tempB floatValue];
                
                float ratioA = a/(a+b)*100;
                float ratioB = b/(a+b)*100;
                
                NSNumber *resultA = [NSNumber numberWithFloat:ratioA];
                NSNumber *resultB = [NSNumber numberWithFloat:ratioB];
                
                
                if(isfIRST>=1)
                {
                    [myCell initializeCell:(id)self homeSupport:[formatter stringFromNumber:resultA] awaySupport:[formatter stringFromNumber:resultB] aBegin:LastA bBegin:lastB aNumber:currentGameDetail.HomeUserBetsPointCount bNumber:currentGameDetail.AwayUserBetsPointCount];
                    if(LastA)
                    {
                        [LastA release];
                        LastA=nil;
                    }
                    if(lastB)
                    {
                        [lastB release];
                        lastB=nil;
                    }
                    LastA = [[formatter stringFromNumber:resultA] mutableCopy];
                    lastB = [[formatter stringFromNumber:resultB] mutableCopy];
                    isfIRST=-1;
                }
                isfIRST++;
                
                [formatter release];
            }
            [cell2 addSubview:myCell];
            [myCell release];
            
            return (UITableViewCell *) cell2;
        }
    }else if(segmentedNumber==2)//如果为赛事评论，则为其添加加载更多cell
    {
        //在表格最后添加更多单元格
        if (indexPath.row == [detailArray count]) {
            NSString *CellIdentifier = @"MoreCell";
            UITableViewCell *loadMoreCell = [tView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!loadMoreCell) {
                loadMoreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                loadMoreCell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            //由于重用单元格 需要删除原来单元格的内容
            for (UIView *view in [loadMoreCell subviews]){
                [view removeFromSuperview];
            }
            
            UIImageView *bg=[[UIImageView alloc] init];
            bg.frame = CGRectMake(9, 0, 282, 44);
            bg.backgroundColor = [UIColor whiteColor];
            
            
            UIView *bgView1 = [[UIView alloc] init];
            bgView1.frame = CGRectMake(0, 0, 16, 13);
            bgView1.backgroundColor = [UIColor whiteColor];
            [bg addSubview:bgView1];
            [bgView1 release];
            
            UIView *bgView2 = [[UIView alloc] init];
            bgView2.frame = CGRectMake(266, 0, 16, 13);
            bgView2.backgroundColor = [UIColor whiteColor];
            [bg addSubview:bgView2];
            [bgView2 release];
            
//            bg.layer.borderWidth=1;
//            bg.layer.borderColor=[[UIColor lightGrayColor] CGColor];
            
            [bg.layer setCornerRadius:10.0];
            
            UILabel *promptLabel = [[UILabel alloc] init];
            promptLabel.frame = CGRectMake(132, 10, 100, 20);
            promptLabel.backgroundColor = [UIColor clearColor];
            promptLabel.tag = MORE_LABEL_TAG;
            promptLabel.font = [UIFont systemFontOfSize:13];
            
            //菊花
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicator.frame = CGRectMake(22.0f, 5.0f, 32.0f, 32.0f);
            activityIndicator.tag = ACTIVITY_TAG;
            if ([LSUtil connectedToNetwork] && indexPath.row == 0) {
                [activityIndicator startAnimating];
                promptLabel.text = @"加载中...";
            } else {
                promptLabel.text = @"更多";
            }
            
            [bg addSubview:activityIndicator];
            [activityIndicator release];
            [bg addSubview:promptLabel];
            [promptLabel release];
            [loadMoreCell addSubview:bg];
            [bg release];
            
            //loadMoreCell.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            return  loadMoreCell;
        }


        
        DetailsCommentCustomCell *cell3 = (DetailsCommentCustomCell *)[tView dequeueReusableCellWithIdentifier:@"BaseCell"];
        
        if (!cell3) 
        {
            cell3 = [[[NSBundle mainBundle] loadNibNamed:@"DetailsCommentCustomCell" owner:self options:nil] lastObject];
            cell3.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell3 initializeCell:(id)self];
        GameComments *gameComment = [detailArray objectAtIndex:indexPath.row];

        cell3.userID=gameComment.UserID;
        
        cell3.imageButton.backgroundColor = [UIColor grayColor];

        [cell3.imageButton setImageWithURL:IMAGE_URL(gameComment.UserImageID) placeholderImage:IMAGEWITHCONTENTSOFFILE(@"默认头像")];
        cell3.name.text = gameComment.NickName;
        cell3.commentTime.text = gameComment.time;
        cell3.comment.text = gameComment.Contents;
        
        return (UITableViewCell *) cell3;
    }
    return nil;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(segmentedNumber==2)
    {
        if (indexPath.row == [detailArray count]) {
            return 44;
        }
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }else
    {
        if(indexPath.section==0)
        {
            return 116;
        }else
        {
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height+80;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
//	    if (indexPath.row == [detailArray count]) {
//        loadMoreCell.statusLabel.text = @"加载中...";
//        [self performSelectorInBackground:@selector(loadMore) withObject:nil];
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        return;
//    }
    
    if (indexPath.row == [detailArray count]) {
        UILabel *promptLabel = (UILabel *)[self.view viewWithTag:MORE_LABEL_TAG];
        promptLabel.text = @"加载中...";
        //激活菊花
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[self.view viewWithTag:ACTIVITY_TAG];
        [activityIndicator startAnimating];
        [self performSelectorInBackground:@selector(loadMore) withObject:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        return;
    }

}

//返回
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//更多
-(void)loadMore{
    
     NSAutoreleasePool * pool=[[NSAutoreleasePool alloc] init];
    if([detailArray count]==0)
    {
        if(detailArray)
        {
            [detailArray release];
            detailArray = nil;
        }
        detailArray = [[IWatchFetcher fetchComment:[LSUtil now] Count:10 gameID:currentGameID Index:@"0" userID:usrID] mutableCopy];
    }else
    {
       
        GameComments *gameComment = [detailArray lastObject];
        NSMutableArray *tpArray = [[IWatchFetcher fetchComment:gameComment.time Count:10 gameID:currentGameID Index:gameComment.CommentID userID:usrID] mutableCopy];
        
        for (int i=0; i<[tpArray count]; i++) {
            [detailArray addObject:[tpArray objectAtIndex:i]];
        }
        [tpArray release];
    }
    [pool release];
    
    [self performSelectorOnMainThread:@selector(updateTable) withObject:nil waitUntilDone:YES];
    
}

//更新表格
-(void)updateTable{
    [detailsTableView reloadData];
}

-(void) refreshAction
{    
    if([LSUtil connectedToNetwork])
    {
        //根据分段按钮选项初始化tableview数据
        if(segmentedNumber==0)
        {
            
            if(tmpArray)
            {
                [tmpArray release];
                tmpArray=nil;
            }
            tmpArray = [[IWatchFetcher fetchDetailInfo:currentGameID userID:usrID] mutableCopy];
            currentGameDetail = [tmpArray objectAtIndex:0];
        }else if(segmentedNumber==2)
        {
            
            if(tmpArray)
            {
                [tmpArray release];
                tmpArray=nil;
            }
            tmpArray = [[IWatchFetcher fetchDetailInfo:currentGameID userID:usrID] mutableCopy];
            
            
            currentGameDetail = [tmpArray objectAtIndex:0];
            if(detailArray)
            {
                [detailArray release];
                detailArray = nil;
            }
            detailArray = [[IWatchFetcher fetchComment:[LSUtil now] Count:10 gameID:currentGameID Index:@"0" userID:usrID] mutableCopy];
        }
        
        [detailsTableView reloadData];
        
        
        UILabel *teamA = (UILabel *)[self.view viewWithTag:151];
        teamA.text = currentGameDetail.HomeName;
        UILabel *score = (UILabel *)[self.view viewWithTag:152];
        score.text = [[currentGameDetail.HomeTeamScore stringByAppendingString:@"-"]stringByAppendingString:currentGameDetail.AwayTeamScore];
        UILabel *teamB = (UILabel *)[self.view viewWithTag:153];
        teamB.text = currentGameDetail.AwayName;
        UILabel *league = (UILabel *)[self.view viewWithTag:154];
        league.text = currentGameDetail.Name;
        UILabel *time = (UILabel *)[self.view viewWithTag:155];
        time.text = currentGameDetail.GameTime;
        UILabel *proceedOrFinished = (UILabel *)[self.view viewWithTag:156];
        if([currentGameDetail.IsFinished isEqualToString:@"3"])
        {
            proceedOrFinished.text = @"已结束";
        }else if([currentGameDetail.IsFinished isEqualToString:@"0"])
        {
            proceedOrFinished.text = @"未开始";
        }else
        {
            proceedOrFinished.text = @"进行中";
        }
        
        
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络状态不佳，加载数据失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        
    }
    

    [self.view bringSubviewToFront:comment];
}

-(void) supportAAction
{
    UserInfoPlistIO *infoPlist = [[UserInfoPlistIO alloc] init];
    BOOL isLogined = [infoPlist isLogin];
    [infoPlist release];
    if(isLogined)
    {
        NSString *response = [IWatchFetcher fetchBetGame:usrID gameID:currentGameID betSide:@"0" points:@"1"];
        if([response isEqualToString:@"-6"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"比赛已经结束" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }else if([response isEqualToString:@"-5"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能同时支持两支队伍" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }else
        {
            [self refreshAction];
        }
    }else
    {
        LoginViewController *login = [[LoginViewController alloc] initWithFrame:LSFunsCenterController selection:OthersController];
        [self.navigationController pushViewController:login animated:YES];
    }
}
-(void) supportBAction;
{
    UserInfoPlistIO *infoPlist = [[UserInfoPlistIO alloc] init];
    BOOL isLogined = [infoPlist isLogin];
    [infoPlist release];
    if(isLogined)
    {
        NSString *response = [IWatchFetcher fetchBetGame:usrID gameID:currentGameID betSide:@"1" points:@"1"];
        if([response isEqualToString:@"-6"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"比赛已经结束" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }else if([response isEqualToString:@"-5"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能同时支持两支队伍" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }else
        {
            [self refreshAction];
        }
    }else
    {
        LoginViewController *login = [[LoginViewController alloc] initWithFrame:LSFunsCenterController selection:OthersController];
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.delegate = self;
	[HUD show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{ 
    [HUD hide:YES];
}

//-(void) clickImage:(id)sender
//{
//    NSLog(@"userID");
//}

-(void) changeFrame:(BOOL) hideParameter
{
    if(hideParameter)
    {
        //float x= comment.frame.origin.x;
        float y = comment.frame.origin.y;
        [comment setFrame:CGRectMake(0, y-90, 320, 130)];
    }else
    {
        float y = comment.frame.origin.y;
        [comment setFrame:CGRectMake(0, y+90, 320, 130)];
    }
}

-(void) beginFrameChange
{
    float y = comment.frame.origin.y;
    [comment setFrame:CGRectMake(0, y-170, 320, 130)];
}

-(void) afterFrameChange
{
    float y = comment.frame.origin.y;
    [comment setFrame:CGRectMake(0, y+170, 320, 130)];
}

-(void) publish
{
    UserInfoPlistIO *infoPlist = [[UserInfoPlistIO alloc] init];
    BOOL isLogined = [infoPlist isLogin];
    [infoPlist release];
    
    HUDforPublish = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUDforPublish];
    HUDforPublish.delegate = self;
    [HUDforPublish show:YES];
    if(isLogined)
    {
        NSString *commentContent = comment.commentView.text;
            
        [IWatchFetcher fetchCommentID:usrID gameID:currentGameID commentContent:commentContent];
        comment.commentView.text=@"";
        [self refreshAction];
    }else
    {
        NSString *commentContent = comment.commentView.text;
        [IWatchFetcher fetchCommentID:@"0" gameID:currentGameID commentContent:commentContent];
        comment.commentView.text=@"";
        [self refreshAction];
    }
    [HUDforPublish hide:YES];
    [comment.commentView resignFirstResponder];
//    [self changeFrame:NO];
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[hud removeFromSuperview];
	[hud release];
	hud = nil;
}

//请求数据
-(void)requestData{
	NSAutoreleasePool * pool=[[NSAutoreleasePool alloc] init];
    //newsArray = [SportsDynamicFetcher fetchNewsWithTime:[LSUtil now] Count:10];
    //detailArray = [IWatchFetcher fetchComment:currentGameID];
    if(detailArray)
    {
        [detailArray release];
        detailArray = nil;
    }
    detailArray = [[IWatchFetcher fetchComment:[LSUtil now] Count:10 gameID:currentGameID Index:@"0" userID:usrID] mutableCopy];

	[pool release];
	
	//回到主线程跟新界面
	[self performSelectorOnMainThread:@selector(finishRequest) withObject:nil waitUntilDone:YES];
    
}

//完成请求
-(void)finishRequest
{
    [detailsTableView reloadData];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
  //  NSLog(@"start");
    //打开线程，读取网络图片
	[NSThread detachNewThreadSelector:@selector(requestData) toTarget:self withObject:nil];
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	//[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading: sportsTableView];
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading: detailsTableView];
	//NSLog(@"end");
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

-(void) jumpPersonal:(NSString *) userIDParamenter
{
    if(![userIDParamenter isEqualToString:@"0"])
    {
        UserDetailController *userDetail = [[UserDetailController alloc] init];
        userDetail.userID = userIDParamenter;
        userDetail.myUserID = usrID;
        [LeisureSportAppDelegate setUserID:usrID];
        [self.navigationController pushViewController:userDetail animated:YES];
        [userDetail release];
    }
    
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    _refreshHeaderView=nil;
    detailArray=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
