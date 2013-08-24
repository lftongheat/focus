//
//  FavorTeamController.h
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-5.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface FavorTeamController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate, MBProgressHUDDelegate>
{
    NSMutableArray						*listContent;			// The master content.
	NSMutableArray				*filteredListContent;	// The content filtered as a result of a search.

	UISearchDisplayController	*searchDisplayController;
    UITableView *teamTableView;
    
    NSMutableArray *favorTeamArray;
    
    BOOL isSearching;   //标记是否使用搜索
    NSString *searchKey;//搜索关键字
    
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) NSMutableArray *listContent;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) UISearchDisplayController	*searchDisplayController;

//从服务器搜索
- (void)searchFromServer;
@end
