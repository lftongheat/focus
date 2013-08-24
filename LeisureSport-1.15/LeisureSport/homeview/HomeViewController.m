//
//  HomeViewController.m
//  DelightSports
//
//  Created by ACE hitsz302 on 12-5-21.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "HomeViewController.h"
#import "LeisureSportAppDelegate.h"
#import "MenuSettings.h"
#import "LSUtil.h"

@implementation HomeViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

//- (void)viewWillAppear:(BOOL)animated
//{
//	NSLog(@"Home page viewWillAppear");
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//	NSLog(@"Home page viewDidAppear");
//}

//- (void)viewWillDisappear:(BOOL)animated
//{
//	NSLog(@"Home page viewWillDisappear");
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//	NSLog(@"Home page viewDidDisappear");
//}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    CGRect frame = self.view.frame;
//    CGSize size = frame.size;
//    NSLog(@"width:%f, height:%f", size.width, size.height);
    
    UILabel *appName = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 70, 30)];
    appName.text = @"怡情体育";
    appName.textColor = [UIColor whiteColor];
    appName.backgroundColor = [UIColor clearColor];
    
    UIImage *bgImg = IMAGEWITHCONTENTSOFFILE(@"首页背景");
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImg];

    UIImage *lowerbgImg = IMAGEWITHCONTENTSOFFILE(@"下面按钮背景");
    UIImageView *lowerBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 280, 320, 180)];
    [lowerBg setImage:lowerbgImg];
    [self.view addSubview:lowerBg];
    [lowerBg release];
    
    [self.view addSubview:appName];
    [appName release];
    [self createMenu];
}

/*
//图片缩放代码
- (UIImage*)scaleToSize: (UIImage*)img size:(CGSize)size
{
    //创建一个bitmap的context
    UIGraphicsBeginImageContext(size);
    
    //绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //从当前context中创建以个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //从当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
 */

//创建首页菜单
- (void)createMenu
{
    NSArray *upperNames = [NSArray arrayWithObjects:@"NBA", @"西甲", @"意甲", @"中超", @"英超", @"德甲", @"CBA", nil];
    
    MenuSettings *upperMenu = [[MenuSettings alloc] initWithMarginTop:100 AndCellNum:7];
    for (int i=0; i<upperMenu.cellNumOfView; i++) {
        float x, y;
        x = upperMenu.marginToSide + (i%4)*(upperMenu.cellSize + upperMenu.cellSpacing);
        y = upperMenu.marginToTop + (i/4)*(upperMenu.cellSize + upperMenu.cellSpacing);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x+15, y+upperMenu.cellSize, upperMenu.cellSize, 14)];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setText:[upperNames objectAtIndex:i]];
        [label setBackgroundColor:[UIColor clearColor]];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, upperMenu.cellSize, upperMenu.cellSize)];
        button.tag = 100 + i;
        [button setBackgroundImage:IMAGEWITHCONTENTSOFFILE([upperNames objectAtIndex:i]) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(matchRedirect:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [self.view addSubview:label];
        [button release];
        [label release];
    }    
    [upperMenu release];
    
    NSArray *lowerNames = [NSArray arrayWithObjects:@"我的关注", @"我的球队",@"",@"", @"体坛动态", @"热点赛事", @"电视直播", @"球迷社区", nil];
    MenuSettings *lowerMenu = [[MenuSettings alloc] initWithMarginTop:300 AndCellNum:6];
    for (int i=0; i<lowerMenu.cellNumOfView+2; i++) {
        if(i==2 || i ==3)
            continue;
        float x, y;
        x = lowerMenu.marginToSide + (i%4)*(lowerMenu.cellSize + lowerMenu.cellSpacing);
        y = lowerMenu.marginToTop + (i/4)*(lowerMenu.cellSize + lowerMenu.cellSpacing);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x+3, y+lowerMenu.cellSize, lowerMenu.cellSize, 14)];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setText:[lowerNames objectAtIndex:i]];
        [label setBackgroundColor:[UIColor clearColor]];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, lowerMenu.cellSize, lowerMenu.cellSize)];
        button.tag = 200 + i;
        [button setBackgroundImage: IMAGEWITHCONTENTSOFFILE([lowerNames objectAtIndex:i]) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(otherRedirect:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [self.view addSubview:label];
        [button release];
        [label release];
    }    
    [lowerMenu release];
}

- (void)matchRedirect:(id)sender
{
    LeisureSportAppDelegate *app=[[UIApplication sharedApplication] delegate];
    int index = [sender tag] - 100;
    switch (index) {
        case 0:
            [app gotoController:LSIWatchController selection:NbaController];
            break;
        case 1:    
            [app gotoController:LSIWatchController selection:XijiaController];
            break;
        case 2:
            [app gotoController:LSIWatchController selection:YijiatchController];
            break;
        case 3:    
            [app gotoController:LSIWatchController selection:ZhongchaoController];
            break;
        case 4:
            [app gotoController:LSIWatchController selection:YingchaoController];
            break;
        case 5:    
            [app gotoController:LSIWatchController selection:DejiaController];
            break;
        case 6:    
            [app gotoController:LSIWatchController selection:CBAController];
            break;
        default:
            break;
    }
    
}

- (IBAction)otherRedirect:(id)sender
{
    LeisureSportAppDelegate *app=[[UIApplication sharedApplication] delegate];
    int index = [sender tag] - 200;
    switch (index) {
        case 0:
            [app gotoController:LSIWatchController selection:MyFocusedGameController];
            break;
        case 1:    
            [app gotoController:LSIWatchController selection:MyTeamController];
            break;
        case 4:
            [app gotoController:LSSportDynamicController selection:OthersController];
            break;
        case 5:    
            [app gotoController:LSIWatchController selection:MyWatchController];
            break;
        case 6:
            [app gotoController:LSTVLiveController selection:OthersController];
            break;
        case 7:    
            [app gotoController:LSFunsCenterController selection:OthersController];
            break;
        default:
            break;
    }
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
