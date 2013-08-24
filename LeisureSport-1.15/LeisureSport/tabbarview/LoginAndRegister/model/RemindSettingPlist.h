//
//  RemindSettingPlist.h
//  LeisureSport
//
//  Created by 高 峰 on 12-7-4.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemindSettingPlist : NSObject
- (id) readPlist:(NSString *)fileName;
-(void) writeToPlist:(NSString *)OnOrOff index:(int)indexParamenter;
@end
