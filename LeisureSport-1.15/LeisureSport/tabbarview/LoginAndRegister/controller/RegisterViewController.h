//
//  RegisterViewController.h
//  LoginAndRegister
//
//  Created by 高 峰 on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeisureSportAppDelegate.h"

@interface RegisterViewController : UIViewController <UITextFieldDelegate>
{
    UITextField *idTextField;//邮箱输入框
    UITextField *passwordTextField;//密码输入框
    UITextField *passwordVerifyTextField;//密码确认输入框
    
    UIButton *confirmButton;//确认注册按钮
    
    LSViewController lsViewController;//记录要跳转的界面
    
    LS_IWatchSelectedController ls_IWatchSelectedController;//记录要跳转的界面的分段按钮
}

@property(nonatomic,retain) UITextField *idTextField;
@property(nonatomic,retain) UITextField *passwordTextField;
@property(nonatomic,retain) UITextField *passwordVerifyTextField;
@property(nonatomic,retain) UIButton *confirmButton;

@property (nonatomic) LSViewController lsViewController;
@property (nonatomic) LS_IWatchSelectedController ls_IWatchSelectedController;

-(void) confirmAction: (id)sender;
-(id) initWithFrame:(LSViewController)controller selection:(LS_IWatchSelectedController) selected;
@end
