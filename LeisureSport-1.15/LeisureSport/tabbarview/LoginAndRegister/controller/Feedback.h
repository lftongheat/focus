//
//  Feedback.h
//  LeisureSport
//
//  Created by 高 峰 on 12-6-25.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface Feedback : UIViewController<UITextViewDelegate,UITextFieldDelegate>
{
    UITextView *feedbackTextView;//反馈内容
    UITextField *feedbackTextField;//邮箱
    UIButton *commitButton;//发表按钮
    UILabel *remindLable;
//    UIButton *recommendButton;//推荐给好友
//    UIButton *moreSoftButton;//更多软件
}

@property(nonatomic,retain) UITextView *feedbackTextView;
@property(nonatomic,retain) UITextField *feedbackTextField;
@property(nonatomic,retain) UIButton *commitButton;
//@property(nonatomic,retain) UIButton *recommendButton;
//@property(nonatomic,retain) UIButton *moreSoftButton;

@end
