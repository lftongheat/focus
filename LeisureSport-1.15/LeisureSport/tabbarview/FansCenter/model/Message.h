//
//  Message.h
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-11.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//  私信

#import <Foundation/Foundation.h>

@interface Message : NSObject
{
    NSString *FromUserID;
    NSString *FromUserImageID;
    NSString *FromUserIsOnline;
    NSString *FromUserNickName;
    NSString *FromUserSex;
    NSString *MainContent;
    NSString *MessageDT;
    NSString *MessageID;
    NSString *RowNumber;
    NSString *ToUserID;
    NSString *ToUserImageID;
    NSString *ToUserIsOnline;
    NSString *ToUserNickName;
    NSString *ToUserSex;
    NSString *UnReadNum;
    NSString *UserID;
    NSString *readFlag;
}

@property(nonatomic, retain) NSString *FromUserID;
@property(nonatomic, retain) NSString *FromUserImageID;
@property(nonatomic, retain) NSString *FromUserIsOnline;
@property(nonatomic, retain) NSString *FromUserNickName;
@property(nonatomic, retain) NSString *FromUserSex;
@property(nonatomic, retain) NSString *MainContent;
@property(nonatomic, retain) NSString *MessageDT;
@property(nonatomic, retain) NSString *MessageID;
@property(nonatomic, retain) NSString *RowNumber;
@property(nonatomic, retain) NSString *ToUserID;
@property(nonatomic, retain) NSString *ToUserImageID;
@property(nonatomic, retain) NSString *ToUserIsOnline;
@property(nonatomic, retain) NSString *ToUserNickName;
@property(nonatomic, retain) NSString *ToUserSex;
@property(nonatomic, retain) NSString *UnReadNum;
@property(nonatomic, retain) NSString *UserID;
@property(nonatomic, retain) NSString *readFlag;
@end
