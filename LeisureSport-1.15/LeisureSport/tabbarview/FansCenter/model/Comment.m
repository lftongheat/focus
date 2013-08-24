//
//  Comment.m
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-9.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "Comment.h"

@implementation Comment
@synthesize AwayTeamName, CommentID, Contents, GameID, GameTime, GameTypeName, HomeTeamName, LeaugeName,NickName, UserID, UserImageID, time;

-(void)dealloc
{
    [AwayTeamName release];
    [CommentID release];
    [Contents release];
    [GameID release];
    [GameTime release];
    [GameTypeName release];
    [HomeTeamName release];
    [LeaugeName release];
    [NickName release];
    [UserID release];
    [UserImageID release];
    [time release];
    
    [super dealloc];
}
@end
