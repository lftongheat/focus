//
//  FansCenterController.m
//  DelightSports
//
//  Created by ACE hitsz302 on 12-5-18.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "FansCenterController.h"
#import "LeisureSportAppDelegate.h"
#import "LSUtil.h"
#import "UserTaskController.h"
#import "FansCenterFetcher.h"
#import "FavorTeamController.h"
#import "FavorLeagueController.h"
#import "FollowerViewController.h"
#import "CommentViewController.h"
#import "FansViewController.h"
#import "MessageViewController.h"
#import "FourCrossCell.h"
#import "LeagueInfo.h"
#import "ModalAlert.h"

#import "UserInfoPlistIO.h"
#import "UIButton+WebCache.h"

@implementation FansCenterController

#define NICKNAME_LABEL_TAG 251
#define HEADICON_BUTTON_TAG 252
#define SIGNTEXT_LABEL_TAG 253

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{

}

- (void)viewDidAppear:(BOOL)animated
{
	//加载数据
    if ([LSUtil connectedToNetwork] && needReload) {
        //更新数据
        if (userInfo) {
            [userInfo release];
            userInfo = nil;
        }
        userInfo = [FansCenterFetcher fetchUserInfo:[LeisureSportAppDelegate userID] myUserID:[LeisureSportAppDelegate userID]];
        UIButton *headIconButton = (UIButton*)[self.view viewWithTag:HEADICON_BUTTON_TAG];
        [headIconButton setImageWithURL:IMAGE_URL(userInfo.ImageID) placeholderImage:IMAGEWITHCONTENTSOFFILE(@"默认头像")];
        UILabel *nickNameLabel = (UILabel*)[self.view viewWithTag:NICKNAME_LABEL_TAG];
        nickNameLabel.text = userInfo.NickName;
        UILabel *signTextLabel = (UILabel*)[self.view viewWithTag:SIGNTEXT_LABEL_TAG];
        signTextLabel.text = userInfo.introduce;
        [groupTableView reloadData];
        [LeisureSportAppDelegate setUserImageID:userInfo.ImageID];
        
        needReload = NO;
    }

    
    //加载结束
    [HUD hide:YES];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)dealloc
{
    [groupTableView release];
    [userInfo release];
    [super dealloc];
}

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
//    if (![LeisureSportAppDelegate userID] || [[LeisureSportAppDelegate userID] length]==0) {
        UserInfoPlistIO *userInfoPlistIO = [[UserInfoPlistIO alloc] init];
        NSString *tmp = [[userInfoPlistIO readUserID:@""] mutableCopy];
        [LeisureSportAppDelegate setUserID:tmp];
        [userInfoPlistIO release];
//    }
    needReload = YES;
    
    //首页按钮
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage:IMAGEWITHCONTENTSOFFILE(@"首页按钮") forState:0];
    [backButton setImage:IMAGEWITHCONTENTSOFFILE(@"首页按钮按下") forState:UIControlStateHighlighted];
	[backButton addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
	backButton.frame=CGRectMake(3,3, 48, 30);
    
    //刷新按钮
    UIButton * refreshButton=[UIButton buttonWithType:UIButtonTypeCustom];
	[refreshButton setImage:IMAGEWITHCONTENTSOFFILE(@"刷新按钮") forState:UIControlStateNormal];
    [refreshButton setImage:IMAGEWITHCONTENTSOFFILE(@"刷新按钮按下") forState:UIControlStateHighlighted];
	[refreshButton addTarget:self action:@selector(refreshClick) forControlEvents:UIControlEventTouchUpInside];
	refreshButton.frame=CGRectMake(303,3, 48, 30);
    
	UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.leftBarButtonItem = back;
    self.navigationItem.rightBarButtonItem = refresh;
    [back release];
    [refresh release];
	
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:IMAGEWITHCONTENTSOFFILE(@"NaviBarBg") forBarMetrics:UIBarMetricsDefault];
    }
    if ([self.tabBarController.tabBar respondsToSelector:@selector(setBackgroundImage:)]) {
        [self.tabBarController.tabBar setBackgroundImage:IMAGEWITHCONTENTSOFFILE(@"TabBarBg")];
    }
    
    self.title = @"个人管理";
    
    
    //design the UI
    //头像
    UIImageView *headImageView = PALEGREEN_BG_VIEW;
    headImageView.userInteractionEnabled = YES;
    headImageView.frame = CGRectMake(0, 0, 105, 110);
    
    UIButton *headIconButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 12, 80, 80)];
    headIconButton.tag = HEADICON_BUTTON_TAG;
    [headIconButton addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [headImageView addSubview: headIconButton];
    [headIconButton release];
    [self.view addSubview:headImageView];
    [headImageView release];
    
    //昵称、签名、任务
    UIImageView *signImageView = PALEGREEN_BG_VIEW;
    signImageView.frame = CGRectMake(105, 0, 215, 110);
    signImageView.userInteractionEnabled = YES;
    
    UIButton *nickNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nickNameButton.frame = CGRectMake(10, 12, 105, 25);
    [nickNameButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [nickNameButton addTarget:self action:@selector(editNickName) forControlEvents:UIControlEventTouchUpInside];
    UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 105, 25)];
    nickNameLabel.backgroundColor = [UIColor clearColor];
    nickNameLabel.tag = NICKNAME_LABEL_TAG;
    
    UILabel *signPrompt = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 100, 20)];
    signPrompt.text = @"个性签名：";
    signPrompt.font = [UIFont systemFontOfSize:10];
    signPrompt.backgroundColor = [UIColor clearColor];
    
    UILabel *signTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 105, 40)];
    signTextLabel.tag = SIGNTEXT_LABEL_TAG;
    signTextLabel.numberOfLines = 0;
    signTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    signTextLabel.backgroundColor = [UIColor whiteColor];
    signTextLabel.font = [UIFont systemFontOfSize:13];
    signTextLabel.layer.cornerRadius = 6;
    signTextLabel.layer.masksToBounds = YES;
    
    UIButton *signTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signTextButton.frame = CGRectMake(10, 55, 105, 40);
    signTextButton.backgroundColor = [UIColor clearColor];
    [signTextButton addTarget:self action:@selector(editIntroduce) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *taskButton= [[UIButton alloc] initWithFrame:CGRectMake(120, 12, 80, 85)];
    [taskButton setBackgroundImage:IMAGEWITHCONTENTSOFFILE(@"任务") forState:UIControlStateNormal];
    [taskButton addTarget:self action:@selector(jumpToTaskView:) forControlEvents:UIControlEventTouchUpInside];
    //获取日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-EEE"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    NSArray *dateArray = [date componentsSeparatedByString:@"-"];
    NSString *monthAndDay = [NSString stringWithFormat:@"%@/%@",[dateArray objectAtIndex:0], [dateArray objectAtIndex:1]];
    //
    UILabel *dateLabel= [[UILabel alloc] initWithFrame:CGRectMake(140, 18, 50, 25)];
    dateLabel.text = monthAndDay;
    dateLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *weekLabel= [[UILabel alloc] initWithFrame:CGRectMake(145, 40, 50, 25)];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        weekLabel.text = [self translateToChineseWeekday:[dateArray objectAtIndex:2]];
    } else {
        weekLabel.text = [dateArray objectAtIndex:2];
    }
    weekLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *taskLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 65, 50, 30)];
    taskLabel.text = @"任务";
    taskLabel.textColor = [UIColor orangeColor];
    taskLabel.font = [UIFont systemFontOfSize:23];
    taskLabel.backgroundColor = [UIColor clearColor];

    [signImageView addSubview:nickNameButton];
    [signImageView addSubview:nickNameLabel];
    [signImageView addSubview:signPrompt];
    [signImageView addSubview:signTextLabel];
    [signImageView addSubview:signTextButton];
    [signImageView addSubview:taskButton];
    [signImageView addSubview:dateLabel];
    [signImageView addSubview:weekLabel];
    [signImageView addSubview:taskLabel];
    
    [nickNameLabel release];
    [signPrompt release];
    [signTextLabel release];
    [taskButton release];
    [dateLabel release];
    [weekLabel release];
    [taskLabel release];
    
    [self.view addSubview:signImageView];
    [signImageView release];
    
    
    
    //group table view
	groupTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 110, 320, 260) style:UITableViewStyleGrouped];
    groupTableView.backgroundView = PALEGREEN_BG_VIEW_AUTORELEASE;
    groupTableView.backgroundColor = [UIColor clearColor];
	groupTableView.delegate=self;
	groupTableView.dataSource=self;
	groupTableView.scrollEnabled=NO;
    groupTableView.sectionFooterHeight = 0;
    groupTableView.sectionHeaderHeight = 8;
    groupTableView.allowsSelection = YES;
    groupTableView.userInteractionEnabled = YES;
	[self.view addSubview:groupTableView];   
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	HUD.delegate = self;
	[HUD show:YES];
}

//将英文星期转换为中午
- (NSString *)translateToChineseWeekday: (NSString *)english
{
    if ([english isEqualToString:@"Mon"])   return @"周一";
    if ([english isEqualToString:@"Tue"])   return @"周二";
    if ([english isEqualToString:@"Wed"])   return @"周三";
    if ([english isEqualToString:@"Thu"])   return @"周四";
    if ([english isEqualToString:@"Fri"])   return @"周五";
    if ([english isEqualToString:@"Sat"])   return @"周六";
    if ([english isEqualToString:@"Sun"])   return @"周日";
    return @"";
}

//按钮点击事件
//返回
- (void)backToHome
{
	LeisureSportAppDelegate *app=[[UIApplication sharedApplication] delegate];
	
	[app gotoController:LSHomeViewController selection:OthersController];
}


- (void)refreshClick {
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	HUD.delegate = self;
	[HUD show:YES];
    
    //更新数据
    if (userInfo) {
        [userInfo release];
        userInfo = nil;
    }
    userInfo = [FansCenterFetcher fetchUserInfo:[LeisureSportAppDelegate userID] myUserID:[LeisureSportAppDelegate userID]];
    UIButton *headIconButton = (UIButton*)[self.view viewWithTag:HEADICON_BUTTON_TAG];
    [headIconButton setImageWithURL:IMAGE_URL(userInfo.ImageID) placeholderImage:IMAGEWITHCONTENTSOFFILE(@"默认头像")];
    UILabel *nickNameLabel = (UILabel*)[self.view viewWithTag:NICKNAME_LABEL_TAG];
    nickNameLabel.text = userInfo.NickName;
    UILabel *signTextLabel = (UILabel*)[self.view viewWithTag:SIGNTEXT_LABEL_TAG];
    signTextLabel.text = userInfo.introduce;
    [groupTableView reloadData];
    [LeisureSportAppDelegate setUserImageID:userInfo.ImageID];
    
    [HUD hide:YES];
}
//修改昵称
- (void)editNickName
{
    NSString *nickName = [ModalAlert ask:@"修改昵称" withTextPrompt:@"昵称"];
	
	// Show result based on answer
	if (nickName){
		userInfo.NickName = nickName;
        if ([FansCenterFetcher updateUserInfo:userInfo]) {
            UILabel *nickNameLabel = (UILabel*)[self.view viewWithTag:NICKNAME_LABEL_TAG];
            nickNameLabel.text = userInfo.NickName;
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"操作成功";
            hud.margin = 10.f;
            hud.yOffset = 150.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:2];
        }
    }
}

//修改签名
- (void)editIntroduce
{
    NSString *introduce = [ModalAlert ask:@"修改签名" withTextPrompt:@"签名"];
	
	// Show result based on answer
	if (introduce){
		userInfo.introduce = introduce;
        if ([FansCenterFetcher updateUserInfo:userInfo]) {
            UILabel *signTextLabel = (UILabel*)[self.view viewWithTag:SIGNTEXT_LABEL_TAG];
            signTextLabel.text = userInfo.introduce;
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"操作成功";
            hud.margin = 10.f;
            hud.yOffset = 150.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:2];
        }
    }
}

//转到任务中心
- (void)jumpToTaskView:(id)sender
{
    UserTaskController *userTaskController = [[UserTaskController alloc] init];    
    [self.navigationController pushViewController:userTaskController animated:YES];    
    [userTaskController release];
}

//跳转到关注页面
- (void)jumpToFollowerView:(id)sender
{
    FollowerViewController *followerViewController = [[FollowerViewController alloc] init];
    followerViewController.myUserID = [LeisureSportAppDelegate userID];
    [self.navigationController pushViewController:followerViewController animated:YES];
    [followerViewController release];
    needReload = YES;
}

//跳转到粉丝页面
- (void)jumpToFansView:(id)sender
{
    FansViewController *fansViewController = [[FansViewController alloc] init];
    fansViewController.myUserID = [LeisureSportAppDelegate userID];
    [self.navigationController pushViewController:fansViewController animated:YES];    
    [fansViewController release];
    needReload = YES;
}

//跳转到说说页面
- (void)jumpToCommentView:(id)sender
{
    CommentViewController *commentViewController = [[CommentViewController alloc] init];
    commentViewController.myUserID = [LeisureSportAppDelegate userID];
    [self.navigationController pushViewController:commentViewController animated:YES];
    [commentViewController release];
    needReload = YES;
}
//跳转到私信页面
- (void)jumpToMessageView:(id)sender
{
    MessageViewController *messageViewController = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:messageViewController animated:YES];
    [messageViewController release];
    needReload = YES;
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



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 2)
		return 1;
    else if(section == 0)
        return 1;
	else 
		return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 100;
    }
    return 40;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *IngredientsCellIdentifier = @"IngredientsCell";
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IngredientsCellIdentifier] autorelease];
    
	// Configure the cell.
    if(indexPath.section == 0)
	{
        if(indexPath.row==0)
        {
            FourCrossCell *crosscell = [[[NSBundle mainBundle] loadNibNamed:@"FourCrossCell" owner:self options:nil] lastObject];
            crosscell.selectionStyle = UITableViewCellSelectionStyleNone;
            [crosscell.leftupButton addTarget:self action:@selector(jumpToFollowerView:) forControlEvents:UIControlEventTouchUpInside];
            [crosscell.leftdownButton addTarget:self action:@selector(jumpToCommentView:) forControlEvents:UIControlEventTouchUpInside];
            [crosscell.rightupButton addTarget:self action:@selector(jumpToFansView:) forControlEvents:UIControlEventTouchUpInside];
            [crosscell.rightdownButton addTarget:self action:@selector(jumpToMessageView:) forControlEvents:UIControlEventTouchUpInside];
            
            crosscell.followerNumLabel.text = userInfo.FollowCount;
            crosscell.fansNumLabel.text = userInfo.FollowerCount;
            crosscell.commentNumLabel.text = userInfo.CommentsCount;
            crosscell.messageNumLabel.text = userInfo.MessagesCount;

            return crosscell;
        }
	}	else if(indexPath.section == 1){
		if(indexPath.row==0)
		{
            
            NSMutableString *favorLeagues = [[NSMutableString alloc] init];
            if ([LSUtil connectedToNetwork]) {
                NSMutableArray *leagueArray = [[FansCenterFetcher fetchLeagues] mutableCopy];
                NSMutableString *tmp = [[NSMutableString alloc] init] ;
                NSMutableArray *favorArray = [[FansCenterFetcher getFavorLeagueByUserID:[LeisureSportAppDelegate userID]] mutableCopy];
                for (int i=0; i<[leagueArray count]; i++) {//遍历
                    LeagueInfo *leagueInfo = [leagueArray objectAtIndex:i];
                    if (favorArray && [favorArray containsObject:leagueInfo.LeaugeID]) {
                        [tmp appendString: leagueInfo.Name];
                        [tmp appendString:@","];
                    }
                }
                [favorArray release];
                [leagueArray release];

                int len = [tmp length];
                if (len > 0) {
                    [favorLeagues appendString:[tmp substringToIndex:len-1]];
                }
                [tmp release];
            }
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIImageView *bgView = [[UIImageView alloc] initWithImage:IMAGEWITHCONTENTSOFFILE(@"league_cellbg")];
            cell.backgroundView = bgView;
            [bgView release];
            
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.frame = CGRectMake(19, 0, 240, 38);
            textLabel.text = [NSString stringWithFormat:@"关注赛事：%@", favorLeagues];
            [favorLeagues release];
            textLabel.font = [UIFont systemFontOfSize:14];
            textLabel.backgroundColor = [UIColor clearColor];
            [cell addSubview:textLabel];
            [textLabel release];
            
		}
		
		if(indexPath.row==1)
		{
            NSMutableString *favorTeams = [[NSMutableString alloc] init];
            if(userInfo){
                NSArray *tmpTeams = [userInfo.UserFavorTeams componentsSeparatedByString:@";"];
                for (int i=0; i<[tmpTeams count]-1; i++) {
                    NSArray *tmp = [[tmpTeams objectAtIndex:i] componentsSeparatedByString:@","];
                    [favorTeams appendString: [tmp objectAtIndex:1]];
                    if (i != [tmpTeams count]-1) {
                        [favorTeams appendString:@","];
                    }
                }
            }
			cell.selectionStyle= UITableViewCellSelectionStyleBlue;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIImageView *bgView = [[UIImageView alloc] initWithImage:IMAGEWITHCONTENTSOFFILE(@"team_cellbg")];
            cell.backgroundView = bgView;
            [bgView release];
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.frame = CGRectMake(19, 0, 240, 38);
            textLabel.text = [NSString stringWithFormat:@"关注球队：%@", favorTeams];
            [favorTeams release];
            
            textLabel.font = [UIFont systemFontOfSize:14];
            textLabel.backgroundColor = [UIColor clearColor];
            [cell addSubview:textLabel];
            [textLabel release];
		}
        cell.textLabel.backgroundColor = [UIColor clearColor];
	} else if(indexPath.section==2){
		if(indexPath.row==0)
		{
            NSString *points = @"";
            if(userInfo){
                points = userInfo.points;
            }
            cell.textLabel.font = [UIFont systemFontOfSize:14];
			cell.textLabel.text = [NSString stringWithFormat:@"我的积分：%@", points];
            cell.textLabel.backgroundColor = [UIColor clearColor];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.accessoryType = UITableViewCellAccessoryNone;
                
            UIImageView *bgView = [[UIImageView alloc] initWithImage:IMAGEWITHCONTENTSOFFILE(@"选择框")];
            cell.backgroundView = bgView;
            [bgView release];
		}
	}
	
    return cell;	
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            FavorLeagueController *focusedGameController = [[FavorLeagueController alloc] init];
            [self.navigationController pushViewController:focusedGameController animated:YES];
            [focusedGameController release];
            needReload = YES;
        }
        if (indexPath.row == 1) {
            FavorTeamController *focusedTeamController = [[FavorTeamController alloc] init];
            [self.navigationController pushViewController:focusedTeamController animated:YES];
            [focusedTeamController release];
            needReload = YES;
        }
    }
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark picker image for library
//从本地图片库选取照片
- (void)chooseImage:(id)sender
{
    //navBar 已经隐藏 此时将其显示已返回
	if(navBarHidden)
	{
		navBarHidden=NO;
		self.navigationController.navigationBarHidden=NO;
		return;
	}
    
	//present modelView
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
	{
		UIImagePickerController *picker=[[UIImagePickerController alloc] init];
		picker.delegate=self;
        picker.allowsEditing = YES;
		picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentModalViewController:picker animated:YES];
		[picker release];
	}
}

//用户完成图像选取器 时候调用  用户选择一副图片时候也会调用
-(void)imagePickerController:(UIImagePickerController *)picker
	   didFinishPickingImage:(UIImage  *)image
				 editingInfo:(NSDictionary *)editinginfo
{
	[picker dismissModalViewControllerAnimated:YES];
	[LSUtil uploadImage:image UserID:[LeisureSportAppDelegate userID]];
	navBarHidden=YES;	
	UIButton * imageB=(UIButton *)[self.view viewWithTag:123];
	[imageB setTitle:@"返回" forState:0];
	
}


//用户点击取消按钮 直接解除图像选取器
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissModalViewControllerAnimated:YES];
    
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}
@end
