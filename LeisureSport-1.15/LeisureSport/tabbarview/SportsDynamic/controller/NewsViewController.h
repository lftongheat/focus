//
//  NewsViewController.h
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-7-13.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface NewsViewController : UIViewController <UIWebViewDelegate, MBProgressHUDDelegate>
{
    NSString *urlStr;
    MBProgressHUD *HUD;
}
@property(nonatomic, retain) NSString *urlStr;

@end
