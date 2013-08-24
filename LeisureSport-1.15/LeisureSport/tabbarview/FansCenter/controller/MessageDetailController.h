//
//  MessageDetailController.h
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-15.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UserInfo.h"

@interface MessageDetailController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate, UINavigationControllerDelegate, MBProgressHUDDelegate>
{
    NSMutableArray		*chatArray;
    
	NSMutableDictionary	*currentChatInfo;
	NSMutableString		*currentString;
	
	BOOL				isMySpeaking;
    
    NSMutableArray *msgArray;
    
    NSString *fromUserID;
    NSString *toUserID;
    UserInfo *fromUser;
    UserInfo *toUser;
    
    NSTimer *timer;//定时器
    MBProgressHUD *HUD;
}

@property(nonatomic, retain) NSString *fromUserID;
@property(nonatomic, retain) NSString *toUserID;

@property(nonatomic, retain) NSTimer *timer;

- (void) loadMsgRecord;
- (NSString *)addOneSecond: (NSString *)time;

@end
