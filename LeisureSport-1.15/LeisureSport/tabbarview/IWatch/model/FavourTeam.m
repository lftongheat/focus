//
//  FavourTeam.m
//  LeisureSport
//
//  Created by 高 峰 on 12-6-11.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "FavourTeam.h"

@implementation FavourTeam
@synthesize  TeamID,LeagueID,Name,City,ShortName,ImageUrl,GameTypeID,LeagueName,GameTypeName,isfocus;
-(void)dealloc
{
    [TeamID release];
    [LeagueID release];
    [Name release];
    [City release];
    [ShortName release];
    [ImageUrl release];
    [GameTypeID release];
    [LeagueName release];
    [GameTypeName release];
    [isfocus release];
    
    [super dealloc];
}
@end
