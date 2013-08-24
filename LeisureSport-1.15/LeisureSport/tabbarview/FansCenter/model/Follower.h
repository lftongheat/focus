//
//  Follower.h
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-11.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//  关注

#import <Foundation/Foundation.h>

@interface Follower : NSObject
{
    NSString *ImageID;
    NSString *LastLoginTime;
    NSString *NickName;
    NSString *PersonelInfo;
    NSString *UserID;
    NSString *dt;
    NSString *isOnLine;
    NSString *sex;
}
@property(nonatomic, retain) NSString *ImageID;
@property(nonatomic, retain) NSString *LastLoginTime;
@property(nonatomic, retain) NSString *NickName;
@property(nonatomic, retain) NSString *PersonelInfo;
@property(nonatomic, retain) NSString *UserID;
@property(nonatomic, retain) NSString *dt;
@property(nonatomic, retain) NSString *isOnLine;
@property(nonatomic, retain) NSString *sex;
@end
