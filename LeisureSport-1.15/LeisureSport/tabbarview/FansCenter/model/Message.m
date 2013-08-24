//
//  Message.m
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-11.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "Message.h"

@implementation Message;
@synthesize FromUserID;
@synthesize FromUserImageID;
@synthesize FromUserIsOnline;
@synthesize FromUserNickName;
@synthesize FromUserSex;
@synthesize MainContent;
@synthesize MessageDT;
@synthesize MessageID;
@synthesize RowNumber;
@synthesize ToUserID;
@synthesize ToUserImageID;
@synthesize ToUserIsOnline;
@synthesize ToUserNickName;
@synthesize ToUserSex;
@synthesize UnReadNum;
@synthesize UserID;
@synthesize readFlag;

-(void)dealloc
{
    [FromUserID release];
//    FromUserID = nil;
    [FromUserImageID release];
    [FromUserIsOnline release];
    [FromUserNickName release];
    [FromUserSex release];
    [MainContent release];
    [MessageDT release];
    [MessageID release];
    [RowNumber release];
    [ToUserID release];
//    ToUserID = nil;
    [ToUserImageID release];
    [ToUserIsOnline release];
    [ToUserNickName release];
    [ToUserSex release];
    [UnReadNum release];
//    UnReadNum = nil;
    [UserID release];
    [readFlag release];
    
    [super dealloc];
}
@end
