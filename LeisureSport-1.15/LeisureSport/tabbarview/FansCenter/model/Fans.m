//
//  Fans.m
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-11.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "Fans.h"

@implementation Fans
@synthesize ImageID;
@synthesize LastLoginTime;
@synthesize NickName;
@synthesize PersonelInfo;
@synthesize UserFavorTeams;
@synthesize UserID;
@synthesize dt;
@synthesize isOnLine;
@synthesize sex;

-(void)dealloc
{
    [ImageID release];
    [LastLoginTime release];
    [NickName release];
    [PersonelInfo release];
    [UserFavorTeams release];
    [UserID release];
    [dt release];
    [isOnLine release];
    [sex release];
    
    [super dealloc];
}
@end
