//
//  More.h
//  LeisureSport
//
//  Created by 高 峰 on 12-6-22.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface More : UIViewController
{
    UIButton *remindSetButton;//启动提示按钮
    UIButton *aboutButton;//关于按钮
    UIButton *feedBackButton;//反馈按钮
    UIButton *quitButton;//退出登录按钮
    UIButton *loginButton;//登录按钮
    UIButton *registerButton;//注册按钮
}

@property(nonatomic,retain) UIButton *remindSetButton;
@property(nonatomic,retain) UIButton *aboutButton;
@property(nonatomic,retain) UIButton *feedBackButton;
@property(nonatomic,retain) UIButton *quitButton;
@property(nonatomic,retain) UIButton *loginButton;
@property(nonatomic,retain) UIButton *registerButton;
@end
