//
//  FansViewController.h
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-7.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "EGORefreshTableHeaderView.h"

@interface FansViewController : UITableViewController  <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>{
	
	EGORefreshTableHeaderView *_refreshHeaderView;
	UITableView *fansTableView;
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
    BOOL firstLoad;
    NSMutableArray *fansArray;
    NSString *myUserID;
}

@property(nonatomic, retain) NSString *myUserID;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
