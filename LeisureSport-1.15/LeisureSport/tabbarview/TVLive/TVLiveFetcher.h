//
//  TVLiveFetcher.h
//  LeisureSport
//
//  Created by 高 峰 on 12-6-9.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TVLiveFetcher : NSObject


+ (NSMutableArray *)fetchLive;//获取近期有的电视直播的比赛列表
+ (NSMutableArray *)fetchLive: (NSInteger) count;

@end
