//
//  IWatchViewController.m
//  DelightSports
//
//  Created by ACE hitsz302 on 12-5-18.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "IWatchController.h"
#import "LeisureSportAppDelegate.h"
#import "IWatchDropdownList.h"
#import "MatchDetailsConrroller.h"
#import "LSUtil.h"
#import "IWatchFetcher.h"
#import "IWatch.h"
#import "FavourTeam.h"
#import "FavourTeamGames.h"
#import "UserInfoPlistIO.h"
#import "LoginViewController.h"
#import "FansCenterFetcher.h"
#import "LeagueInfo.h"

@implementation IWatchController
@synthesize dateUilabel;
@synthesize title;
@synthesize dropDownListButton;
@synthesize pointButton;
@synthesize segmentedContorller;
@synthesize dateUiview;
@synthesize segmentedNumber;
@synthesize iWatchDropDownArray;
@synthesize iWatchTableArray;
@synthesize dropDownInitTitle;
@synthesize dropDownInitTitle0;
@synthesize dropDownInitTitle1;
@synthesize dropDownInitTitle2;
@synthesize date;
@synthesize usrID;
@synthesize favorLeagueArray;
@synthesize leagueArray;

- (id) initWithFrame:(LS_IWatchSelectedController)selected//初始化，参数为所选择分段按钮；dropDownInitTitle为下拉框初始化内容；dropDownInitTitle0、1、2记录当前所选下拉内容，以便返回时容为该内容
{
    if(selected==MyWatchController)
    {
        dropDownInitTitle = @"我的关注";
        dropDownInitTitle0 = @"我的关注";
        dropDownInitTitle1 = @"我的关注";
        dropDownInitTitle2 = @"我的关注";
        segmentedNumber=0;
    }else if(selected==MyFocusedGameController)
    {
        
        dropDownInitTitle = @"我的关注";
        dropDownInitTitle0 = @"我的关注";
        dropDownInitTitle1 = @"我的关注";
        dropDownInitTitle2 = @"我的关注";
        segmentedNumber=1;
    }else if(selected==MyTeamController)
    {
        dropDownInitTitle = @"我的关注";
        dropDownInitTitle0 = @"我的关注";
        dropDownInitTitle1 = @"我的关注";
        dropDownInitTitle2 = @"我的关注";
        segmentedNumber=2;
    }else if(selected==NbaController)
    {
        dropDownInitTitle = @"NBA";
        dropDownInitTitle0 = @"NBA";
        dropDownInitTitle1 = @"我的关注";
        dropDownInitTitle2 = @"我的关注";
        segmentedNumber=0;
    }else if(selected==XijiaController)
    {
        dropDownInitTitle = @"西甲";
        dropDownInitTitle0 = @"西甲";
        dropDownInitTitle1 = @"我的关注";
        dropDownInitTitle2 = @"我的关注";
        segmentedNumber=0;
    }else if(selected==YijiatchController)
    {
        dropDownInitTitle = @"意甲";
        dropDownInitTitle0 = @"意甲";
        dropDownInitTitle1 = @"我的关注";
        dropDownInitTitle2 = @"我的关注";
        segmentedNumber=0;
    }else if(selected==ZhongchaoController)
    {
        dropDownInitTitle = @"中超";
        dropDownInitTitle0 = @"中超";
        dropDownInitTitle1 = @"我的关注";
        dropDownInitTitle2 = @"我的关注";
        segmentedNumber=0;
    }else if(selected==YingchaoController)
    {
        dropDownInitTitle = @"英超";
        dropDownInitTitle0 = @"英超";
        dropDownInitTitle1 = @"我的关注";
        dropDownInitTitle2 = @"我的关注";
        segmentedNumber=0;
    }else if(selected==DejiaController)
    {
        dropDownInitTitle = @"德甲";
        dropDownInitTitle0 = @"德甲";
        dropDownInitTitle1 = @"我的关注";
        dropDownInitTitle2 = @"我的关注";
        segmentedNumber=0;
    }else if(selected==CBAController)
    {
        dropDownInitTitle = @"CBA";
        dropDownInitTitle0 = @"CBA";
        dropDownInitTitle1 = @"我的关注";
        dropDownInitTitle2 = @"我的关注";
        segmentedNumber=0;
    }else
    {
        dropDownInitTitle = @"我的关注";
        dropDownInitTitle0 = @"我的关注";
        dropDownInitTitle1 = @"我的关注";
        dropDownInitTitle2 = @"我的关注";
        segmentedNumber=0;
    }

    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void) dealloc
{
    [dateUilabel release];
    [segmentedContorller release];
    [dateUiview release];
    [iWatchTableArray release];
    [usrID release];
    [dictionary release];
    [leagueArray release];
    [iWatchDropDownArray release];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.delegate = self;
	[HUD show:YES];
}

- (void)viewDidAppear:(BOOL)animated//在view显示时更新下拉框和当前tableview内容
{
    if(dropDownList.showList==true)
    {
        [dropDownList DropUp];
    }

    if (iWatchDropDownArray)
    {
        [iWatchDropDownArray release];
        iWatchDropDownArray = nil;
    }
    
    if(segmentedNumber==0)//热点赛事
    {
        iWatchDropDownArray =[[NSMutableArray alloc] initWithObjects:@"全部",@"NBA",@"CBA",@"西甲",@"意甲",@"中超",@"英超",@"德甲", nil];
    }else if(segmentedNumber==2)//关注球队
    {
        NSMutableArray  *tempIWatchDropDownArray =[[IWatchFetcher fetchFocusedTeams:usrID] mutableCopy];
        iWatchDropDownArray = [[NSMutableArray alloc]init];
        for (int i=0; i<[tempIWatchDropDownArray count]; i++) {
            FavourTeam *team = [tempIWatchDropDownArray objectAtIndex:i];
            [self.iWatchDropDownArray addObject:team.Name];
            //[team release];
        }
        [tempIWatchDropDownArray release];
    }else if(segmentedNumber==1)//关注联赛
    {
        iWatchDropDownArray =[[NSMutableArray alloc] initWithObjects:@"全部", nil];

        //从本地获取关注的联赛
        favorLeagueArray = [[FansCenterFetcher getFavorLeagueByUserID:usrID] mutableCopy];
        
        
        
        //获取联赛信息
        leagueArray = [[FansCenterFetcher fetchLeagues] mutableCopy];
        
        for(int i=0;i<[leagueArray count];i++)
        {
            LeagueInfo *leagueInfo = [leagueArray objectAtIndex:i];
            if (favorLeagueArray && [favorLeagueArray containsObject:leagueInfo.LeaugeID])
            {
                [iWatchDropDownArray addObject:leagueInfo.Name];
            }
        }
    }
    
    title = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 32)];
    
    //将下拉框添加到title
    dropDownList = [[IWatchDropdownList alloc] initWithFrame:CGRectMake(80 , -33, 170.0, 32.0) dataInfo:iWatchDropDownArray initTitle:dropDownInitTitle Delegate:(id)self];
    dropDownListButton = dropDownList.dropdownButton;
    //pointButton = [[UIButton alloc]initWithFrame:CGRectMake(dropDownListButton.frame.size.width, title.frame.origin.x, title.frame.size.width-dropDownList.frame.size.width, title.frame.size.height)];
    pointButton = dropDownList.btDropdown;
    [title addSubview:dropDownListButton];
    [title addSubview:pointButton];
    self.navigationItem.titleView = title;
    [self.view addSubview:dropDownList];
    [dropDownList release];
    //[dropDownListButton release];
    //[pointButton release];
    [title release];
    
    [self refreshAction_NoNeedInDropDown];
        
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 368)];
	
    view.backgroundColor = [UIColor colorWithPatternImage:GREEN_BG_IMAGE];
    self.view =view;
    [view release];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
   // HUDMark = NOHUD;
    
    UserInfoPlistIO *userInfoPlistIO = [[UserInfoPlistIO alloc] init];
    usrID = [[userInfoPlistIO readUserID:@""] mutableCopy];
    islogined = [userInfoPlistIO isLogin];
    [userInfoPlistIO release];

    //返回首页按钮
    UIButton * backButton=[UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"首页按钮" ofType:@"png"]] forState:0];
	[backButton addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
	backButton.frame=CGRectMake(3,3, 49, 31);
	
    //刷新按钮
    UIButton * refreshButton=[UIButton buttonWithType:UIButtonTypeCustom];
	[refreshButton setImage:[UIImage imageNamed:@"刷新按钮.png"] forState:UIControlStateNormal];
    [refreshButton setImage:[UIImage imageNamed:@"刷新按钮按下.png"] forState:UIControlStateHighlighted];
    [refreshButton addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
	refreshButton.frame=CGRectMake(303,3, 41, 41);
    
    
	UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.leftBarButtonItem = back;
    self.navigationItem.rightBarButtonItem = refresh;
    [back release];
    [refresh release];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NaviBarBg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    if ([self.tabBarController.tabBar respondsToSelector:@selector(setBackgroundImage:)]) {
        [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"TabBarBg.png"]];
    }


    UIImageView *topBg = PALEGREEN_BG_VIEW;
    topBg.frame = CGRectMake(0, 5, 320, 60);
    topBg.userInteractionEnabled = YES;
    
    //初始化分段按钮
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"热点",@"赛事",@"球队", nil];
    segmentedContorller = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    segmentedContorller.frame = CGRectMake(40, 10, 240, 40);
    segmentedContorller.selectedSegmentIndex = segmentedNumber;
    segmentedContorller.tintColor = [UIColor redColor];
    segmentedContorller.segmentedControlStyle = UISegmentedControlStylePlain;
    [topBg addSubview:segmentedContorller];
    [self.view addSubview:topBg];

    [segmentedContorller addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        
    [segmentedArray release];
    [segmentedContorller release];
    [topBg release];
    
    UIImageView *bottomBg = PALEGREEN_BG_VIEW;
    bottomBg.frame = CGRectMake(0, 65, 320, 300);
    bottomBg.userInteractionEnabled = YES;
    
    //初始化日期显示控件
    dateUiview = [[UIView alloc] initWithFrame:CGRectMake(5, 10, 310.0, 50.0)];
    
    UIButton *todayButton = [[UIButton alloc] initWithFrame:CGRectMake(210, 10.0, 80.0, 35.0)];

    
    [todayButton setBackgroundImage:[UIImage imageNamed:@"当天按钮1.png"] forState:UIControlStateNormal];
    [todayButton setBackgroundImage:[UIImage imageNamed:@"当天按钮按下.png"] forState:UIControlStateHighlighted];
    [todayButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [todayButton setTitle:@"今天" forState:UIControlStateNormal];
    [todayButton addTarget:self action:@selector(showDateOfToday:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextDateButton = [[UIButton alloc] initWithFrame:CGRectMake(160.0, 5.0, 40.0, 40.0)];

    [nextDateButton setBackgroundImage:[UIImage imageNamed:@"右边按下2.png"] forState:UIControlStateNormal];
    [nextDateButton setBackgroundImage:[UIImage imageNamed:@"右边按下1.png"] forState:UIControlStateHighlighted];
    [nextDateButton addTarget:self action:@selector(showNextDateOfCurrent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *previousDateButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 5.0, 40.0, 40.0)];

    [previousDateButton setBackgroundImage:[UIImage imageNamed:@"左边按下2.png"] forState:UIControlStateNormal];
    [previousDateButton setBackgroundImage:[UIImage imageNamed:@"左边按下1.png"] forState:UIControlStateHighlighted];
    [previousDateButton addTarget:self action:@selector(showPreviousDateOfCurrent:) forControlEvents:UIControlEventTouchUpInside];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSString *tempDateString = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    [timeZone release];
    
    UIImageView *dateBg = DATE_BG_VIEW;
    dateBg.frame = CGRectMake(60, 5, 100, 40);
    dateBg.userInteractionEnabled = YES;
    
    dateUilabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.0, 100, 40)];
    dateUilabel.textAlignment = UITextAlignmentCenter;
    dateUilabel.backgroundColor = [UIColor clearColor];
    dateUilabel.text = tempDateString;
    date = tempDateString;
    
    
    [dateBg addSubview:dateUilabel];
   
    [dateUiview addSubview:todayButton];
    [dateUiview addSubview:nextDateButton];
    [dateUiview addSubview:previousDateButton];
    [dateUiview addSubview:dateBg];
    
    [dateBg release];
    [todayButton release];
    [previousDateButton release];
    [nextDateButton release];
    [bottomBg addSubview:dateUiview];
    
    UIImageView *intervalBg = INTERVAL_BG_VIEW;
    intervalBg.frame = CGRectMake(10, 60, 300, 2);
    [bottomBg addSubview:intervalBg];
    [intervalBg release];
    
    
    iWatchTableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 70, 300, 215) style:UITableViewStyleGrouped];
    iWatchTableView.backgroundColor = [UIColor clearColor];
	iWatchTableView.delegate=self;
	iWatchTableView.dataSource=self;
    iWatchTableView.allowsSelection = YES;
    [bottomBg addSubview:iWatchTableView];
    [self.view addSubview:bottomBg];
    [iWatchTableView release];
    
    [bottomBg release];
}



- (void) segmentAction:(UISegmentedControl *) sender//分段按钮事件
{    
    
    if(islogined)//判断是否登录
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.delegate = self;
        [HUD show:YES];
        
        if(dropDownList.showList==true)//如果下拉框拉下，先将其回收
        {
            [dropDownList DropUp];
        }

        if (iWatchDropDownArray)
        {
            [iWatchDropDownArray release];
            iWatchDropDownArray = nil;
        }
        if(segmentedContorller.selectedSegmentIndex==0)//热点赛事
        {
            iWatchDropDownArray =[[NSMutableArray alloc] initWithObjects:@"全部",@"NBA",@"CBA",@"西甲",@"意甲",@"中超",@"英超",@"德甲", nil];
            if(segmentedNumber==0)
            {
                dropDownInitTitle=dropDownInitTitle0;
            }else if(segmentedNumber==1)
            {
                dropDownInitTitle=dropDownInitTitle0;
                dropDownInitTitle1=dropDownListButton.currentTitle;
            }else if(segmentedNumber==2)
            {
                dropDownInitTitle=dropDownInitTitle0;
                dropDownInitTitle2=dropDownListButton.currentTitle;
            }
            segmentedNumber=0;
        }else if(segmentedContorller.selectedSegmentIndex==1)//关注联赛
        {

            
            iWatchDropDownArray =[[NSMutableArray alloc] initWithObjects:@"全部", nil];
            //从本地获取关注的联赛
            favorLeagueArray = [[FansCenterFetcher getFavorLeagueByUserID:usrID] mutableCopy];
            
            
            //获取联赛信息
            leagueArray = [[FansCenterFetcher fetchLeagues] mutableCopy];
            
            for(int i=0;i<[leagueArray count];i++)
            {
                LeagueInfo *leagueInfo = [leagueArray objectAtIndex:i];
                if (favorLeagueArray && [favorLeagueArray containsObject:leagueInfo.LeaugeID])
                {
                    [iWatchDropDownArray addObject:leagueInfo.Name];
                }
            }
            
            if(segmentedNumber==0)
            {
                //dropDownInitTitle0 = ;
                dropDownInitTitle=dropDownInitTitle1;
                dropDownInitTitle0=dropDownListButton.currentTitle;
            }else if(segmentedNumber==1)
            {
                dropDownInitTitle=dropDownInitTitle1;
            }else if(segmentedNumber==2)
            {
                dropDownInitTitle=dropDownInitTitle1;
                dropDownInitTitle2=dropDownListButton.currentTitle;
            }
            segmentedNumber=1;
        }else if(segmentedContorller.selectedSegmentIndex==2)//关注球队
        {
            NSMutableArray  *tempIWatchDropDownArray =[[IWatchFetcher fetchFocusedTeams:usrID] mutableCopy];

            iWatchDropDownArray = [[NSMutableArray alloc]init];
            for (int i=0; i<[tempIWatchDropDownArray count]; i++) {
                FavourTeam *team = [tempIWatchDropDownArray objectAtIndex:i];
                [iWatchDropDownArray addObject:team.Name];
                //[team release];
            }
            [tempIWatchDropDownArray release];
            if(segmentedNumber==0)
            {
                dropDownInitTitle=dropDownInitTitle2;
                dropDownInitTitle0=dropDownListButton.currentTitle;
            }else if(segmentedNumber==1)
            {
                dropDownInitTitle=dropDownInitTitle2;
                dropDownInitTitle1=dropDownListButton.currentTitle;
            }else if(segmentedNumber==2)
            {
                dropDownInitTitle=dropDownInitTitle2;
            }
            segmentedNumber=2;
        }
        
//        if([iWatchDropDownArray count]==0)
//        {
//            iWatchDropDownArray = nil;
//        }
        title = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 32)];
        
        dropDownList = [[IWatchDropdownList alloc] initWithFrame:CGRectMake(80 , -33, 170.0, 32.0) dataInfo:iWatchDropDownArray initTitle:dropDownInitTitle Delegate:(id)self]; 
        
        dropDownListButton = dropDownList.dropdownButton;
        //pointButton = [[UIButton alloc]initWithFrame:CGRectMake(dropDownListButton.frame.size.width, title.frame.origin.x, title.frame.size.width-dropDownListButton.frame.size.width, title.frame.size.height)];
        pointButton = dropDownList.btDropdown;
        [title addSubview:dropDownListButton];
        [title addSubview:pointButton];
        self.navigationItem.titleView = title;
        [self.view addSubview:dropDownList];
        [dropDownList release];
        //[dropDownListButton release];
        //[pointButton release];
        [title release];
        [self refreshAction_NoNeedInDropDown];

    }else//如果未登录，根据要进入的view传参数给登录界面并初始化登录
    {
        if(dropDownList.showList==true)
        {
            [dropDownList DropUp];
        }

        if(segmentedContorller.selectedSegmentIndex==1)
        {
            segmentedNumber=1;
            LoginViewController *login = [[LoginViewController alloc] initWithFrame:LSIWatchController selection:MyFocusedGameController];
            [self.navigationController pushViewController:login animated:YES];
        }else if(segmentedContorller.selectedSegmentIndex==2)
        {
            segmentedNumber=2;
            LoginViewController *login = [[LoginViewController alloc] initWithFrame:LSIWatchController selection:MyTeamController];
            [self.navigationController pushViewController:login animated:YES];
        }
    }
   
}



- (void) showDateOfToday:(id)sender//显示当前日期
{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    //[formatter setTimeZone:@"H"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    dateUilabel.text = dateString;
    date = dateString;
    [formatter release];
   
    
    if(dropDownList.showList==true)
    {
        [dropDownList DropUp];
    }
    
    [self refreshAction];
    //[self.view addSubview:mytimeUilabel];
    
}

-(void) showNextDateOfCurrent:(id)sender//显示下一天日期
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = dateUilabel.text;
    NSDate *currentDate = [formatter dateFromString:currentDateStr];
    //NSData *nextDate=[currentDate dateByAddingTimeInterval:(24*60*60)];
    NSString *nextDateStr =  [formatter stringFromDate:[currentDate dateByAddingTimeInterval:(24*60*60)]];
    
    //NSString *nextDateStr = [[NSString alloc] initWithData:nextDate encoding:NSASCIIStringEncoding];
    dateUilabel.text = nextDateStr;
    date = nextDateStr;
    //[nextDate release];
    [formatter release];
    
    if(dropDownList.showList==true)
    {
        [dropDownList DropUp];
    }
    [self refreshAction];
}
 
-(void) showPreviousDateOfCurrent:(id)sender//显示上一天日期
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = dateUilabel.text;
    NSDate *currentDate = [formatter dateFromString:currentDateStr];
    //NSData *previousDate=[currentDate dateByAddingTimeInterval:(-24*60*60)];
    NSString *previousDateStr =  [formatter stringFromDate:[currentDate dateByAddingTimeInterval:(-24*60*60)]];
    dateUilabel.text = previousDateStr;
    date = previousDateStr;
    
    [formatter release];
    
    if(dropDownList.showList==true)
    {
        [dropDownList DropUp];
    }
    [self refreshAction];
}


- (void)backToHome//返回主界面
{
    LeisureSportAppDelegate *app=[[UIApplication sharedApplication] delegate];
    [app gotoController:LSHomeViewController selection:OthersController];
}

-(void) refreshAction_NoNeedInDropDown//以当前日起、下拉框内容以及分段按钮内容刷新当前
{    
    if(dropDownList.showList==true)
    {
        [dropDownList DropUp];
    }
    if(iWatchTableArray)
    {
        [iWatchTableArray release];
        iWatchTableArray=nil;
    }
    
    
    if(favorLeagueArray)
    {
        [favorLeagueArray release];
        favorLeagueArray=nil;
    }
    if(leagueArray)
    {
        [leagueArray release];
        leagueArray=nil;
    }
   // NSAutoreleasePool * pool=[[NSAutoreleasePool alloc] init];

    //更新tableview内容
    if(segmentedNumber==0)
    {

        iWatchTableArray = [[IWatchFetcher fetchIWatch:date dropdown:dropDownListButton.currentTitle userID:@"" iWatchDropDownArray:iWatchDropDownArray segmentNumber:@"0"] mutableCopy];
    }else if(segmentedNumber==2)
    {
        iWatchTableArray = [[IWatchFetcher fetchFocusedTeamGames:date dropdown:dropDownListButton.currentTitle userID:usrID] mutableCopy];
    }else
    {
        iWatchTableArray = [[IWatchFetcher fetchIWatch:date dropdown:dropDownListButton.currentTitle userID:usrID iWatchDropDownArray:iWatchDropDownArray segmentNumber:@"1"] mutableCopy];
    }
    
    
    
    //如果为热点赛事或我的关注联赛，使用字典将体育项目按类属分开显示，例如，所有篮球项目分在一块显示
    if(segmentedNumber!=2)
    {
        if(dictionary)
        {
            [dictionary release];
            dictionary = nil;
        }
        dictionary = [[NSMutableDictionary alloc] init];
        for(int i=0;i<[iWatchTableArray count];i++)
        {
            bool mark = true;
            IWatch *iwatch = [iWatchTableArray objectAtIndex:i];
            for(id key in dictionary)
            {
                if([iwatch.GameTypeID isEqualToString:key])
                {
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    NSNumber *tempA= [[NSNumber alloc] init];
                    tempA = [formatter numberFromString:[dictionary objectForKey:key]];
                    int a =[tempA intValue];
                    a++;
                    NSNumber *resultA = [NSNumber numberWithInt:a];
                    NSString *tmp = [formatter stringFromNumber:resultA];
                    [dictionary setObject:tmp forKey:key];
                    mark=false;
                    [formatter release];
                    break;
                }
            }
            if(mark)
            {
                [dictionary setObject:@"1" forKey:iwatch.GameTypeID];
            }
        }

    }
   // [pool release];
    
    
    if (iWatchDropDownArray)
    {
        [iWatchDropDownArray release];
        iWatchDropDownArray = nil;
    }
    
    
    
    [iWatchTableView reloadData];

    [HUD hide:YES];

    if([iWatchTableArray count]==0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"暂无数据";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.1];
        
    }
    
}

-(void) refreshAction//以当前日起、下拉框内容以及分段按钮内容刷新当前
{

    HUDforRefresh = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUDforRefresh];
    HUDforRefresh.delegate = self;
    [HUDforRefresh show:YES];


    //[HUD hide:NO];
    if(dropDownList.showList==true)
    {
        [dropDownList DropUp];
    }
    if(iWatchTableArray)
    {
        [iWatchTableArray release];
        iWatchTableArray=nil;
    }


    if(favorLeagueArray)
    {
        [favorLeagueArray release];
        favorLeagueArray=nil;
    }
    if(leagueArray)
    {
        [leagueArray release];
        leagueArray=nil;
    }
    
    if (iWatchDropDownArray)
    {
        [iWatchDropDownArray release];
        iWatchDropDownArray = nil;
    }
    
    if(segmentedNumber==0)//热点赛事
    {
        iWatchDropDownArray =[[NSMutableArray alloc] initWithObjects:@"全部",@"NBA",@"CBA",@"西甲",@"意甲",@"中超",@"英超",@"德甲", nil];
    }else if(segmentedNumber==2)//关注球队
    {
        NSMutableArray  *tempIWatchDropDownArray =[[IWatchFetcher fetchFocusedTeams:usrID] mutableCopy];
        iWatchDropDownArray = [[NSMutableArray alloc]init];
        for (int i=0; i<[tempIWatchDropDownArray count]; i++) {
            FavourTeam *team = [tempIWatchDropDownArray objectAtIndex:i];
            [self.iWatchDropDownArray addObject:team.Name];
            //[team release];
        }
        [tempIWatchDropDownArray release];
    }else if(segmentedNumber==1)//关注联赛
    {
        iWatchDropDownArray =[[NSMutableArray alloc] initWithObjects:@"全部", nil];
        
        //从本地获取关注的联赛
        favorLeagueArray = [[FansCenterFetcher getFavorLeagueByUserID:usrID] mutableCopy];
        if([favorLeagueArray count]==0)
        {
            favorLeagueArray = nil;
        }
        
        
        //获取联赛信息
        leagueArray = [[FansCenterFetcher fetchLeagues] mutableCopy];

        for(int i=0;i<[leagueArray count];i++)
        {
            LeagueInfo *leagueInfo = [leagueArray objectAtIndex:i];
            if (favorLeagueArray && [favorLeagueArray containsObject:leagueInfo.LeaugeID])
            {
                [iWatchDropDownArray addObject:leagueInfo.Name];
            }
        }
    }

    //更新tableview内容
    if(segmentedNumber==0)
    {   
        iWatchTableArray = [[IWatchFetcher fetchIWatch:date dropdown:dropDownListButton.currentTitle userID:@"" iWatchDropDownArray:iWatchDropDownArray segmentNumber:@"0"] mutableCopy];
    }else if(segmentedNumber==2)
    {
        iWatchTableArray = [[IWatchFetcher fetchFocusedTeamGames:date dropdown:dropDownListButton.currentTitle userID:usrID] mutableCopy];
    }else
    {
        iWatchTableArray = [[IWatchFetcher fetchIWatch:date dropdown:dropDownListButton.currentTitle userID:usrID iWatchDropDownArray:iWatchDropDownArray segmentNumber:@"1"] mutableCopy];
    }
    
    
    //如果为热点赛事或我的关注联赛，使用字典将体育项目按类属分开显示，例如，所有篮球项目分在一块显示
    if(segmentedNumber!=2)
    {
        if(dictionary)
        {
            [dictionary release];
            dictionary = nil;
        }
        dictionary = [[NSMutableDictionary alloc] init];
        for(int i=0;i<[iWatchTableArray count];i++)
        {
            bool mark = true;
            IWatch *iwatch = [iWatchTableArray objectAtIndex:i];
            for(id key in dictionary)
            {
                if([iwatch.GameTypeID isEqualToString:key])
                {
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    NSNumber *tempA= [[NSNumber alloc] init];
                    tempA = [formatter numberFromString:[dictionary objectForKey:key]];
                    int a =[tempA intValue];
                    a++;
                    NSNumber *resultA = [NSNumber numberWithInt:a];
                    NSString *tmp = [formatter stringFromNumber:resultA];
                    [dictionary setObject:tmp forKey:key];
                    mark=false;
                    [formatter release];
                    break;
                }
            }
            if(mark)
            {
                [dictionary setObject:@"1" forKey:iwatch.GameTypeID];
            }
        }
    }
    
    //[pool release];
    
    if (iWatchDropDownArray)
    {
          [iWatchDropDownArray release];
          iWatchDropDownArray = nil;
    }

    
    [iWatchTableView reloadData];

    [HUDforRefresh hide:YES];

    
    if([iWatchTableArray count]==0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"暂无数据";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.1];
        
    }

}

-(void)setCurrentTitle:(NSString *) currentTitle
{
    dropDownInitTitle=currentTitle;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{ 
    if(segmentedNumber==2)
    {
        return [iWatchTableArray count];
        
    }else
    {
        return [dictionary count];
    }
    
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
    if(segmentedNumber==2)
    {
        return 1;
    }else
    {
        for(int counter=0;counter<[dictionary count];counter++)
        {
            if(section==counter)
            {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                NSNumber *tempA= [[NSNumber alloc] init];
                tempA = [formatter numberFromString:[dictionary objectForKey:[[dictionary allKeys] objectAtIndex:counter]]];
                NSInteger a =[tempA intValue];

                [formatter release];
                return a;
                
                
            }
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"ICell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
	}
    //由于重用单元格 需要删除原来单元格的内容
    for (UIView *view in [cell subviews]){
        [view removeFromSuperview];
    }
    
    if(segmentedNumber==2)
    {
        FavourTeamGames *favorTeamGames = [iWatchTableArray objectAtIndex:indexPath.section];
        
        UIImageView *bg = [[UIImageView alloc] init];
        bg.frame = CGRectMake(10, 8, 280, 104);
        bg.backgroundColor = [UIColor whiteColor];
        [bg.layer setCornerRadius:10.0];
        
        UILabel *sportsCategory = [[UILabel alloc] init];
        sportsCategory.frame = CGRectMake(10, 4, 95, 21);
        sportsCategory.font = [UIFont systemFontOfSize:17.0f];
        sportsCategory.backgroundColor = [UIColor clearColor];
        sportsCategory.textColor = [UIColor greenColor];
        sportsCategory.text = favorTeamGames.FavorName;
        [bg addSubview:sportsCategory];
        [sportsCategory release];
        
        UIImageView *star = [[UIImageView alloc] init];
        star.frame = CGRectMake(241, 0, 30, 29);
        star.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"黄色星" ofType:@"png"]];
        [bg addSubview:star];
        [star release];
        
        
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, 33, 280, 70);
        bgView.backgroundColor = [UIColor lightGrayColor];
        [bgView.layer setCornerRadius:10.0];
        
        UIView *bgView1 = [[UIView alloc] init];
        bgView1.frame = CGRectMake(0, 0, 16, 13);
        bgView1.backgroundColor = [UIColor lightGrayColor];
        [bgView addSubview:bgView1];
        [bgView1 release];
        
        UIView *bgView2 = [[UIView alloc] init];
        bgView2.frame = CGRectMake(264, 0, 16, 13);
        bgView2.backgroundColor = [UIColor lightGrayColor];
        [bgView addSubview:bgView2];
        [bgView2 release];
        
        
        UILabel *proceedOrFinished = [[UILabel alloc] init];
        proceedOrFinished.frame = CGRectMake(5, 11, 42, 20);
        proceedOrFinished.font = [UIFont systemFontOfSize:13.0f];
        proceedOrFinished.backgroundColor = [UIColor clearColor];
        proceedOrFinished.textAlignment = UITextAlignmentCenter; 
        if([favorTeamGames.IsFinished isEqualToString:@"3"])
        {
            proceedOrFinished.text = @"已结束";
        }else if([favorTeamGames.IsFinished isEqualToString:@"0"])
        {
            proceedOrFinished.text = @"未开始";
        }else
        {
            proceedOrFinished.text = @"进行中";
        }
        [bgView addSubview:proceedOrFinished];
        [proceedOrFinished release];
        
        UILabel *beginTime = [[UILabel alloc] init];
        beginTime.frame = CGRectMake(5, 29, 42, 21);
        beginTime.font = [UIFont systemFontOfSize:13.0f];
        beginTime.backgroundColor = [UIColor clearColor];
        beginTime.textAlignment = UITextAlignmentCenter; 
        beginTime.text = [favorTeamGames.GameTime substringWithRange:NSMakeRange(favorTeamGames.GameTime.length-8, 5)];
        [bgView addSubview:beginTime];
        [beginTime release];
        
        UILabel *teamA = [[UILabel alloc] init];
        teamA.frame = CGRectMake(55, 11, 77, 21);
        teamA.font = [UIFont systemFontOfSize:17.0f]; 
        teamA.adjustsFontSizeToFitWidth = YES;
        teamA.backgroundColor = [UIColor clearColor];
        teamA.text =  favorTeamGames.HomeName;
        [bgView addSubview:teamA];
        [teamA release];
        
        UILabel *teamB = [[UILabel alloc] init];
        teamB.frame = CGRectMake(55, 37, 77, 21);
        teamB.font = [UIFont systemFontOfSize:17.0f]; 
        teamB.adjustsFontSizeToFitWidth = YES;
        teamB.backgroundColor = [UIColor clearColor];
        teamB.text =  favorTeamGames.AwayName;
        [bgView addSubview:teamB];
        [teamB release];
        
        UILabel *league = [[UILabel alloc] init];
        league.frame = CGRectMake(140, 24, 42, 21);
        league.font = [UIFont systemFontOfSize:17.0f]; 
        league.adjustsFontSizeToFitWidth = YES;
        league.backgroundColor = [UIColor clearColor];
        league.text =  favorTeamGames.Name;
        [bgView addSubview:league];
        [league release];
        
        UILabel *teamAScore = [[UILabel alloc] init];
        teamAScore.frame = CGRectMake(184, 11, 42, 21);
        teamAScore.font = [UIFont systemFontOfSize:17.0f];
        teamAScore.backgroundColor = [UIColor clearColor];
        teamAScore.text =  favorTeamGames.HomeTeamScore;
        [bgView addSubview:teamAScore];
        [teamAScore release];
        
        UILabel *teamBScore = [[UILabel alloc] init];
        teamBScore.frame = CGRectMake(184, 40, 42, 21);
        teamBScore.font = [UIFont systemFontOfSize:17.0f]; 
        teamBScore.backgroundColor = [UIColor clearColor];
        teamBScore.text =  favorTeamGames.AwayTeamScore;
        [bgView addSubview:teamBScore];
        [teamBScore release];
        
        UILabel *tvLive = [[UILabel alloc] init];
        tvLive.frame = CGRectMake(223, 14, 57, 47);
        tvLive.font = [UIFont systemFontOfSize:10.0f]; 
        tvLive.backgroundColor = [UIColor clearColor];
        tvLive.numberOfLines = 0;
        if(favorTeamGames.TVLiveAll.length!=0)
        {
            tvLive.text = favorTeamGames.TVLiveAll;
        }else
        {
            tvLive.text = @"暂无直播";
        }
        [bgView addSubview:tvLive];
        [tvLive release];
        
        UIImageView *line1 = [[UIImageView alloc] init];
        line1.frame = CGRectMake(50, 0, 1, 70);
        line1.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"竖间隔条" ofType:@"png"]];
        [bgView addSubview:line1];
        [line1 release];
        
        UIImageView *line2 = [[UIImageView alloc] init];
        line2.frame = CGRectMake(215, 0, 1, 70);
        line2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"竖间隔条" ofType:@"png"]];
        [bgView addSubview:line2];
        [line2 release];
        
        [bg addSubview:bgView];
        [bgView release];
        
        [cell addSubview:bg];
        [bg release];
    
    }else
    {
        if(indexPath.row==0)
        {
            //cell.backgroundColor = [UIColor whiteColor];
            //字典中存储了从服务器返回的所有符合要求的赛事，并记录了有多少类别赛事以及没想赛事有多少场，将当前cell加入到相应的类属中去
            int count;
            NSString *kind;
            
            for(int counter=0;counter<[dictionary count];counter++)
            {
                if(indexPath.section==counter)
                {
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    NSNumber *tempA= [[NSNumber alloc] init];
                    tempA = [formatter numberFromString:[dictionary objectForKey:[[dictionary allKeys] objectAtIndex:counter]]];
                    count =[tempA intValue];
                    kind = [[dictionary allKeys] objectAtIndex:counter];
                    [formatter release];
                }
            }
            
            NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
            for(int m=0;m<[iWatchTableArray count];m++)
            {
                IWatch *tmpIwatch = [iWatchTableArray objectAtIndex:m];
                if([tmpIwatch.GameTypeID isEqualToString:kind])
                    [tmpArray addObject:tmpIwatch];
            }
            
            
            IWatch *iWatch;
            for(int k= 0; k<count;k++)
            {
                if(indexPath.row==k)
                {
                    iWatch = [tmpArray objectAtIndex:indexPath.row];
                }
            }
            
            UIImageView *bg = [[UIImageView alloc] init];
            bg.frame = CGRectMake(10, 2, 280, 104);
            bg.backgroundColor = [UIColor whiteColor];
            [bg.layer setCornerRadius:10.0];
            
            UILabel *sportsCategory = [[UILabel alloc] init];
            sportsCategory.frame = CGRectMake(10, 4, 95, 21);
            sportsCategory.font = [UIFont systemFontOfSize:17.0f];
            sportsCategory.backgroundColor = [UIColor clearColor];
            sportsCategory.textColor = [UIColor greenColor];
            sportsCategory.text = iWatch.GameTypeName;
            [bg addSubview:sportsCategory];
            [sportsCategory release];
            
            UIImageView *star = [[UIImageView alloc] init];
            star.frame = CGRectMake(241, 0, 30, 29);
            star.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"黄色星" ofType:@"png"]];
            [bg addSubview:star];
            [star release];
            
            
            UIView *bgView = [[UIView alloc] init];
            bgView.frame = CGRectMake(0, 33, 280, 70);
            bgView.backgroundColor = [UIColor lightGrayColor];
            
            for(int counter=0;counter<[dictionary count];counter++)
            {
                if(indexPath.section==counter)
                {
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    NSNumber *tempA= [[NSNumber alloc] init];
                    tempA = [formatter numberFromString:[dictionary objectForKey:[[dictionary allKeys] objectAtIndex:counter]]];
                    NSInteger a =[tempA intValue];
                    
                    [formatter release];
                    if(a==1)
                    {
                        [bgView.layer setCornerRadius:10.0];
                    }
                }
            }
            
            UIView *bgView1 = [[UIView alloc] init];
            bgView1.frame = CGRectMake(0, 0, 16, 13);
            bgView1.backgroundColor = [UIColor lightGrayColor];
            [bgView addSubview:bgView1];
            [bgView1 release];
            
            UIView *bgView2 = [[UIView alloc] init];
            bgView2.frame = CGRectMake(264, 0, 16, 13);
            bgView2.backgroundColor = [UIColor lightGrayColor];
            [bgView addSubview:bgView2];
            [bgView2 release];
            
            UILabel *proceedOrFinished = [[UILabel alloc] init];
            proceedOrFinished.frame = CGRectMake(5, 11, 42, 20);
            proceedOrFinished.font = [UIFont systemFontOfSize:13.0f];
            proceedOrFinished.backgroundColor = [UIColor clearColor];
            proceedOrFinished.textAlignment = UITextAlignmentCenter; 
            if([iWatch.IsFinished isEqualToString:@"3"])
            {
                proceedOrFinished.text = @"已结束";
            }else if([iWatch.IsFinished isEqualToString:@"0"])
            {
                proceedOrFinished.text = @"未开始";
            }else
            {
                proceedOrFinished.text = @"进行中";
            }
            [bgView addSubview:proceedOrFinished];
            [proceedOrFinished release];
            
            
            
            
            
            UILabel *beginTime = [[UILabel alloc] init];
            beginTime.frame = CGRectMake(5, 29, 42, 21);
            beginTime.font = [UIFont systemFontOfSize:13.0f];
            beginTime.backgroundColor = [UIColor clearColor];
            beginTime.textAlignment = UITextAlignmentCenter; 
            beginTime.text = [iWatch.GameTime substringWithRange:NSMakeRange(iWatch.GameTime.length-8, 5)];
            [bgView addSubview:beginTime];
            [beginTime release];
            
            UILabel *teamA = [[UILabel alloc] init];
            teamA.frame = CGRectMake(55, 11, 77, 21);
            teamA.font = [UIFont systemFontOfSize:17.0f];
            teamA.adjustsFontSizeToFitWidth = YES;
            teamA.backgroundColor = [UIColor clearColor];
            teamA.text =  iWatch.HomeName;
            [bgView addSubview:teamA];
            [teamA release];
            
            UILabel *teamB = [[UILabel alloc] init];
            teamB.frame = CGRectMake(55, 37, 77, 21);
            teamB.font = [UIFont systemFontOfSize:17.0f];
            teamB.adjustsFontSizeToFitWidth = YES;
            teamB.backgroundColor = [UIColor clearColor];
            teamB.text =  iWatch.AwayName;
            [bgView addSubview:teamB];
            [teamB release];
            
            UILabel *league = [[UILabel alloc] init];
            league.frame = CGRectMake(140, 24, 42, 21);
            league.font = [UIFont systemFontOfSize:17.0f];
            league.adjustsFontSizeToFitWidth = YES;
            league.backgroundColor = [UIColor clearColor];
            league.text =  iWatch.Name;
            [bgView addSubview:league];
            [league release];
            
            UILabel *teamAScore = [[UILabel alloc] init];
            teamAScore.frame = CGRectMake(184, 11, 42, 21);
            teamAScore.font = [UIFont systemFontOfSize:17.0f]; 
            teamAScore.backgroundColor = [UIColor clearColor];
            teamAScore.text =  iWatch.HomeTeamScore;
            [bgView addSubview:teamAScore];
            [teamAScore release];
            
            UILabel *teamBScore = [[UILabel alloc] init];
            teamBScore.frame = CGRectMake(184, 40, 42, 21);
            teamBScore.font = [UIFont systemFontOfSize:17.0f]; 
            teamBScore.backgroundColor = [UIColor clearColor];
            teamBScore.text =  iWatch.AwayTeamScore;
            [bgView addSubview:teamBScore];
            [teamBScore release];
            
            UILabel *tvLive = [[UILabel alloc] init];
            tvLive.frame = CGRectMake(223, 14, 57, 47);
            tvLive.font = [UIFont systemFontOfSize:10.0f];
            tvLive.backgroundColor = [UIColor clearColor];
            tvLive.numberOfLines = 0;
            if(iWatch.TVLiveAll.length!=0)
            {
                tvLive.text = iWatch.TVLiveAll;
            }else
            {
                tvLive.text = @"暂无直播";
            }
            [bgView addSubview:tvLive];
            [tvLive release];
            
            UIImageView *line1 = [[UIImageView alloc] init];
            line1.frame = CGRectMake(50, 0, 1, 70);
            line1.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"竖间隔条" ofType:@"png"]];
            [bgView addSubview:line1];
            [line1 release];
            
            UIImageView *line2 = [[UIImageView alloc] init];
            line2.frame = CGRectMake(215, 0, 1, 70);
            line2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"竖间隔条" ofType:@"png"]];
            [bgView addSubview:line2];
            [line2 release];

            
            [bg addSubview:bgView];
            [bgView release];
            
            [cell addSubview:bg];
            [bg release];
            
            [tmpArray release];////////////
            
        }else
        {
            
            //字典中存储了从服务器返回的所有符合要求的赛事，并记录了有多少类别赛事以及没想赛事有多少场，将当前cell加入到相应的类属中去
            int count;
            NSString *kind;
            
            for(int counter=0;counter<[dictionary count];counter++)
            {
                if(indexPath.section==counter)
                {
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    NSNumber *tempA= [[NSNumber alloc] init];
                    tempA = [formatter numberFromString:[dictionary objectForKey:[[dictionary allKeys] objectAtIndex:counter]]];
                    count =[tempA intValue];
                    kind = [[dictionary allKeys] objectAtIndex:counter];
                    [formatter release];
                }
            }
            
            NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
            for(int m=0;m<[iWatchTableArray count];m++)
            {
                IWatch *tmpIwatch = [iWatchTableArray objectAtIndex:m];
                if([tmpIwatch.GameTypeID isEqualToString:kind])
                    [tmpArray addObject:tmpIwatch];
            }
            
            
            IWatch *iWatch;
            for(int k= 0; k<count;k++)
            {
                if(indexPath.row==k)
                {
                    iWatch = [tmpArray objectAtIndex:indexPath.row];
                    
                }
            }
            
            UIImageView *bg = [[UIImageView alloc] init];
            bg.frame = CGRectMake(10, 1, 280, 73);
            bg.backgroundColor = [UIColor lightGrayColor];
            
            
            
            UIView *bgView1 = [[UIView alloc] init];
            bgView1.frame = CGRectMake(0, 0, 16, 13);
            bgView1.backgroundColor = [UIColor lightGrayColor];
            if((indexPath.row%2)==1)//灰白相间显示
            {
                bgView1.backgroundColor = [UIColor whiteColor];
            }
            [bg addSubview:bgView1];
            [bgView1 release];
            
            
            
            UIView *bgView2 = [[UIView alloc] init];
            bgView2.frame = CGRectMake(264, 0, 16, 13);
            bgView2.backgroundColor = [UIColor lightGrayColor];
            if((indexPath.row%2)==1)//灰白相间显示
            {
                bgView2.backgroundColor = [UIColor whiteColor];
            }
            [bg addSubview:bgView2];
            [bgView2 release];
            
            
            
            if(indexPath.row==count-1)
            {
                [bg.layer setCornerRadius:10.0];
            }
            
            UILabel *proceedOrFinished = [[UILabel alloc] init];
            proceedOrFinished.frame = CGRectMake(5, 11, 42, 20);
            proceedOrFinished.font = [UIFont systemFontOfSize:13.0f];
            proceedOrFinished.backgroundColor = [UIColor clearColor];
            proceedOrFinished.textAlignment = UITextAlignmentCenter; 
            if([iWatch.IsFinished isEqualToString:@"3"])
            {
                proceedOrFinished.text = @"已结束";
            }else if([iWatch.IsFinished isEqualToString:@"0"])
            {
                proceedOrFinished.text = @"未开始";
            }else
            {
                proceedOrFinished.text = @"进行中";
            }
            [bg addSubview:proceedOrFinished];
            [proceedOrFinished release];
            
            
            
            
            
            UILabel *beginTime = [[UILabel alloc] init];
            beginTime.frame = CGRectMake(5, 29, 42, 21);
            beginTime.font = [UIFont systemFontOfSize:13.0f];
            beginTime.backgroundColor = [UIColor clearColor];
            beginTime.textAlignment = UITextAlignmentCenter; 
            beginTime.text = [iWatch.GameTime substringWithRange:NSMakeRange(iWatch.GameTime.length-8, 5)];
            [bg addSubview:beginTime];
            [beginTime release];
            
            UILabel *teamA = [[UILabel alloc] init];
            teamA.frame = CGRectMake(55, 11, 77, 21);
            teamA.font = [UIFont systemFontOfSize:17.0f]; 
            teamA.adjustsFontSizeToFitWidth = YES;
            teamA.backgroundColor = [UIColor clearColor];
            teamA.text =  iWatch.HomeName;
            [bg addSubview:teamA];
            [teamA release];
            
            UILabel *teamB = [[UILabel alloc] init];
            teamB.frame = CGRectMake(55, 37, 77, 21);
            teamB.font = [UIFont systemFontOfSize:17.0f]; 
            teamB.adjustsFontSizeToFitWidth = YES;
            teamB.backgroundColor = [UIColor clearColor];
            teamB.text =  iWatch.AwayName;
            [bg addSubview:teamB];
            [teamB release];
            
            UILabel *league = [[UILabel alloc] init];
            league.frame = CGRectMake(140, 24, 42, 21);
            league.font = [UIFont systemFontOfSize:17.0f]; 
            league.adjustsFontSizeToFitWidth = YES;
            league.backgroundColor = [UIColor clearColor];
            league.text =  iWatch.Name;
            [bg addSubview:league];
            [league release];
            
            UILabel *teamAScore = [[UILabel alloc] init];
            teamAScore.frame = CGRectMake(184, 11, 42, 21);
            teamAScore.font = [UIFont systemFontOfSize:17.0f]; 
            teamAScore.backgroundColor = [UIColor clearColor];
            teamAScore.text =  iWatch.HomeTeamScore;
            [bg addSubview:teamAScore];
            [teamAScore release];
            
            UILabel *teamBScore = [[UILabel alloc] init];
            teamBScore.frame = CGRectMake(184, 40, 42, 21);
            teamBScore.font = [UIFont systemFontOfSize:17.0f]; 
            teamBScore.backgroundColor = [UIColor clearColor];
            teamBScore.text =  iWatch.AwayTeamScore;
            [bg addSubview:teamBScore];
            [teamBScore release];
            
            UILabel *tvLive = [[UILabel alloc] init];
            tvLive.frame = CGRectMake(223, 14, 57, 47);
            tvLive.font = [UIFont systemFontOfSize:10.0f]; 
            tvLive.backgroundColor = [UIColor clearColor];
            tvLive.numberOfLines = 0;
            if(iWatch.TVLiveAll.length!=0)
            {
                tvLive.text = iWatch.TVLiveAll;
            }else
            {
                tvLive.text = @"暂无直播";
            }
            [bg addSubview:tvLive];
            [tvLive release];
            
            UIImageView *line1 = [[UIImageView alloc] init];
            line1.frame = CGRectMake(50, 0, 1, 72);
            line1.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"竖间隔条" ofType:@"png"]];
            [bg addSubview:line1];
            [line1 release];
            
            UIImageView *line2 = [[UIImageView alloc] init];
            line2.frame = CGRectMake(215, 0, 1, 72);
            line2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"竖间隔条" ofType:@"png"]];
            [bg addSubview:line2];
            [line2 release];
            if((indexPath.row%2)==1)//灰白相间显示
            {
                bg.backgroundColor = [UIColor whiteColor];
            }
            
            [cell addSubview:bg];
            [bg release];
            [tmpArray release];////////////
        }
    }
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    //return cell.frame.size.height;
    if(indexPath.row==0)
    {
        return 104;
    }else
    {
        return 74;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{

    if(dropDownList.showList==true)
    {
        [dropDownList DropUp];
    }

    IWatch *iWatch = [iWatchTableArray objectAtIndex:indexPath.row];
//  
    NSString *gameID = [iWatch.GameID mutableCopy];
    MatchDetailsConrroller *matchDetails = [[MatchDetailsConrroller alloc] initWithFrame:0 gameID:gameID];
//    matchDetails.segmentedNumber = 0;
//    matchDetails.currentGameID=gameID;
    [self.navigationController pushViewController:matchDetails animated:YES];
   // [matchDetails release];
}


- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[hud removeFromSuperview];
	[hud release];
	hud = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    iWatchTableArray=nil;
    dictionary = nil;
    leagueArray = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
