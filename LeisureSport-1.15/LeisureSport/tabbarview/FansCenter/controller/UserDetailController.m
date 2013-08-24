//
//  UserDetailController.m
//  DelightSports
//
//  Created by ACE hitsz302 on 12-5-18.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "UserDetailController.h"
#import "LeisureSportAppDelegate.h"
#import "LSUtil.h"
#import "FansCenterFetcher.h"
#import "FavorTeamController.h"
#import "FavorLeagueController.h"
#import "FollowerViewController.h"
#import "CommentViewController.h"
#import "FansViewController.h"
#import "MessageViewController.h"
#import "FourCrossCell.h"
#import "MessageDetailController.h"
#import "MBProgressHUD.h"
#import "UIButton+WebCache.h"

@implementation UserDetailController
@synthesize userID, myUserID;

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
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 368)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:GREEN_BG_IMAGE];
    //添加左导航键
    UIButton * backButton=[UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"返回按钮按下.png"] forState:UIControlStateHighlighted];
	[backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	backButton.frame=CGRectMake(3,3, 48, 30);
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = back;
    [back release];
    
    //获取数据
    userInfo = [FansCenterFetcher fetchUserInfo:userID myUserID:myUserID];
    
    
    //design the UI
    //头像    
    UIImageView *headImageView = PALEGREEN_BG_VIEW;
    headImageView.frame = CGRectMake(0, 0, 105, 110);
    UIButton *headIconButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 12, 80, 80)];
    [headIconButton setImageWithURL:IMAGE_URL(userInfo.ImageID) placeholderImage:IMAGEWITHCONTENTSOFFILE(@"默认头像")];
    [headImageView addSubview: headIconButton];
    [headIconButton release];
    [self.view addSubview:headImageView];
    [headImageView release];
    
    //昵称等
    UIImageView *signImageView = PALEGREEN_BG_VIEW;
    signImageView.frame = CGRectMake(105, 0, 215, 110);
    signImageView.userInteractionEnabled = YES;
    
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 100, 20)];
    userName.text = userInfo.NickName;
    userName.backgroundColor = [UIColor clearColor];
    UILabel *signPrompt = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 100, 20)];
    signPrompt.text = @"个性签名：";
    signPrompt.font = [UIFont systemFontOfSize:12];
    signPrompt.backgroundColor = [UIColor clearColor];
    UITextView *signTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 55, 105, 40)];
    signTextView.layer.cornerRadius = 6;
    signTextView.layer.masksToBounds = YES;
    signTextView.font = [UIFont systemFontOfSize:12];
    signTextView.text = userInfo.introduce;
    signTextView.editable = NO;
    
    UIButton *focusButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 15, 80, 30)];
    if (![LeisureSportAppDelegate userID] || [[LeisureSportAppDelegate userID] length] == 0) {
        focusButton.enabled = NO;
    }
    [focusButton setBackgroundImage:IMAGEWITHCONTENTSOFFILE(@"关注按钮") forState:UIControlStateNormal];
    [focusButton setBackgroundImage:IMAGEWITHCONTENTSOFFILE(@"关注按钮按下") forState:UIControlStateHighlighted];
    [focusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([userInfo.IsFocus isEqualToString: @"true"]) {
        [focusButton setTitle:@"取消关注" forState:UIControlStateNormal];
        [focusButton addTarget:self action:@selector(unfocusUser:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [focusButton setTitle:@"关注用户" forState:UIControlStateNormal];
        [focusButton addTarget:self action:@selector(focusUser:) forControlEvents:UIControlEventTouchUpInside];
    }
    focusButton.tag = 201;
    
    UIButton *msgButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 55, 80, 30)];
    if (![LeisureSportAppDelegate userID] || [[LeisureSportAppDelegate userID] length] == 0) {
        msgButton.enabled = NO;
    }
    msgButton.titleLabel.textColor = [UIColor blackColor];
    [msgButton setTitle:@"发送私信" forState:UIControlStateNormal];
    [msgButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [msgButton setBackgroundImage:IMAGEWITHCONTENTSOFFILE(@"关注按钮") forState:UIControlStateNormal];
    [msgButton setBackgroundImage:IMAGEWITHCONTENTSOFFILE(@"关注按钮按下") forState:UIControlStateHighlighted];
    [msgButton addTarget:self action:@selector(jumpToMsgView:) forControlEvents:UIControlEventTouchUpInside];
    
    [signImageView addSubview:userName];
    [signImageView addSubview:signPrompt];
    [signImageView addSubview:signTextView];
    [signImageView addSubview:focusButton];
    [signImageView addSubview:msgButton];
    
    [userName release];
    [signPrompt release];
    [signTextView release];
    [focusButton release];
    [msgButton release];
    
    
    [self.view addSubview:signImageView];
    [signImageView release];
    
    //group table view
	groupTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 110, 320, 260) style:UITableViewStyleGrouped];
    groupTableView.backgroundView = PALEGREEN_BG_VIEW;
    groupTableView.backgroundColor = [UIColor clearColor];
	groupTableView.delegate=self;
	groupTableView.dataSource=self;
	groupTableView.scrollEnabled=NO;
    groupTableView.sectionFooterHeight = 5;
    groupTableView.sectionHeaderHeight = 5;
    groupTableView.allowsSelection = YES;
    groupTableView.userInteractionEnabled = YES;
	[self.view addSubview:groupTableView];
	[groupTableView release];

}

//返回
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [userInfo release];
    [super dealloc];
}

//将英文星期转换为中午
- (NSString *)translateToChineseWeekday: (NSString *)english
{
    NSString *weekday = [[[NSString alloc] init] autorelease];
    if ([english isEqualToString:@"Mon"])   weekday = @"周一";
    if ([english isEqualToString:@"Tue"])   weekday = @"周二";
    if ([english isEqualToString:@"Wed"])   weekday = @"周三";
    if ([english isEqualToString:@"Thu"])   weekday = @"周四";
    if ([english isEqualToString:@"Fri"])   weekday = @"周五";
    if ([english isEqualToString:@"Sat"])   weekday = @"周六";
    if ([english isEqualToString:@"Sun"])   weekday = @"周日";
    return weekday;
}

//按钮点击事件
//关注
- (void)focusUser:(id)sender
{    if([FansCenterFetcher focusUser:[LeisureSportAppDelegate userID] TOUserID:userID Operation:1]){
        UIButton *focusButton = (UIButton *)[self.view.window viewWithTag:201];
        [focusButton setTitle:@"取消关注" forState:UIControlStateNormal];
        [focusButton addTarget:self action:@selector(unfocusUser:) forControlEvents:UIControlEventTouchUpInside];
        
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
//取消关注
- (void)unfocusUser:(id)sender
{
    if([FansCenterFetcher focusUser:[LeisureSportAppDelegate userID] TOUserID:userID Operation:0]){
        UIButton *focusButton = (UIButton *)[self.view.window viewWithTag:201];
        [focusButton setTitle:@"关注用户" forState:UIControlStateNormal];
        [focusButton addTarget:self action:@selector(focusUser:) forControlEvents:UIControlEventTouchUpInside];
        
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

//转到私信
- (void)jumpToMsgView:(id)sender
{
    MessageDetailController *msgDetailController = [[MessageDetailController alloc] init];
    msgDetailController.hidesBottomBarWhenPushed=YES;
    msgDetailController.fromUserID = myUserID;
    msgDetailController.toUserID = userID;
    [self.navigationController pushViewController:msgDetailController animated:YES];
    
    [msgDetailController release];
}

//跳转到关注页面
- (void)jumpToFollowerView:(id)sender
{
    FollowerViewController *followerViewController = [[FollowerViewController alloc] init];
    followerViewController.myUserID = userID;
    [self.navigationController pushViewController:followerViewController animated:YES];
    
    [followerViewController release];
}

//跳转到粉丝页面
- (void)jumpToFansView:(id)sender
{
    FansViewController *fansViewController = [[FansViewController alloc] init];
    fansViewController.myUserID = userID;
    [self.navigationController pushViewController:fansViewController animated:YES];
    
    [fansViewController release];
}

//跳转到说说页面
- (void)jumpToCommentView:(id)sender
{
    CommentViewController *commentViewController = [[CommentViewController alloc] init];
    commentViewController.myUserID = userID;
    [self.navigationController pushViewController:commentViewController animated:YES];
    
    [commentViewController release];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
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
	
	UITableViewCell *cell = [groupTableView dequeueReusableCellWithIdentifier:IngredientsCellIdentifier];
	
	if (cell == nil) 
	{
		// Create a cell to display an ingredient.
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IngredientsCellIdentifier] autorelease];
//		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
	// Configure the cell.
    if(indexPath.section == 0)
	{
        if(indexPath.row==0)
        {
            FourCrossCell *crosscell = (FourCrossCell *)[groupTableView dequeueReusableCellWithIdentifier:IngredientsCellIdentifier];
            crosscell = [[[NSBundle mainBundle] loadNibNamed:@"FourCrossCell" owner:self options:nil] lastObject];
            crosscell.selectionStyle = UITableViewCellSelectionStyleNone;
            [crosscell.leftupButton addTarget:self action:@selector(jumpToFollowerView:) forControlEvents:UIControlEventTouchUpInside];
            [crosscell.leftdownButton addTarget:self action:@selector(jumpToCommentView:) forControlEvents:UIControlEventTouchUpInside];
            [crosscell.rightupButton addTarget:self action:@selector(jumpToFansView:) forControlEvents:UIControlEventTouchUpInside];

            crosscell.followerNumLabel.text = userInfo.FollowCount;
            crosscell.fansNumLabel.text = userInfo.FollowerCount;
            crosscell.commentNumLabel.text = userInfo.CommentsCount;
            crosscell.messageNumLabel.text = @"";
            crosscell.messageLabel.text = @"";
            return crosscell;
        }
	}
	else if(indexPath.section==1)
	{
		if(indexPath.row==0)
		{
            NSArray *tmpTeams = [userInfo.UserFavorTeams componentsSeparatedByString:@";"];
            NSMutableString *favorTeams = [[NSMutableString alloc] init];
            for (int i=0; i<[tmpTeams count]-1; i++) {
                NSArray *tmp = [[tmpTeams objectAtIndex:i] componentsSeparatedByString:@","];
                [favorTeams appendString: [tmp objectAtIndex:1]];
                if (i != [tmpTeams count]-1) {
                    [favorTeams appendString:@","];
                }        
            }
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text= [NSString stringWithFormat:@"关注球队：%@", favorTeams];
            [favorTeams release];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.accessoryType = UITableViewCellAccessoryNone;
            UIImageView *bgView = [[UIImageView alloc] initWithImage:IMAGEWITHCONTENTSOFFILE(@"选择框")];
            cell.backgroundView = bgView;
            [bgView release];
            cell.backgroundColor = [UIColor clearColor];
		}
	}
	
    return cell;	
}

@end
