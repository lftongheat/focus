//
//  FavourTeamGames.h
//  LeisureSport
//
//  Created by 高 峰 on 12-6-13.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavourTeamGames : NSObject
{
    NSString *GameID;
    
    NSString *HomeTeamID;
    NSString *AwayTeamID;
    NSString *GameTime;
    NSString *HomeTeamScore;
    NSString *AwayTeamScore;
    NSString *LeaugeID;
    NSString *IsFinished;
    
    NSString *Report;
    NSString *Result;
    NSString *WinTeamID;
    NSString *LoseTeamID;

    NSString *IsHot;
    
    NSString *TVLiveAll;
    NSString *NewsID;
    NSString *FavorTeamID;
    NSString *FavorName;
    
    
    
    
    NSString *HomeName;
    NSString *AwayName;
    NSString *Name;
    NSString *GameTypeID;
    NSString *GameTypeName;
    
    NSString *IsWin;
}
@property(nonatomic, retain) NSString *GameID;

@property(nonatomic, retain) NSString *HomeTeamID;
@property(nonatomic, retain) NSString *AwayTeamID;
@property(nonatomic, retain) NSString *GameTime;
@property(nonatomic, retain) NSString *HomeTeamScore;
@property(nonatomic, retain) NSString *AwayTeamScore;
@property(nonatomic, retain) NSString *LeaugeID;
@property(nonatomic, retain) NSString *IsFinished;

@property(nonatomic, retain) NSString *Report;
@property(nonatomic, retain) NSString *Result;
@property(nonatomic, retain) NSString *WinTeamID;
@property(nonatomic, retain) NSString *LoseTeamID;
@property(nonatomic, retain) NSString *IsHot;

@property(nonatomic, retain) NSString *TVLiveAll;
@property(nonatomic, retain) NSString *NewsID;
@property(nonatomic, retain) NSString *FavorTeamID;
@property(nonatomic, retain) NSString *FavorName;

@property(nonatomic, retain) NSString *HomeName;
@property(nonatomic, retain) NSString *AwayName;
@property(nonatomic, retain) NSString *Name;
@property(nonatomic, retain) NSString *GameTypeID;
@property(nonatomic, retain) NSString *GameTypeName;

@property(nonatomic, retain) NSString *IsWin;
@end
