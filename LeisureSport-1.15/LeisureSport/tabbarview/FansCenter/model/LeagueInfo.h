//
//  LeagueInfo.h
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-5.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//  联赛信息

#import <Foundation/Foundation.h>

@interface LeagueInfo : NSObject
{
    NSString *Country;
    NSString *GameTypeID;
    NSString *GameTypeName;
    NSString *Introduce;
    NSString *LeaugeID;
    NSString *Name;
    NSString *todaygamenum;
}

@property(nonatomic, retain) NSString *Country;
@property(nonatomic, retain) NSString *GameTypeID;
@property(nonatomic, retain) NSString *GameTypeName;
@property(nonatomic, retain) NSString *Introduce;
@property(nonatomic, retain) NSString *LeaugeID;
@property(nonatomic, retain) NSString *Name;
@property(nonatomic, retain) NSString *todaygamenum;

@end
