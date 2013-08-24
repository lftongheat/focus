//
//  UserInfo.m
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-1.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo 

@synthesize BetPoints;
@synthesize CommentsCount;
@synthesize Email;
@synthesize FollowCount;
@synthesize FollowerCount;
@synthesize ImageID;
@synthesize IsFocus;
@synthesize LoginID;
@synthesize MessagesCount;
@synthesize NewFansNumber;
@synthesize NewMessageNumber;
@synthesize NickName;
@synthesize TotalAwardPoints;
@synthesize TotalBetPoints;
@synthesize UserFavorTeams;
@synthesize UserID;
@synthesize introduce;
@synthesize points;
@synthesize sex;

-(void)dealloc
{
    [BetPoints release];
    [CommentsCount release];
    [Email release];
    [FollowCount release];
    [FollowerCount release];
    [ImageID release];
    [IsFocus release];
    [LoginID release];
    [MessagesCount release];
    [NewFansNumber release];
    [NewMessageNumber release];
    [NickName release];
    [TotalAwardPoints release];
    [TotalBetPoints release];
    [UserFavorTeams release];
    [UserID release];  
    [introduce release];
    [points release];
    [sex release];
    
    [super dealloc];
}
@end
