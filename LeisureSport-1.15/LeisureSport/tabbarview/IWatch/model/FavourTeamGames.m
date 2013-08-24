//
//  FavourTeamGames.m
//  LeisureSport
//
//  Created by 高 峰 on 12-6-13.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "FavourTeamGames.h"

@implementation FavourTeamGames
@synthesize GameID,HomeTeamID,AwayTeamID,GameTime,HomeTeamScore,AwayTeamScore,LeaugeID,IsFinished,Report,Result,WinTeamID,LoseTeamID,IsHot,TVLiveAll,NewsID,FavorTeamID,FavorName,HomeName,AwayName,Name,GameTypeID,GameTypeName,IsWin;
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
    [WinTeamID release];
    [LoseTeamID release];
    
    [IsHot release];
    
    [TVLiveAll release];
    [NewsID release];
    [FavorTeamID release];
    [FavorName release];
    
    
    
    
    [HomeName release];
    [AwayName release];
    [Name release];
    [GameTypeID release];
    [GameTypeName release];
    
    [IsWin release];
    
    [super dealloc];
}
@end
