//
//  GameComments.h
//  LeisureSport
//
//  Created by 高 峰 on 12-6-14.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameComments : NSObject
{
    NSString *CommentID;
    NSString *UserID;
    NSString *GameID;
    NSString *Contents;
    
    NSString *time;
    NSString *NickName;
    NSString *UserImageID;
    NSString *GameTime;
    NSString *HomeTeamName;
    NSString *AwayTeamName;
    NSString *LeaugeName;
    NSString *GameTypeName;
}
@property(nonatomic, retain) NSString *CommentID;
@property(nonatomic, retain) NSString *UserID;
@property(nonatomic, retain) NSString *GameID;
@property(nonatomic, retain) NSString *Contents;

@property(nonatomic, retain) NSString *time;
@property(nonatomic, retain) NSString *NickName;
@property(nonatomic, retain) NSString *UserImageID;
@property(nonatomic, retain) NSString *GameTime;
@property(nonatomic, retain) NSString *HomeTeamName;
@property(nonatomic, retain) NSString *AwayTeamName;
@property(nonatomic, retain) NSString *LeaugeName;
@property(nonatomic, retain) NSString *GameTypeName;
@end
