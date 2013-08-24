//
//  FansCenterController.h
//  DelightSports
//
//  Created by ACE hitsz302 on 12-5-18.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UserInfo.h"
#import "MBProgressHUD.h"

@interface FansCenterController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, MBProgressHUDDelegate>
{
    UITableView * groupTableView;
    UserInfo *userInfo;
    
    BOOL navBarHidden;
    BOOL needReload;
    //
    MBProgressHUD *HUD;
}

- (NSString *)translateToChineseWeekday: (NSString *)english;

@end
