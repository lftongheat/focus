//
//  Team.m
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-17.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "Team.h"

@implementation Team
@synthesize City;
@synthesize GameTypeID;
@synthesize GameTypeName;
@synthesize ImageUrl;
@synthesize Introduce;
@synthesize LeaugeID;
@synthesize LeaugeName;
@synthesize Name;
@synthesize ShortName;
@synthesize TeamID;
@synthesize isfocus;

-(void)dealloc
{
    [City release];
    [GameTypeID release];
    [GameTypeName release];
    [ImageUrl release];
    [Introduce release];
    [LeaugeID release];
    [LeaugeName release];
    [Name release];
    [ShortName release];
    [TeamID release];
    [isfocus release];
    
    [super dealloc];
}
@end
