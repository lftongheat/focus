//
//  LoginDropdownlist.h
//  LeisureSport
//
//  Created by 高 峰 on 12-7-13.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QQNumChangedDelegate;

@interface LoginDropdownlist : UIView <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField* textField;   //文本输入框
    UIButton *btDropdown;     //打开下拉列表  
   // NSMutableArray* list;            //下拉列表数据
    BOOL showList;             //是否弹出下拉列表
    UITableView* listView;    //下拉列表
    CGRect oldFrame,newFrame;   //整个控件（包括下拉前和下拉后）的矩形
    UIColor *lineColor,*listBgColor;//下拉框的边框色、背景色
    CGFloat lineWidth;               //下拉框边框粗细
    UITextBorderStyle borderStyle;   //文本框边框style
    NSMutableArray *userLoginInfo;  //用户登录信息，邮箱和密码;
    NSArray *tmpArray;  //暂存用户信息,数组项依次为：帐号、密码、记住密码、自动登录
    id<QQNumChangedDelegate> qqNumChangedDelegate;
}

@property (nonatomic,retain)UITextField *textField;
@property (nonatomic,retain)UIButton *btDropdown;
@property (nonatomic,assign)BOOL showList; 
//@property (nonatomic,retain)NSMutableArray* list;
@property (nonatomic,retain)UITableView* listView;
@property (nonatomic,retain)UIColor *lineColor,*listBgColor;
@property (nonatomic,assign)UITextBorderStyle borderStyle;
@property (nonatomic,retain)id<QQNumChangedDelegate> qqNumChangedDelegate;

-(void) drawView;
-(void) setShowList:(BOOL)b;
-(void) DropUp;
//隐藏软键盘，将该功能开放给调用该类的UI控制类
- (void) hidKeyBoard;

- (NSString *) getQQNum;

- (id)initWithFrame:(CGRect)frame userInfo:(NSMutableArray *)userlogin_Info Delegate:(id<QQNumChangedDelegate>)delegate;
@end

@protocol QQNumChangedDelegate
//当在Dropdownlist中选中一个QQ号码的时候，自动填充上QQ密码
- (void) DidSelectQQNumfromDropdownlist:(NSString *)Pwd isRememberPwd:(BOOL) isrememberpwd;
////QQ号码长度超过10位、以0开始、号码长度小于5时调用
//- (void) QQNumLengthInvalid;
@end