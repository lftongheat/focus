//
//  UserTaskController.m
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-4.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "UserTaskController.h"
#import "UserTaskInfo.h"
#import "LSUtil.h"
#import "FansCenterFetcher.h"
#import "UIImageView+WebCache.h"
#import "LeisureSportAppDelegate.h"
#import "MBProgressHUD.h"

@implementation UserTaskController

- (void)dealloc
{
    if (userTaskInfoArray) {
        [userTaskInfoArray release];
        userTaskInfoArray = nil;
    }
    [taskType release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
//-(void)viewDidAppear:(BOOL)animated
//{
//    if ([LSUtil connectedToNetwork]) {
//        if (userTaskInfoArray) {
//            [userTaskInfoArray release];
//            userTaskInfoArray = nil;
//        }
//        userTaskInfoArray = [[FansCenterFetcher fetchTaskInfoWithUserID:[LeisureSportAppDelegate userID]] mutableCopy];
//        
//        //数据处理
//        NSMutableDictionary *typeDic = [[NSMutableDictionary alloc] init];
//        for (int i=0; i<[userTaskInfoArray count]; i++) {
//            UserTaskInfo *taskInfo = [userTaskInfoArray objectAtIndex:i];
//            [typeDic setValue:taskInfo.TaskTypeName forKey:taskInfo.TaskTypeID];
//        }
//        taskType = [[NSMutableArray alloc] init];
//        for (NSString *key in typeDic) {
//            [taskType addObject:[typeDic objectForKey:key]];
//        }
//        [typeDic release];
//        
//        UITableView *table = (UITableView*)[self.view viewWithTag:201];
//        [table reloadData];
//    }
//}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460-44-48)];
    self.title = @"任务";
    
    //添加左导航键
    UIButton * backButton=[UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"返回按钮按下.png"] forState:UIControlStateHighlighted];
	[backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	backButton.frame=CGRectMake(3,3, 48, 30);
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = back;
    [back release];
    
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    userTaskInfoArray = [[FansCenterFetcher fetchTaskInfoWithUserID:[LeisureSportAppDelegate userID]] mutableCopy];
//    [pool release];
    //数据处理
    NSMutableDictionary *typeDic = [[NSMutableDictionary alloc] init];
    for (int i=0; i<[userTaskInfoArray count]; i++) {
        UserTaskInfo *taskInfo = [userTaskInfoArray objectAtIndex:i];
        [typeDic setValue:taskInfo.TaskTypeName forKey:taskInfo.TaskTypeID];
    }
    taskType = [[NSMutableArray alloc] init];
    for (NSString *key in typeDic) {
        [taskType addObject:[typeDic objectForKey:key]];
    }
    [typeDic release];
    
    taskTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 368) style:UITableViewStylePlain];
    taskTableView.backgroundView = [[UIImageView alloc] initWithImage:GREEN_BG_IMAGE];
	taskTableView.delegate=self;
	taskTableView.dataSource=self;
	taskTableView.scrollEnabled=YES;
    taskTableView.allowsSelection = NO;
    taskTableView.userInteractionEnabled = YES;
    taskTableView.rowHeight = 120; 
    [taskTableView setSeparatorColor:[UIColor clearColor]];
    taskTableView.tag = 201;
	[self.view addSubview:taskTableView];
	[taskTableView release];
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


#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [taskType count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    for (int i=0; i<[taskType count]; i++) {
        if (i == section) {
            int k=0;
            NSString *taskName = [taskType objectAtIndex:i];
            for (int j=0; j<[userTaskInfoArray count]; j++) {
                UserTaskInfo *userTaskInfo = [userTaskInfoArray objectAtIndex:j];
                if ([userTaskInfo.TaskTypeName isEqualToString:taskName]) {
                    k++;
                }
            }
            return k;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTaskInfo *taskInfo = [userTaskInfoArray objectAtIndex:indexPath.section + indexPath.row];  
    
    static NSString *cellID = @"ICell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
	} else {
        //由于重用单元格 需要删除原来单元格的内容
        for (UIView *view in [cell subviews]){
            [view removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    
	cell.backgroundView = PALEGREEN_BG_VIEW_AUTORELEASE;

    //头像       
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    //使用SDWebImage的图片缓存机制
    [imgView setImageWithURL:IMAGE_URL(taskInfo.ImageID) placeholderImage:[UIImage imageNamed:@""]];
    [cell addSubview:imgView];
    [imgView release];
    
    //名称
    UILabel *nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.frame = CGRectMake(115, 10, 110, 20);
    nickNameLabel.text = taskInfo.Title;
    nickNameLabel.font = [UIFont systemFontOfSize:17.0f];
    nickNameLabel.backgroundColor = [UIColor clearColor];
    nickNameLabel.textColor = [UIColor orangeColor];
    [cell addSubview: nickNameLabel];
    [nickNameLabel release];
    
    //简介
    UILabel *introduceLabel = [[UILabel alloc] init];
    introduceLabel.frame = CGRectMake(115, 40, 110, 20);
    introduceLabel.text = taskInfo.Introduce;
    introduceLabel.font = [UIFont systemFontOfSize:13.0f];
    introduceLabel.backgroundColor = [UIColor clearColor];
    [cell addSubview: introduceLabel];
    [introduceLabel release];
    
    //奖励
    UILabel *rewardLabel = [[UILabel alloc] init];
    rewardLabel.frame = CGRectMake(115, 70, 110, 20);
    NSString *reward = [NSString stringWithFormat:@"奖励：+%@分", taskInfo.RewardPoints];
    rewardLabel.text = reward;
    rewardLabel.font = [UIFont systemFontOfSize:16.0f];
    rewardLabel.backgroundColor = [UIColor clearColor];
    rewardLabel.textColor = [UIColor redColor];
    [cell addSubview: rewardLabel];
    [rewardLabel release];
    
    //按钮
    UIButton *taskButton = [UIButton buttonWithType:UIButtonTypeCustom];
    taskButton.frame = CGRectMake(230, 60, 80, 40);
    taskButton.tag = 100 + indexPath.section + indexPath.row;
    [taskButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    if ([taskInfo.IsFinished intValue] < 0) {
        [taskButton setImage:[UIImage imageNamed:@"已经完成.png"] forState:UIControlStateNormal];
        taskButton.enabled = NO;
    } else {
        [taskButton setImage:[UIImage imageNamed:@"我要领奖.png"] forState:UIControlStateNormal];   
    }
    [cell addSubview:taskButton];

	return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    for (int i=0; i<[taskType count]; i++) {
        if (i == section) {
            return [taskType objectAtIndex:i];
        }
    }
    return nil;
}

- (void)buttonPressed: (id)sender
{
    for (int i=0; i<[userTaskInfoArray count]; i++) {
        if ([sender tag] == i+100) {
            UserTaskInfo *task = [userTaskInfoArray objectAtIndex:i];
            UIButton *button = (UIButton*)[self.view viewWithTag:[sender tag]];
            //提交任务
            if([FansCenterFetcher commitTask:task.TaskID WithUserID:[LeisureSportAppDelegate userID]]){
                [button setImage:[UIImage imageNamed:@"已经完成.png"] forState:UIControlStateNormal];
                button.enabled = NO;
                if (userTaskInfoArray) {
                    [userTaskInfoArray release];
                    userTaskInfoArray = nil;
                }
                userTaskInfoArray = [[FansCenterFetcher fetchTaskInfoWithUserID:[LeisureSportAppDelegate userID]] mutableCopy];
                
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

}

@end
