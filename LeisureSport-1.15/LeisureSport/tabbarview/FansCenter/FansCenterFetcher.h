//
//  FansCenterFetcher.h
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-4.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface FansCenterFetcher : NSObject
//获取用户信息
+ (UserInfo *)fetchUserInfo: (NSString *)userID myUserID:(NSString *)myUserID;
//修改用户信息
+ (BOOL)updateUserInfo:(UserInfo *)userInfo;
//获取用户任务信息
+ (NSMutableArray *)fetchTaskInfoWithUserID: (NSString *)userID;

//获取关注信息
+ (NSMutableArray *)fetchFollowerWithUserID:(NSString *)userID Time:(NSString *)time Count: (NSInteger) count Index:(NSString *)index Online:(NSString *)flag;
//获取粉丝信息
+ (NSMutableArray *)fetchFansWithUserID:(NSString *)userID Time:(NSString *)time Count: (NSInteger) count Index:(NSString *)index Online:(NSString *)flag;
//获取说说信息
+ (NSMutableArray *)fetchCommentWithUserID:(NSString *)userID Time:(NSString *)time Count: (NSInteger) count Index:(NSString *)index;
//获取私信信息
+ (NSMutableArray *)fetchMessageWithUserID:(NSString *)userID Time:(NSString *)time Count: (NSInteger) count;
//获取联赛列表
+ (NSMutableArray *)fetchLeagues;

//获取关注球队列表
+ (NSMutableArray *)fetchFavorTeam: (NSString *)userID;

//提交任务
+ (BOOL)commitTask: (NSString *)taskID WithUserID:(NSString *)userID;
//关注用户
+ (BOOL)focusUser:(NSString *)srcUserID TOUserID:(NSString *)toUserID Operation:(NSInteger)opr;
//关注球队
+ (BOOL)focusTeam:(NSString *)teamID AndUserID:(NSString *)userID Operation:(NSInteger)opr;
//发送私信
+ (BOOL)sendMsgFrom:(NSString *)fromUserID TO:(NSString *)toUserID Content:(NSString *)content;

//获取两人间的私信
+ (NSMutableArray *)fetchMsgFrom:(NSString *)fromUserID TO:(NSString *)toUserID Time:(NSString *)time Count:(NSInteger)count Direction:(NSInteger)direction Index:(NSString *)index;

//搜索球队
+ (NSMutableArray *)searchTeamWithUserID:(NSString*) userID Key:(NSString *)key;

//关注联赛的操作 基于plist
+ (NSMutableArray *)getFavorLeagueByUserID:(NSString*)userID;
+ (void)updateFavorLeagueWithOperation:(NSInteger)opr LeaugeID:(NSString *)leagueID UserID: (NSString*)userID;
@end
