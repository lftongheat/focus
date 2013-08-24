//
//  LoginAndRegisterFetcher.h
//  LeisureSport
//
//  Created by 高 峰 on 12-6-19.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginAndRegisterFetcher : NSObject
+ (NSMutableArray *)fetchRegister:(NSString *) loginIDParameter pwd:(NSString *) pwdParameter email:(NSString *) emailParameter nickname:(NSString *)nicknameParameter IMEI:(NSString *) IMEIParameter clientVersion:(NSString *) clientVersionParameter userType:(NSString *) userTypeParameter;//用户注册,成功注册,返回USER_ID，使用方法:User_Register('qt@g.com','123','qt@g.com','景驰','000000','V1.0',0);新浪微博用户userType为0，,Android用户userType为1，IOS用户userType为2
+ (NSMutableArray *)fetchLogin:(NSString *) loginIDParameter pwd:(NSString *) pwdParameter clientVersion:(NSString *) clientVersionParameter userType:(NSString *) userTypeParameter;//用户登录接口，使用方法:User_Login(1,'123','V1.0',0);新浪微博用户userType为0，,Android用户userType为1，IOS用户userType为2，loginID为登陆ID，pwd密码，clientVersion客户端版本号返回值：正常返回userID >0;返回<0@end
+ (NSString *)fetchVersion;//获取当前最新版本号
+ (NSString *)fetchFeedback:(NSString *) mainContent email:(NSString *) emailParameter IMEI:(NSString *) IMEIParameter userID:(NSString *) userIDParameter;//用户反馈

+ (NSString *)fetchFindPassword:(NSString *) loginID;//找回密码
@end