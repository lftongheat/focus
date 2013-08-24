//
//  UserDetailController.h
//  DelightSports
//
//  Created by ACE hitsz302 on 12-5-18.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UserInfo.h"

@interface UserDetailController : UITableViewController <UINavigationControllerDelegate>
{
    UITableView * groupTableView;
    UserInfo *userInfo;
    
    NSString *userID;
    NSString *myUserID;
}

@property(nonatomic, retain) NSString *userID;
@property(nonatomic, retain) NSString *myUserID;

- (NSString *)translateToChineseWeekday: (NSString *)english;

@end
