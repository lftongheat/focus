//
//  TVLiveViewController.h
//  DelightSports
//
//  Created by ACE hitsz302 on 12-5-18.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

@interface TVLiveController : UITableViewController <UITableViewDelegate, UITableViewDataSource,MBProgressHUDDelegate>{
	
    UITableView *tvLiveTableView;//电视直播列表
	
    UIActivityIndicatorView *activityIndicator;//加载数据效果
    
    NSMutableArray *tvLiveArray;//电视直播列表数据
    MBProgressHUD *HUD;
//    UIAlertView *myAlert;//加载时提示
//    UILabel *remindNoData;//无数据时提示
}


@end
