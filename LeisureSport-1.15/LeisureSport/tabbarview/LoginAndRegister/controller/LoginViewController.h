//
//  LoginViewController.h
//  LoginAndRegister
//
//  Created by 高 峰 on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckBox.h"
#import "LeisureSportAppDelegate.h"
#import "LoginDropdownlist.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>
{
    //UITextField *idTextField;//邮箱输入框
    
    LoginDropdownlist *loginDropdownlist;//邮箱下拉列表
    NSMutableArray *userLoginInfoArray; //用户登录信息（邮箱和密码）;
    
    UITextField *passwordTextField;//密码输入框
    
    UIButton *registerButton;//注册按钮
    UIButton *loginButton;//登录按钮
    
    UIButton *findPasswordButton;//找回密码
    
    CheckBox *passwordcheckBox;//是否记住密码
    
    LSViewController lsViewController;//要跳转的界面
    
    LS_IWatchSelectedController ls_IWatchSelectedController;//要跳转的界面的分段按钮选项

}

//@property(nonatomic,retain) UITextField *idTextField;
@property(nonatomic,retain) LoginDropdownlist *loginDropdownlist;
@property(nonatomic,retain) UITextField *passwordTextField;
@property(nonatomic,retain) UIButton *registerButton;
@property(nonatomic,retain) UIButton *loginButton;
@property(nonatomic,retain) UIButton *findPasswordButton;
@property(nonatomic,retain) CheckBox *passwordcheckBox;
@property (nonatomic) LSViewController lsViewController;
@property (nonatomic) LS_IWatchSelectedController ls_IWatchSelectedController;

-(void) loginAction: (id)sender;
-(void) findPasswordAction: (id)sender;
-(void) registerAction: (id)sender;
-(id) initWithFrame:(LSViewController)controller selection:(LS_IWatchSelectedController) selected;
- (void) DidSelectQQNumfromDropdownlist:(NSString *)Pwd isRememberPwd:(BOOL) isrememberpwd;

@end
