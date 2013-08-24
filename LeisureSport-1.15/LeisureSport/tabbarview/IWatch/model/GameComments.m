//
//  GameComments.m
//  LeisureSport
//
//  Created by 高 峰 on 12-6-14.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "GameComments.h"

@implementation GameComments
@synthesize CommentID,UserID,GameID,Contents,time,NickName,UserImageID,GameTime,HomeTeamName,AwayTeamName,LeaugeName,GameTypeName;
-(void)dealloc
{
    [CommentID release];
    [UserID release];
    [GameID release];
    [Contents release];
    [time release];
    [NickName release];
    [UserImageID release];
    [GameTime release];
    [HomeTeamName release];
    [AwayTeamName release];
    [LeaugeName release];
    [GameTypeName release];
    
    [super dealloc];
}
@end
