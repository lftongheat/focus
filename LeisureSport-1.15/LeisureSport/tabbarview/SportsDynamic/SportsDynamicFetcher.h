//
//  SportsDynamicFetcher.h
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-8.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SportsDynamicFetcher : NSObject

//获取近期体坛新闻
+ (NSMutableArray *)fetchNewsWithTime:(NSString *)time Count: (NSInteger)count;

+ (NSMutableArray *)fetchNewsWithTime:(NSString *)time Count: (NSInteger)count Index:(NSString *)index;

@end
