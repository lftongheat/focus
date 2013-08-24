//
//  RemindSetting.m
//  LeisureSport
//
//  Created by 高 峰 on 12-6-25.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "RemindSetting.h"
#import "LSUtil.h"
#import "CheckBox.h"
#import "RemindSettingPlist.h"

@implementation RemindSetting

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [switchBg release];
    [switchOffBg release];
    [switchOnBg release];
    [mySwitch release];
    [ringCheckBox release];
    [vibrateCheckBox release];
    [footballCheckBox release];
    [basketballCheckBox release];
    
    [super dealloc];
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
    
    //添加左导航键
    UIButton * backButton=[UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"返回按钮按下.png"] forState:UIControlStateHighlighted];
	[backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	backButton.frame=CGRectMake(3,3, 48, 30);
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = back;
    [back release];
    
    //读取当前设置并初始化
    RemindSettingPlist *remindSettingPlist = [[RemindSettingPlist alloc] init];
    NSMutableArray *remindArray = [[remindSettingPlist readPlist:@""] mutableCopy];
    [remindSettingPlist release];
    
    //导航栏设置
    self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:(82.0/255.0) green:(81.0/255.0) blue:(81.0/255.0) alpha:1];
    self.title = @"提醒设置";
    
    
    switchBg = PALEGREEN_BG_VIEW;
    switchBg.frame = CGRectMake(0, 0, 320, 60);
    
    //启动提示
    UIView *switchView = [[UIView alloc] initWithFrame:CGRectMake(20, 8, 280, 40)];
    UIImageView *switchBackGround = [[UIImageView alloc] init];
    switchBackGround.frame = CGRectMake(0, 0, 280, 40);
    switchBackGround.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"横条1-320" ofType:@"png"]];
    [switchView addSubview:switchBackGround];
    [switchBackGround release];
    UILabel *switchLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 140, 30)];
    switchLable.backgroundColor = [UIColor clearColor];
    switchLable.text = @"启用提示";
    mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(180, 5, 50, 30)];
    
    NSString *switchFromremindArray = [remindArray objectAtIndex:0];
    if(switchFromremindArray.length==0)
    {
        mySwitch.on = NO;
    }else
    {
        mySwitch.on = YES;
    }
    [switchFromremindArray release];
    
    
    [mySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    [switchView addSubview:switchLable];
    [switchLable release];
    [switchView addSubview:mySwitch];
    
    
    
    [switchBg addSubview:switchView];
    [switchView release];
    
    [self.view addSubview:switchBg];
    switchBg.userInteractionEnabled = YES;
    
    switchOffBg = PALEGREEN_BG_VIEW;
    switchOffBg.frame = CGRectMake(0, 60, 320, 170);

    
    //提示效果
    UIView *remindStyleView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    UIImageView *remindStyleBackGround = [[UIImageView alloc] init];
     remindStyleBackGround.frame = CGRectMake(0, 0, 280, 40);
    remindStyleBackGround.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"横条1-320" ofType:@"png"]];
    [remindStyleView addSubview:remindStyleBackGround];
    [remindStyleBackGround release];
    
    UILabel *remindStyleLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 140, 30)];
    remindStyleLable.backgroundColor = [UIColor clearColor];
    remindStyleLable.text = @"提示效果";

    
    [remindStyleView addSubview:remindStyleLable];
    [remindStyleLable release];

    [switchOffBg addSubview:remindStyleView];
    [remindStyleView release];
    
    //足球提示条件
    UIView *foorballView = [[UIView alloc] initWithFrame:CGRectMake(20, 65, 280, 40)];
    UIImageView *foorballBackGround  = [[UIImageView alloc] init];
    foorballBackGround.frame = CGRectMake(0, 0, 280, 40);
    foorballBackGround.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"横条1-320" ofType:@"png"]];
    [foorballView addSubview:foorballBackGround];
    [foorballBackGround release];
    UILabel *foorballLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 140, 30)];
    foorballLable.backgroundColor = [UIColor clearColor];
    foorballLable.text = @"足球提示条件";
    
    
    [foorballView addSubview:foorballLable];
    [foorballLable release];
    
    [switchOffBg addSubview:foorballView];
    [foorballView release];
    
    //篮球提示条件
    UIView *basketballView = [[UIView alloc] initWithFrame:CGRectMake(20, 110, 280, 40)];
    UIImageView *basketballBackGround = [[UIImageView alloc] init];
    basketballBackGround.frame = CGRectMake(0, 0, 280, 40);
    basketballBackGround.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"横条1-320" ofType:@"png"]];
    [basketballView addSubview:basketballBackGround];
    [basketballBackGround release];
    
    UILabel *basketballLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 140, 30)];
    basketballLable.backgroundColor = [UIColor clearColor];
    basketballLable.text = @"篮球提示条件";
    
    
    [basketballView addSubview:basketballLable];
    [basketballLable release];
    
    [switchOffBg addSubview:basketballView];
    [basketballView release];
    
    [self.view addSubview:switchOffBg];
    switchOffBg.userInteractionEnabled = YES;
    
    
    switchOnBg = PALEGREEN_BG_VIEW;
    switchOnBg.frame = CGRectMake(0, 60, 320, 310);
    
    

    //提示效果
    UIView *remindStyleOnView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 280, 100)];
    UIImageView *remindStyleOnBackGround = GRAY_BG_VIEW;
    remindStyleOnBackGround.frame = CGRectMake(0, 0, 280, 100);
    [remindStyleOnView addSubview:remindStyleOnBackGround];
    [remindStyleOnBackGround release];
    
    UILabel *remindStyleOnLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 140, 30)];
    remindStyleOnLable.backgroundColor = [UIColor clearColor];
    remindStyleOnLable.text = @"提示效果";
    [remindStyleOnView addSubview:remindStyleOnLable];
    [remindStyleOnLable release];
    
    UIImageView *line1 = INTERVAL_BG_VIEW;
    line1.frame = CGRectMake(0, 35, 280, 1);
    [remindStyleOnView addSubview:line1];
    [line1 release];
    
    UILabel *ringOnLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 140, 30)];
    ringOnLable.backgroundColor = [UIColor clearColor];
    ringOnLable.text = @"铃声";
    [remindStyleOnView addSubview:ringOnLable];
    [ringOnLable release];
    
    
    ringCheckBox = [[CheckBox alloc]initWithFrame:CGRectMake(230, 35, 30, 30)];
    NSString *ringFromremindArray = [remindArray objectAtIndex:1];
    if(ringFromremindArray.length==0)
    {
        [ringCheckBox setIsChecked:NO];
    }else
    {
        [ringCheckBox setIsChecked:YES];
    }
    [ringFromremindArray release];
    
    [ringCheckBox setTarget:self fun:@selector(ringCheckBox:)];
    
    [remindStyleOnView addSubview:ringCheckBox];

    UIImageView *line2 = INTERVAL_BG_VIEW;
    line2.frame = CGRectMake(0, 65, 280, 1);
    [remindStyleOnView addSubview:line2];
    [line2 release];
    
    UILabel *vibrateOnLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 65, 140, 30)];
    vibrateOnLable.backgroundColor = [UIColor clearColor];
    vibrateOnLable.text = @"震动";
    [remindStyleOnView addSubview:vibrateOnLable];
    [vibrateOnLable release];
    
    vibrateCheckBox = [[CheckBox alloc]initWithFrame:CGRectMake(230, 65, 30, 30)];
    NSString *vibrateFromremindArray = [remindArray objectAtIndex:2];
    if(vibrateFromremindArray.length==0)
    {
        [vibrateCheckBox setIsChecked:NO];
    }else
    {
        [vibrateCheckBox setIsChecked:YES];
    }
    [vibrateFromremindArray release];
    
    [vibrateCheckBox setTarget:self fun:@selector(vibrateCheckBox:)];
    [remindStyleOnView addSubview:vibrateCheckBox];
   
    [switchOnBg addSubview:remindStyleOnView];
    [remindStyleOnView release];
    
    
    
    //足球提示效果
    UIView *footballStyleOnView = [[UIView alloc] initWithFrame:CGRectMake(20, 125, 280, 80)];
    UIImageView *footballStyleOnBackGround = GRAY_BG_VIEW;
    footballStyleOnBackGround.frame = CGRectMake(0, 0, 280, 80);
    [footballStyleOnView addSubview:footballStyleOnBackGround];
    [footballStyleOnBackGround release];
    
    UILabel *foorballOnLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 140, 30)];
    foorballOnLable.backgroundColor = [UIColor clearColor];
    foorballOnLable.text = @"足球提示条件";
    
    
    [footballStyleOnView addSubview:foorballOnLable];
    [foorballOnLable release];
    
    UIImageView *line3 = INTERVAL_BG_VIEW;
    line3.frame = CGRectMake(0, 35, 280, 1);
    [footballStyleOnView addSubview:line3];
    [line3 release];
    
    UILabel *foorballBeginAndEndLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 140, 30)];
    foorballBeginAndEndLable.backgroundColor = [UIColor clearColor];
    foorballBeginAndEndLable.text = @"开始/结束";
    
    [footballStyleOnView addSubview:foorballBeginAndEndLable];
    [foorballBeginAndEndLable release];
    
    footballCheckBox = [[CheckBox alloc]initWithFrame:CGRectMake(230, 40, 30, 30)];
    NSString *footballFromremindArray = [remindArray objectAtIndex:3];
    if(footballFromremindArray.length==0)
    {
        [footballCheckBox setIsChecked:NO];
    }else
    {
        [footballCheckBox setIsChecked:YES];
    }
    [footballFromremindArray release];
    [footballCheckBox setTarget:self fun:@selector(footballCheckBox:)];
    [footballStyleOnView addSubview:footballCheckBox];

    [switchOnBg addSubview:footballStyleOnView];
    [footballStyleOnView release];
    
    
    //篮球提示效果
    UIView *basketballStyleOnView = [[UIView alloc] initWithFrame:CGRectMake(20, 210, 280, 80)];
    UIImageView *basketballStyleOnBackGround = GRAY_BG_VIEW;
    basketballStyleOnBackGround.frame = CGRectMake(0, 0, 280, 80);
    [basketballStyleOnView addSubview:basketballStyleOnBackGround];
    [basketballStyleOnBackGround release];
    
    UILabel *basketballOnLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 140, 30)];
    basketballOnLable.backgroundColor = [UIColor clearColor];
    basketballOnLable.text = @"篮球提示条件";
    
    
    [basketballStyleOnView addSubview:basketballOnLable];
    [basketballOnLable release];
    
    UIImageView *line4 = INTERVAL_BG_VIEW;
    line4.frame = CGRectMake(0, 35, 280, 1);
    [basketballStyleOnView addSubview:line4];
    [line4 release];
    
    UILabel *basketballBeginAndEndLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 140, 30)];
    basketballBeginAndEndLable.backgroundColor = [UIColor clearColor];
    basketballBeginAndEndLable.text = @"开始/结束";
    
    [basketballStyleOnView addSubview:basketballBeginAndEndLable];
    [basketballBeginAndEndLable release];
    
    basketballCheckBox = [[CheckBox alloc]initWithFrame:CGRectMake(230, 40, 30, 30)];
    NSString *basketballFromremindArray = [remindArray objectAtIndex:4];
    if(basketballFromremindArray.length==0)
    {
        [basketballCheckBox setIsChecked:NO];
    }else
    {
        [basketballCheckBox setIsChecked:YES];
    }
    [basketballFromremindArray release];
    [basketballCheckBox setTarget:self fun:@selector(basketballCheckBox:)];
    [basketballStyleOnView addSubview:basketballCheckBox];
    
    [switchOnBg addSubview:basketballStyleOnView];
    [basketballStyleOnView release];
    
    
    
    [self.view addSubview:switchOnBg];
    switchOnBg.userInteractionEnabled = YES;
   // topBg.userInteractionEnabled = YES;
    
    
    //根据是否开启提示切换不同的界面
    if(mySwitch.on)
    {
        [switchOnBg setHidden:NO];
        [switchOffBg setHidden:YES];
    }else
    {
        [switchOnBg setHidden:YES];
        [switchOffBg setHidden:NO];
    }
  //  [switchOnBg setHidden:YES];
    
   // [offBg release];
//    [remindSettingPlist release];
//    [remindArray release];
}


-(void) switchAction:(id) sender//是否启动提示事件
{
    
    RemindSettingPlist *remindSettingPlist = [[RemindSettingPlist alloc] init];
    if(mySwitch.on)
    {
        [remindSettingPlist writeToPlist:@"1" index:0];
        [switchOnBg setHidden:NO];
        [switchOffBg setHidden:YES];
    }else
    {
        [remindSettingPlist writeToPlist:@"" index:0];
        [switchOnBg setHidden:YES];
        [switchOffBg setHidden:NO];
    }
}

-(void)ringCheckBox:(id)sender//是否启用铃声事件
{
    RemindSettingPlist *remindSettingPlist = [[RemindSettingPlist alloc] init];
    
    if(ringCheckBox.isChecked)
    {
        [remindSettingPlist writeToPlist:@"1" index:1];
    }else
    {
        [remindSettingPlist writeToPlist:@"" index:1];
    }
    [remindSettingPlist release];
}

-(void)vibrateCheckBox:(id)sender//是否启用震动事件
{
    RemindSettingPlist *remindSettingPlist = [[RemindSettingPlist alloc] init];
    
    if(ringCheckBox.isChecked)
    {
        [remindSettingPlist writeToPlist:@"1" index:2];
    }else
    {
        [remindSettingPlist writeToPlist:@"" index:2];
    }
    [remindSettingPlist release];
}

-(void)footballCheckBox:(id)sender//是否为足球启用提示事件
{
    RemindSettingPlist *remindSettingPlist = [[RemindSettingPlist alloc] init];
    if(ringCheckBox.isChecked)
    {
        [remindSettingPlist writeToPlist:@"1" index:3];
    }else
    {
        [remindSettingPlist writeToPlist:@"" index:3];
    }
    [remindSettingPlist release];
}
-(void)basketballCheckBox:(id)sender//是否为篮球启用提示事件
{
    RemindSettingPlist *remindSettingPlist = [[RemindSettingPlist alloc] init];
    if(ringCheckBox.isChecked)
    {
        [remindSettingPlist writeToPlist:@"1" index:4];
    }else
    {
        [remindSettingPlist writeToPlist:@"" index:4];
    }
    [remindSettingPlist release];
}

//返回
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
