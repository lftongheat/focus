//
//  RegisterResponse.h
//  LeisureSport
//
//  Created by 高 峰 on 12-6-24.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterResponse : NSObject
{
    NSString *UserID;
    NSString *userID;
    NSString *LoginID;
    NSString *sex;
    NSString *Email;
    NSString *NickName;
    NSString *points;
    NSString *ImageID;
    NSString *userType;
    
}
@property(nonatomic, retain) NSString *UserID;
@property(nonatomic, retain) NSString *userID;
@property(nonatomic, retain) NSString *LoginID;
@property(nonatomic, retain) NSString *sex;
@property(nonatomic, retain) NSString *Email;
@property(nonatomic, retain) NSString *NickName;
@property(nonatomic, retain) NSString *points;
@property(nonatomic, retain) NSString *ImageID;
@property(nonatomic, retain) NSString *userType;
@end
