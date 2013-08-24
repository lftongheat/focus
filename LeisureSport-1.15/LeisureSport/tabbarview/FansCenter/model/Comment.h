//
//  Comment.h
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-9.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//  评论

#import <Foundation/Foundation.h>

@interface Comment : NSObject
{  
    NSString *AwayTeamName;
    NSString *CommentID;
    NSString *Contents;
    NSString *GameID;
    NSString *GameTime;
    NSString *GameTypeName;
    NSString *HomeTeamName;
    NSString *LeaugeName;
    NSString *NickName;
    NSString *UserID;
    NSString *UserImageID;
    NSString *time;
}

@property(nonatomic, retain) NSString *AwayTeamName;
@property(nonatomic, retain) NSString *CommentID;
@property(nonatomic, retain) NSString *Contents;
@property(nonatomic, retain) NSString *GameID;
@property(nonatomic, retain) NSString *GameTime;
@property(nonatomic, retain) NSString *GameTypeName;
@property(nonatomic, retain) NSString *HomeTeamName;
@property(nonatomic, retain) NSString *LeaugeName;
@property(nonatomic, retain) NSString *NickName;
@property(nonatomic, retain) NSString *UserID;
@property(nonatomic, retain) NSString *UserImageID;
@property(nonatomic, retain) NSString *time;

@end
