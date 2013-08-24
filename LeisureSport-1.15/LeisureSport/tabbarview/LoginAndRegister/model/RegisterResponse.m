//
//  RegisterResponse.m
//  LeisureSport
//
//  Created by 高 峰 on 12-6-24.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "RegisterResponse.h"

@implementation RegisterResponse
@synthesize UserID,userID,LoginID,sex,Email,NickName,points,ImageID,userType;
-(void)dealloc
{
    [UserID release];
    [userID release];
    [LoginID release];
    [sex release];
    [Email release];
    [NickName release];
    [points release];
    [ImageID release];
    [userType release];
    
    [super dealloc];
}
@end
