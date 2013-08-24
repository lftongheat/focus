//
//  GameLive.m
//  LeisureSport
//
//  Created by 高 峰 on 12-6-9.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "GameLive.h"

@implementation GameLive
@synthesize GameID,HomeTeamID,AwayTeamID,GameTime,HomeTeamScore,AwayTeamScore,LeaugeID,IsFinished,Report,Result,RoundNum,IsHot,TVLiveAll,NewsID,HomeName,AwayName,Name,GameTypeID,GameTypeName,HomeTeamImageUrl,AwayTeamImageUrl;
-(void)dealloc
{
    [GameID release];
    
    [HomeTeamID release];
    [AwayTeamID release];
    [GameTime release];
    [HomeTeamScore release];
    [AwayTeamScore release];
    [LeaugeID release];
    [IsFinished release];
    
    [Report release];
    [Result release];
    [RoundNum release];
    [IsHot release];
    
    [TVLiveAll release];
    [NewsID release];
    [HomeName release];
    [AwayName release];
    [Name release];
    [GameTypeID release];
    [GameTypeName release];
    
    [HomeTeamImageUrl release];
    [AwayTeamImageUrl release];
    
    [super dealloc];
}
@end
