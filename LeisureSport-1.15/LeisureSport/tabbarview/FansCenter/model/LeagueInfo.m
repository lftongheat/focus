//
//  LeagueInfo.m
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-5.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "LeagueInfo.h"

@implementation LeagueInfo
@synthesize Country, GameTypeID, GameTypeName, Introduce, LeaugeID, Name, todaygamenum;

-(void)dealloc
{
    [Country release];
    [GameTypeID release];
    [GameTypeName release];
    [Introduce release];
    [LeaugeID release];
    [Name release];
    [todaygamenum release];
    
    [super dealloc];
}
@end
