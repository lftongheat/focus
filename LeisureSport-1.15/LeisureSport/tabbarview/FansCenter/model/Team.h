//
//  Team.h
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-17.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//  球队

#import <Foundation/Foundation.h>

@interface Team : NSObject
{
    NSString *City;
    NSString *GameTypeID;
    NSString *GameTypeName;
    NSString *ImageUrl;
    NSString *Introduce;
    NSString *LeaugeID;
    NSString *LeaugeName;
    NSString *Name;
    NSString *ShortName;
    NSString *TeamID;
    NSString *isfocus;
}
@property(nonatomic, retain) NSString *City;
@property(nonatomic, retain) NSString *GameTypeID;
@property(nonatomic, retain) NSString *GameTypeName;
@property(nonatomic, retain) NSString *ImageUrl;
@property(nonatomic, retain) NSString *Introduce;
@property(nonatomic, retain) NSString *LeaugeID;
@property(nonatomic, retain) NSString *LeaugeName;
@property(nonatomic, retain) NSString *Name;
@property(nonatomic, retain) NSString *ShortName;
@property(nonatomic, retain) NSString *TeamID;
@property(nonatomic, retain) NSString *isfocus;

@end
