//
//  DetailInfo.m
//  LeisureSport
//
//  Created by 高 峰 on 12-6-13.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "DetailInfo.h"

@implementation DetailInfo
@synthesize GameID,HomeTeamID,AwayTeamID,GameTime,HomeTeamScore,AwayTeamScore,LeaugeID,IsFinished,Report,Result,WinTeamID,LoseTeamID,IsHot,TVLiveAll,NewsID,LiveRoomID,HomeName,AwayName,Name,GameTypeID,GameTypeName,HomeUserBetsCount,HomeUserBetsPointCount,AwayUserBetsCount,AwayUserBetsPointCount,CommentsCount,HomeRecentGameBox,AwayRecentGameBox,HomeBetweenRecentGameBox,AwayBetweenRecentGameBox,HomeSeasonGameBox,AwaySeasonGameBox,IsWin;
-(void) dealloc
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
    [WinTeamID release];
    [LoseTeamID release];
    [IsHot release];
    [TVLiveAll release];
    [NewsID release];
    
    [LiveRoomID release];
    [HomeName release];
    [AwayName release];
    [Name release];
    [GameTypeID release];
    [GameTypeName release];
    [HomeUserBetsCount release];
    [HomeUserBetsPointCount release];
    [AwayUserBetsCount release];
    [AwayUserBetsPointCount release];
    [CommentsCount release];
    [HomeRecentGameBox release];
    [AwayRecentGameBox release];
    [HomeBetweenRecentGameBox release];
    [AwayBetweenRecentGameBox release];
    [HomeSeasonGameBox release];
    [AwaySeasonGameBox release];
    [IsWin release];
    
    [super dealloc];
}
@end
