//
//  FavorLeagueController.h
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-5.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface FavorLeagueController : UITableViewController <MBProgressHUDDelegate>
{
    NSMutableArray *leagueArray;			// The master content.
    UITableView *leagueTableView;    
    NSMutableArray *favorLeagueArray;   //关注的联赛
    
    MBProgressHUD *HUD;
}

@end
