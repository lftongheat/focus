//
//  IWatchFetcher.h
//  LeisureSport
//
//  Created by 高 峰 on 12-6-11.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IWatchFetcher : NSObject
+ (NSMutableArray *)fetchIWatch:(NSString *) dateParameter dropdown:(NSString *) dropdownItem userID:(NSString *) userIDParameter iWatchDropDownArray:(NSMutableArray *)iWatchDropDownArrayParameter segmentNumber:(NSString*)segmentNumberParameter;//获取制定选项的比赛列表

+ (NSMutableArray *)fetchFocusedTeams:(NSString *) userID;//获取关注球队列表
+ (NSMutableArray *)fetchFocusedTeamGames:(NSString *) dateParameter dropdown:(NSString *) dropdownItem  userID:(NSString *) userIDParameter;//指定时间，获取关注球队的比赛列表
+ (NSMutableArray *)fetchDetailInfo:(NSString *) gameIDParameter userID:(NSString *) userIDParameter;//获取比赛星系信息

+ (NSString *)fetchBetGame:(NSString *)userIDParameter gameID:(NSString *) gameIDParameter betSide:(NSString *) betSideParameter points:(NSString *) pointsPatameter;//对比赛下注  0成功 -5之前已经下注 -6比赛已结束
+ (NSString *)fetchCommentID:(NSString *)userIDParameter gameID:(NSString *) gameIDParameter commentContent:(NSString *) commentContentPatameter;//发表评论，返回评论ID

+ (NSMutableArray *)fetchComment:(NSString *)time Count:(NSInteger) count gameID:(NSString *) gameIDParameter Index:(NSString *)index userID:(NSString *) userIDParameter;//获取比赛评论
@end
