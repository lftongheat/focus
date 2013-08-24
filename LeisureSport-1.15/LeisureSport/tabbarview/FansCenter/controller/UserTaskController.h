//
//  UserTaskController.h
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-4.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTaskController : UITableViewController
{
    UITableView *taskTableView;
    NSMutableArray *userTaskInfoArray;
    NSMutableArray *taskType;
}
@end
