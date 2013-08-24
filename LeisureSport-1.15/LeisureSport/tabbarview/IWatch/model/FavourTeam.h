//
//  FavourTeam.h
//  LeisureSport
//
//  Created by 高 峰 on 12-6-11.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavourTeam : NSObject
{
    NSString *TeamID;
    
    NSString *LeagueID;
    NSString *Name;
    NSString *City;
    NSString *ShortName;
    NSString *ImageUrl;
    NSString *GameTypeID;
    NSString *LeagueName;
    
    NSString *GameTypeName;
    NSString *isfocus;
}
@property(nonatomic, retain) NSString *TeamID;

@property(nonatomic, retain) NSString *LeagueID;
@property(nonatomic, retain) NSString *Name;
@property(nonatomic, retain) NSString *City;
@property(nonatomic, retain) NSString *ShortName;
@property(nonatomic, retain) NSString *ImageUrl;
@property(nonatomic, retain) NSString *GameTypeID;
@property(nonatomic, retain) NSString *LeagueName;

@property(nonatomic, retain) NSString *GameTypeName;
@property(nonatomic, retain) NSString *isfocus;

@end
