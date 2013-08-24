//
//  UserInfo.h
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-1.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//  用户信息

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
{
    NSString *BetPoints;
    NSString *CommentsCount;
    NSString *Email;
    NSString *FollowCount;
    NSString *FollowerCount;
    NSString *ImageID;
    NSString *IsFocus;
    NSString *LoginID;
    NSString *MessagesCount;
    NSString *NewFansNumber;
    NSString *NewMessageNumber;
    NSString *NickName;
    NSString *TotalAwardPoints;
    NSString *TotalBetPoints;
    NSString *UserFavorTeams;
    NSString *UserID;
    NSString *introduce;
    NSString *points;
    NSString *sex;
}
@property(nonatomic,retain) NSString *BetPoints;
@property(nonatomic,retain) NSString *CommentsCount;
@property(nonatomic,retain) NSString *Email;
@property(nonatomic,retain) NSString *FollowCount;
@property(nonatomic,retain) NSString *FollowerCount;
@property(nonatomic,retain) NSString *ImageID;
@property(nonatomic,retain) NSString *IsFocus;
@property(nonatomic,retain) NSString *LoginID;
@property(nonatomic,retain) NSString *MessagesCount;
@property(nonatomic,retain) NSString *NewFansNumber;
@property(nonatomic,retain) NSString *NewMessageNumber;
@property(nonatomic,retain) NSString *NickName;
@property(nonatomic,retain) NSString *TotalAwardPoints;
@property(nonatomic,retain) NSString *TotalBetPoints;
@property(nonatomic,retain) NSString *UserFavorTeams;
@property(nonatomic,retain) NSString *UserID;
@property(nonatomic,retain) NSString *introduce;
@property(nonatomic,retain) NSString *points;
@property(nonatomic,retain) NSString *sex;


@end
