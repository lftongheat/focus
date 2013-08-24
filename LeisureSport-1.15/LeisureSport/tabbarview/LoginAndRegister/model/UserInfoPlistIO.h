//
//  UserInfoPlistIO.h
//  LoginAndRegister
//
//  Created by 高 峰 on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoPlistIO : NSObject
{
    BOOL isLogined;
}

@property(nonatomic) BOOL isLogined;

-(void) writeToPlistFromArray:(NSMutableArray *)array;

- (id)readPlist:(NSString *)fileName;
//- (void) writeToPlist:(NSString *) userId password:(NSString *)password;
- (NSString *) readUserID:(NSString *)fileName;
- (NSString *) readUserPassword:(NSString *)fileName;
-(void) setLoginedOrNot:(bool) islogined;
- (BOOL) isLogin;
//-(void) clearPlist;
@end
