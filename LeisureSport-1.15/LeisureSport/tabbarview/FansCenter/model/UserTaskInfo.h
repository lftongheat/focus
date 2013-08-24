//
//  UserTask.h
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-4.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//  任务信息

#import <Foundation/Foundation.h>

@interface UserTaskInfo : NSObject
{
    NSString *EndDate;
    NSString *ImageID;
    NSString *Introduce;
    NSString *IsFinished;
    NSString *IsInUse;
    NSString *RepeatType;
    NSString *RewardPoints;
    NSString *StartDate;
    NSString *TaskID;
    NSString *TaskTypeID;
    NSString *TaskTypeName;
    NSString *Title;
}

@property(nonatomic, retain) NSString *EndDate;
@property(nonatomic, retain) NSString *ImageID;
@property(nonatomic, retain) NSString *Introduce;
@property(nonatomic, retain) NSString *IsFinished;
@property(nonatomic, retain) NSString *IsInUse;
@property(nonatomic, retain) NSString *RepeatType;
@property(nonatomic, retain) NSString *RewardPoints;
@property(nonatomic, retain) NSString *StartDate;
@property(nonatomic, retain) NSString *TaskID;
@property(nonatomic, retain) NSString *TaskTypeID;
@property(nonatomic, retain) NSString *TaskTypeName;
@property(nonatomic, retain) NSString *Title;

@end
