//
//  SportsdynamicViewController.h
//  DelightSports
//
//  Created by ACE hitsz302 on 12-5-18.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "EGORefreshTableHeaderView.h"

@interface SportsDynamicController : UITableViewController  <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>{
	
	EGORefreshTableHeaderView *_refreshHeaderView;
    UITableView *sportsTableView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
    BOOL needReload;
    NSMutableArray *newsArray;

}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
