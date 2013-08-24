//
//  More.m
//  LeisureSport
//
//  Created by 高 峰 on 12-6-22.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "More.h"
#import "LSUtil.h"
#import "LeisureSportAppDelegate.h"
#import "UserInfoPlistIO.h"
#import "UserInfoPlistIO.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "LoginAndRegisterFetcher.h"
#import "Feedback.h"
#import "RemindSetting.h"

@implementation More

@synthesize remindSetButton,aboutButton,feedBackButton,quitButton,loginButton,registerButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 368)];
    
    UIImage *bgImg = [LSUtil scaleToSize:[UIImage imageNamed:@"greenbg.png"] size:CGSizeMake(320, 368)];
    view.backgroundColor = [UIColor colorWithPatternImage:bgImg];
    
	self.view=view;
	[view release];
    
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
//    UserInfoPlistIO *userInfoPlistIO = [[UserInfoPlistIO alloc] init];
//    NSString * usrID = [[userInfoPlistIO readUserID:@""] mutableCopy];
//    NSLog(@"usrID%@",usrID);
//    [userInfoPlistIO release];
    //返回首页按钮
    UIButton * customView=[UIButton buttonWithType:UIButtonTypeCustom];
	[customView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"首页按钮" ofType:@"png"]] forState:0];
	[customView addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
	customView.frame=CGRectMake(3,3, 49, 31);
	
	UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.leftBarButtonItem = back;
    [back release];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NaviBarBg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    if ([self.tabBarController.tabBar respondsToSelector:@selector(setBackgroundImage:)]) {
        [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"TabBarBg.png"]];
    }
    //self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:(82.0/255.0) green:(81.0/255.0) blue:(81.0/255.0) alpha:1];
    self.title = @"更多";
    
    UIImageView *topBg = PALEGREEN_BG_VIEW;
    topBg.frame = CGRectMake(0, 0, 320, 230);
    
    topBg.userInteractionEnabled = YES;
    
    UIImageView *click1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"进入.png"]];
    click1.frame = CGRectMake(255, 3, 25, 25);
    UIImageView *click2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"进入.png"]];
    click2.frame = CGRectMake(255, 3, 25, 25);
    UIImageView *click3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"进入.png"]];
    click3.frame = CGRectMake(255, 3, 25, 25);
    
    //提醒设置按钮
    UIImageView *remindBG = [[UIImageView alloc] init];
    remindBG.frame = CGRectMake(20.0, 10.0, 280.0, 31.0);
    remindBG.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"横条2-320" ofType:@"png"]];
    remindBG.userInteractionEnabled = YES;
    remindSetButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 280.0, 31.0)];
    UIImageView *tmp1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提醒图标.png"]];
    tmp1.frame = CGRectMake(3, 3, 25, 25);
    UILabel *tmpLable1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 3, 100, 25)];
    tmpLable1.backgroundColor = [UIColor clearColor];
    
    tmpLable1.text = @"提醒设置";
    //UIImage *tmp1 = [LSUtil scaleToSize:tmp size:CGSizeMake(280.0, 31.0)]; 
    remindSetButton.backgroundColor = [UIColor clearColor];
    
    [quitButton setBackgroundImage:GRAY_BG_IMAGE forState:UIControlStateNormal];
    
    [remindSetButton addSubview:tmp1];
    [remindSetButton addSubview:tmpLable1];
    [remindSetButton addSubview:click1];
    [tmp1 release];
    [tmpLable1 release];
    [click1 release];
    [remindSetButton addTarget:self action:@selector(remindAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //关于按钮
    UIImageView *aboutBG = [[UIImageView alloc] init];
    aboutBG.frame = CGRectMake(20.0, 50.0, 280.0, 31.0);
    aboutBG.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"横条2-320" ofType:@"png"]];
    aboutBG.userInteractionEnabled = YES;
     aboutButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 280.0, 31.0)];
    UIImageView *tmp2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"关于.png"]];
    tmp2.frame = CGRectMake(3, 3, 25, 25);
    UILabel *tmpLable2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 3, 100, 25)];
    tmpLable2.backgroundColor = [UIColor clearColor];
    tmpLable2.text = @"关于";
    aboutButton.backgroundColor = [UIColor clearColor];
    [aboutButton addSubview:tmp2];
    [aboutButton addSubview:tmpLable2];
    [aboutButton addSubview:click2];
    [tmp2 release];
    [tmpLable2 release];
    [click2 release];
    [aboutButton addTarget:self action:@selector(aboutAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //反馈按钮
    UIImageView *feedBackBG = [[UIImageView alloc] init];
    feedBackBG.frame = CGRectMake(20.0, 90.0, 280.0, 31.0);
    feedBackBG.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"横条2-320" ofType:@"png"]];
    feedBackBG.userInteractionEnabled = YES;
    feedBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 280.0, 31.0)];
    UIImageView *tmp3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"帮助.png"]];
    tmp3.frame = CGRectMake(3, 3, 25, 25);
    
    UILabel *tmpLable3 = [[UILabel alloc] initWithFrame:CGRectMake(30, 3, 100, 25)];
    tmpLable3.backgroundColor = [UIColor clearColor];
    tmpLable3.text = @"反馈";
    feedBackButton.backgroundColor = [UIColor clearColor];
    [feedBackButton addSubview:tmp3];
    [feedBackButton addSubview:tmpLable3];
    [feedBackButton addSubview:click3];
    [tmp3 release];
    [tmpLable3 release];
    [click3 release];
    [feedBackButton addTarget:self action:@selector(feedBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UserInfoPlistIO *infoPlist = [[UserInfoPlistIO alloc] init];
    BOOL isLogined = [infoPlist isLogin];
    [infoPlist release];
    
    //根据是否登录切换界面
    if(isLogined)
    {
        //若为已经登陆则只有退出登录按钮
        quitButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 140.0, 280.0, 31.0)];
        quitButton.backgroundColor = [UIColor clearColor];
        
        UIImage *lbnImg = [LSUtil scaleToSize:[UIImage imageNamed:@"确认未按.png"] size:CGSizeMake(130, 31)];
        [quitButton setBackgroundImage:lbnImg forState:UIControlStateNormal];
        [quitButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [quitButton addTarget:self action:@selector(quitAction:) forControlEvents:UIControlEventTouchUpInside];
        [topBg addSubview:remindBG];
        [remindBG addSubview:remindSetButton];

        [topBg addSubview:aboutBG];
        [aboutBG addSubview:aboutButton];
        
        [topBg addSubview:feedBackBG];
        [feedBackBG addSubview:feedBackButton];
        
        [topBg addSubview:quitButton];
        [self.view addSubview:topBg];
        [remindBG release];
        [remindSetButton release];
        [aboutBG release];
        [aboutButton release];
        [feedBackBG release];
        [feedBackButton release];
        [quitButton release];
        [topBg release];
    }else
    {
        //若未登录则有登录和注册按钮
        loginButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 140.0, 280.0, 31.0)];
        loginButton.backgroundColor = [UIColor clearColor];
        
        UIImage *logImg = [LSUtil scaleToSize:[UIImage imageNamed:@"确认未按.png"] size:CGSizeMake(130, 31)];
        [loginButton setBackgroundImage:logImg forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        
        registerButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 180.0, 280.0, 31.0)];
        registerButton.backgroundColor = [UIColor clearColor];
        
        UIImage *regImg = [LSUtil scaleToSize:[UIImage imageNamed:@"当天按钮1.png"] size:CGSizeMake(130, 31)];
        [registerButton setBackgroundImage:regImg forState:UIControlStateNormal];
        [registerButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [topBg addSubview:remindBG];
        [remindBG addSubview:remindSetButton];
        
        [topBg addSubview:aboutBG];
        [aboutBG addSubview:aboutButton];
        
        [topBg addSubview:feedBackBG];
        [feedBackBG addSubview:feedBackButton];
        
        [topBg addSubview:loginButton];
        [topBg addSubview:registerButton];
        [self.view addSubview:topBg];
        [remindBG release];
        [remindSetButton release];
        [aboutBG release];
        [aboutButton release];
        [feedBackBG release];
        [feedBackButton release];
        [loginButton release];
        [registerButton release];
        [topBg release];
    }
    
    
}

-(void) registerAction: (id)sender//注册事件
{
    RegisterViewController *iv = [[RegisterViewController alloc] init];
    iv.lsViewController = LSHomeViewController;
    iv.ls_IWatchSelectedController = OthersController;
    [self.navigationController pushViewController:iv animated:YES];
    [iv release];   
}

-(void) loginAction: (id)sender//登录事件
{
    LoginViewController *iv = [[LoginViewController alloc] initWithFrame:LSHomeViewController selection:OthersController];

    [self.navigationController pushViewController:iv animated:YES];
}

-(void) remindAction: (id)sender//提醒设置事件
{
    RemindSetting *iv = [[RemindSetting alloc] init];

    [self.navigationController pushViewController:iv animated:YES];
}

-(void) aboutAction: (id)sender//关于事件
{
    NSString *about = [[@"怡情体育(" stringByAppendingString:[LoginAndRegisterFetcher fetchVersion]] stringByAppendingString:@")"];
    
    NSString *aboutContent = [about stringByAppendingString:@"\n 客服电话:0755-26985155"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"关于移情体育" message:aboutContent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    [alert release];
    
}

-(void) feedBackAction: (id)sender//反馈事件
{
    Feedback *iv = [[Feedback alloc] init];
    [self.navigationController pushViewController:iv animated:YES];

    [iv release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}

-(void) quitAction:(id)sender//退出登录事件
{
    UserInfoPlistIO *plistIO = [[UserInfoPlistIO alloc] init];
    [plistIO setLoginedOrNot:NO];
    [plistIO release];
    LeisureSportAppDelegate *app=[[UIApplication sharedApplication] delegate];
    [app gotoController:LSHomeViewController selection:OthersController];
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

@end
