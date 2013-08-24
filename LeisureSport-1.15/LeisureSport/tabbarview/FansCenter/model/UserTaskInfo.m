//
//  UserTask.m
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-4.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "UserTaskInfo.h"

@implementation UserTaskInfo
@synthesize EndDate;
@synthesize ImageID;
@synthesize Introduce;
@synthesize IsFinished;
@synthesize IsInUse;
@synthesize RepeatType;
@synthesize RewardPoints;
@synthesize StartDate;
@synthesize TaskID;
@synthesize TaskTypeID;
@synthesize TaskTypeName;
@synthesize Title;

-(void)dealloc
{
    [EndDate release];
    [ImageID release];
    [Introduce release];
    [IsFinished release];
    [IsInUse release];
    [RepeatType release];
    [RewardPoints release];
    [StartDate release];
    [TaskID release];
    [TaskTypeID release];
    [TaskTypeName release];
    [Title release];
    
    [super dealloc];
}
@end
