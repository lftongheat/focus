//
//  LeisureSportAppDelegate.m
//  DelightSports
//
//  Created by ACE hitsz302 on 12-5-21.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "LeisureSportAppDelegate.h"
#import "HomeViewController.h"
#import "SportsDynamicController.h"
#import "IWatchController.h"
#import "TVLiveController.h"
#import "FansCenterController.h"
#import "UserInfoPlistIO.h"
#import "LoginViewController.h"
#import "More.h"
#import "UserInfoPlistIO.h"

@implementation LeisureSportAppDelegate

static NSString *userImageID;
static NSString *userID;

@synthesize window;
@synthesize homeViewController;
@synthesize lsTabBarController;

//静态类变量userImageID  getter/setter
+ (NSString *)userImageID {
    return userImageID;
}

+ (void)setUserImageID:(NSString *)imageID{
    userImageID = imageID;
}

+ (NSString *)userID {
    return userID;
}

+ (void)setUserID:(NSString *)ID{
    userID = ID;
}
//end

- (void)dealloc
{
    [window release];
    [homeViewController release];
    [lsTabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    UIWindow * tmpWindow=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];	
	tmpWindow.backgroundColor=[UIColor blackColor];
	self.window=tmpWindow;	
	[tmpWindow release];
	
    [self gotoController:LSHomeViewController selection:OthersController];
    [self.window makeKeyAndVisible];
    
    //读取userID信息
//    UserInfoPlistIO *userInfoPlistIO = [[UserInfoPlistIO alloc] init];
//    NSString *tmp = [[userInfoPlistIO readUserID:@""] mutableCopy];
//    [LeisureSportAppDelegate setUserID:tmp];
//    [userInfoPlistIO release];
    
    return YES;
}

- (void)gotoController:(LSViewController)controller selection:(LS_IWatchSelectedController)selected
{
    UserInfoPlistIO *infoPlist = [[UserInfoPlistIO alloc] init];
    BOOL isLogined = [infoPlist isLogin];
    [infoPlist release];
    
    if (controller == LSHomeViewController) {
        [lsTabBarController.view removeFromSuperview];
		
        if (homeViewController) {
            [homeViewController release];
            homeViewController = nil;
        }
		homeViewController = [[HomeViewController alloc] init];
		[window addSubview:homeViewController.view];
        
    } else{
        [homeViewController.view removeFromSuperview];
//        if (homeViewController) {
//            [homeViewController.view removeFromSuperview];
//            [homeViewController release];
//            homeViewController = nil;
//        }
        
		//tabbar
		UITabBarController  *tmpTab=[[UITabBarController alloc] init];
		self.lsTabBarController=tmpTab;
		[tmpTab release];
        
		//controllers
		SportsDynamicController  *sdVC = [[SportsDynamicController alloc] init];
		sdVC.tabBarItem=[[[UITabBarItem alloc] initWithTitle:@"体育动态" 
                                                       image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SportsDynamic" ofType:@"png"]] 
                                                         tag:0] autorelease];
		UINavigationController *nav1=[[UINavigationController alloc] initWithRootViewController:sdVC];
		[sdVC release];
        UINavigationController *nav2;
        if(selected==NbaController||selected==XijiaController||selected==YijiatchController||selected==ZhongchaoController||selected==YingchaoController||selected==DejiaController||selected==CBAController||selected==MyWatchController||selected==OthersController)
        {
            if(selected==OthersController)
            {
                IWatchController *iwVC = [[IWatchController alloc] initWithFrame:MyWatchController];
                iwVC.tabBarItem=[[[UITabBarItem alloc] initWithTitle:@"我的关注" 
                                                               image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IWatch" ofType:@"png"]] 
                                                                 tag:1] autorelease];        
                nav2=[[UINavigationController alloc] initWithRootViewController:iwVC];
                [iwVC release];
            }else
            {
                IWatchController *iwVC = [[IWatchController alloc] initWithFrame:selected];
                iwVC.tabBarItem=[[[UITabBarItem alloc] initWithTitle:@"我的关注" 
                                                               image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IWatch" ofType:@"png"]] 
                                                                 tag:1] autorelease];        
                nav2=[[UINavigationController alloc] initWithRootViewController:iwVC];
                [iwVC release];
            }
            
            
        }else
        {
            if (isLogined) {
                IWatchController *iwVC = [[IWatchController alloc] initWithFrame:selected];
                iwVC.tabBarItem=[[[UITabBarItem alloc] initWithTitle:@"我的关注" 
                                                               image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IWatch" ofType:@"png"]] 
                                                                 tag:1] autorelease];        
                nav2=[[UINavigationController alloc] initWithRootViewController:iwVC];
                [iwVC release];
            } else {
                LoginViewController *ulVC = [[LoginViewController alloc] initWithFrame:controller selection:selected];
                
                ulVC.tabBarItem=[[[UITabBarItem alloc] initWithTitle:@"我的关注" 
                                                               image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IWatch" ofType:@"png"]] 
                                                                 tag:1] autorelease];   
                nav2 = [[UINavigationController alloc] initWithRootViewController:ulVC];
                [ulVC release];
            }
        }
        
        TVLiveController *tlVC = [[TVLiveController alloc] init];
		tlVC.tabBarItem=[[[UITabBarItem alloc] initWithTitle:@"电视直播" 
                                                       image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TVLive" ofType:@"png"]] 
                                                         tag:2] autorelease];        
		UINavigationController *nav3=[[UINavigationController alloc] initWithRootViewController:tlVC];
		[tlVC release];
        
        UINavigationController *nav4;
        if (isLogined) {
            FansCenterController *fcVC = [[FansCenterController alloc] init];
            
            fcVC.tabBarItem=[[[UITabBarItem alloc] initWithTitle:@"球迷社区" 
                                                           image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ICenter" ofType:@"png"]] 
                                                             tag:3] autorelease];    
            nav4 = [[UINavigationController alloc] initWithRootViewController:fcVC];
            [fcVC release];
        } else {
            LoginViewController *ulVC = [[LoginViewController alloc] initWithFrame:controller selection:selected];
            
            ulVC.tabBarItem=[[[UITabBarItem alloc] initWithTitle:@"球迷社区" 
                                                           image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ICenter" ofType:@"png"]] 
                                                             tag:3] autorelease];   
            nav4 = [[UINavigationController alloc] initWithRootViewController:ulVC];
            [ulVC release];
        }
        
        More  *moreVC = [[More alloc] init];
		moreVC.tabBarItem=[[[UITabBarItem alloc] initWithTitle:@"更多" 
                                                         image:[UIImage imageNamed:@"More.png"]
                                                           tag:4] autorelease];
		UINavigationController *nav5=[[UINavigationController alloc] initWithRootViewController:moreVC];
		[moreVC release];
        
        
		NSArray* controllers = [NSArray arrayWithObjects:nav1, nav2, nav3, nav4,nav5, nil];
		lsTabBarController.viewControllers = controllers;
        lsTabBarController.selectedIndex = controller-1;
        
		// 隐藏上下  重新加载 
		[window addSubview:lsTabBarController.view];        
        
		[nav1 release];
        [nav2 release];
        [nav3 release];
		[nav4 release];
        [nav5 release];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end

@implementation UINavigationBar(UINavigationBarCategory)
- (void)drawRect:(CGRect)rect{
    UIImage *img = [UIImage imageNamed:@"NaviBarBg.png"];
    [img drawInRect:rect];
}
@end
