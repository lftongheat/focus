//
//  RemindSettingPlist.m
//  LeisureSport
//
//  Created by 高 峰 on 12-7-4.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "RemindSettingPlist.h"

@implementation RemindSettingPlist


-(void) writeToPlist:(NSString *)OnOrOff index:(int)indexParamenter
{
    NSArray *paths;
    NSString *docPath;
    NSString *newPath;
    paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	docPath = [paths objectAtIndex:0];
	newPath = [docPath stringByAppendingPathComponent:@"Preferences/RemingSetting.plist"];
    NSMutableArray *remindInfoArray=nil;
    remindInfoArray = [NSMutableArray arrayWithContentsOfFile:newPath];
    
    if(remindInfoArray==nil)
    {
        remindInfoArray = [[[NSMutableArray alloc] init] autorelease];
    }
    
    //NSArray *singUserInfo = [[NSArray alloc] initWithObjects:userId,password, nil];
    
    //    [userInfoArray removeObjectAtIndex:0];
    //    [userInfoArray removeObjectAtIndex:1];
    [remindInfoArray removeAllObjects];
    
    NSMutableArray *tmpArray= [[self readPlist:@""] mutableCopy];
    for(int i=0;i<5;i++)
    {
        if(i!=indexParamenter)
        {
            if(((NSString *)[tmpArray objectAtIndex:i]).length==0)
            {
                [remindInfoArray addObject:@""];
            }else
            {
                [remindInfoArray addObject:@"1"];
            }
            
        }else
        {
            [remindInfoArray addObject:OnOrOff];
        }
    }
    [tmpArray release];
//    [remindInfoArray addObject:userId];
//    [remindInfoArray addObject:password];
    
    
    //[userInfoArray removeObjectAtIndex:0];
    //[userInfoArray addObject:singUserInfo];
    [remindInfoArray writeToFile:newPath atomically:YES];
    //[singUserInfo release];
    
}


- (id) readPlist:(NSString *)fileName
{
    NSArray *paths;
    NSString *docPath;
    NSString *newPath;
    paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	docPath = [paths objectAtIndex:0];
	newPath = [docPath stringByAppendingPathComponent:@"Preferences/RemingSetting.plist"];
    

    
    NSMutableArray *infoArray=[NSMutableArray arrayWithContentsOfFile:newPath];

    return infoArray;

}
@end
