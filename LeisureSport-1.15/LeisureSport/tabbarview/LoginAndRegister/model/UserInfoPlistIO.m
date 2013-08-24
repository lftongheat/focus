//
//  UserInfoPlistIO.m
//  LoginAndRegister
//
//  Created by 高 峰 on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserInfoPlistIO.h"

#define ALERT(X) {UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:X delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];[alert show];[alert release];}


@implementation UserInfoPlistIO

@synthesize isLogined;
- (id) readPlist:(NSString *)fileName
{
    NSArray *paths;
    NSString *docPath;
    NSString *newPath;
    paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	docPath = [paths objectAtIndex:0];
	newPath = [docPath stringByAppendingPathComponent:@"Preferences/logininfo.plist"];
    
    
    NSMutableArray *infoArray=[NSMutableArray arrayWithContentsOfFile:newPath];
    return infoArray;

}

- (NSString *) readUserID:(NSString *)fileName
{
    NSMutableArray *user = [self readPlist:@""];
    //NSLog(@"readUserID_user:%@",user);
    NSString *userID;
    
    if([self isLogin])
    {
        userID = (NSString *)[[user objectAtIndex:([user count]-2)] objectAtIndex:0];
    }else
    {
        userID =@"";
    }
    
//    if([user count]==0||[user count]==1)
//    {
//        userID =@"";
//    }else
//    {
//        userID = (NSString *)[[user objectAtIndex:([user count]-2)] objectAtIndex:0];
//    }
    return userID;
}

- (NSString *) readUserPassword:(NSString *)fileName
{
    NSMutableArray *user = [self readPlist:@""];
    NSString *passWord;
    
    if([self isLogin])
    {
         passWord = (NSString *)[[user objectAtIndex:([user count]-2)]  objectAtIndex:1];
    }else
    {
        passWord = @"";
    }
    
//    if([user count]==0||[user count]==1)
//    {
//        passWord = @"";
//        
//    }else{
//        passWord = (NSString *)[[user objectAtIndex:([user count]-2)]  objectAtIndex:1];
//    }
    return passWord;
}

-(void) writeToPlistFromArray:(NSMutableArray *)array
{
    NSArray *paths;
    NSString *docPath;
    NSString *newPath;
    paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	docPath = [paths objectAtIndex:0];
	newPath = [docPath stringByAppendingPathComponent:@"Preferences/logininfo.plist"];
    [array writeToFile:newPath atomically:YES];
}

//-(void) clearPlist
//{
//    NSArray *paths;
//    NSString *docPath;
//    NSString *newPath;
//    paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//	docPath = [paths objectAtIndex:0];
//	newPath = [docPath stringByAppendingPathComponent:@"Preferences/UserHistory11.plist"];
//    NSMutableArray *userInfoArray=nil;
//    userInfoArray = [NSMutableArray arrayWithContentsOfFile:newPath];
//    
//    if(userInfoArray==nil)
//    {
//        userInfoArray = [[[NSMutableArray alloc] init] autorelease];
//    }
//    
//    //NSArray *singUserInfo = [[NSArray alloc] initWithObjects:userId,password, nil];
//    
//    //    [userInfoArray removeObjectAtIndex:0];
//    //    [userInfoArray removeObjectAtIndex:1];
//    [userInfoArray removeAllObjects];
//    
//    [userInfoArray addObject:@""];
//    [userInfoArray addObject:@""];
//   // userInfoArray = nil;
//    
//    //[userInfoArray removeObjectAtIndex:0];
//    //[userInfoArray addObject:singUserInfo];
//    [userInfoArray writeToFile:newPath atomically:YES];
//    //[singUserInfo release];
//    
//}
-(void) setLoginedOrNot:(bool) islogined
{
    NSArray *paths;
    NSString *docPath;
    NSString *newPath;
    paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	docPath = [paths objectAtIndex:0];
	newPath = [docPath stringByAppendingPathComponent:@"Preferences/islogined.plist"];
    NSMutableArray *userInfoArray=nil;
    userInfoArray = [NSMutableArray arrayWithContentsOfFile:newPath];
    
    if(userInfoArray==nil)
    {
        userInfoArray = [[[NSMutableArray alloc] init] autorelease];
    }
    
    //NSArray *singUserInfo = [[NSArray alloc] initWithObjects:userId,password, nil];
    
    //    [userInfoArray removeObjectAtIndex:0];
    //    [userInfoArray removeObjectAtIndex:1];
    [userInfoArray removeAllObjects];
    
    if(islogined)
    {
        [userInfoArray addObject:@"1"];
    }else
    {
        [userInfoArray addObject:@""];
    }
    

    [userInfoArray writeToFile:newPath atomically:YES];
}


- (BOOL) isLogin
{
    
    NSArray *paths;
    NSString *docPath;
    NSString *newPath;
    paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	docPath = [paths objectAtIndex:0];
	newPath = [docPath stringByAppendingPathComponent:@"Preferences/islogined.plist"];
    NSMutableArray *userInfoArray=nil;
    userInfoArray = [NSMutableArray arrayWithContentsOfFile:newPath];

    
    NSString *logined = (NSString *)[userInfoArray objectAtIndex:0];
    if(logined.length==0)
    {
        return false;
    }else
    {
        return true;
    }
}
@end
