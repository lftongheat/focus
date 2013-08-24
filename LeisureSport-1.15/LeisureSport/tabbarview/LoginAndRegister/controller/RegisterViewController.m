//
//  RegisterViewController.m
//  LoginAndRegister
//
//  Created by 高 峰 on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegexKitLite.h"
#import "LSUtil.h"
#import "RegisterResponse.h"
#import "LoginAndRegisterFetcher.h"
#import "UserInfoPlistIO.h"

@implementation RegisterViewController

@synthesize idTextField,passwordTextField,passwordVerifyTextField,confirmButton;
@synthesize lsViewController,ls_IWatchSelectedController;


-(id) initWithFrame:(LSViewController)controller selection:(LS_IWatchSelectedController) selected//注册界面初始化，参数为要跳转的界面以及该界面的分段按钮的选项
{
    self.lsViewController = controller;
    self.ls_IWatchSelectedController = selected;
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) dealloc
{
    [idTextField release];
    [passwordTextField release];
    [passwordVerifyTextField release];
    [confirmButton release];
    
    [super dealloc];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 368)];
    
    UIImage *bgImg = [LSUtil scaleToSize:[UIImage imageNamed:@"greenbg.png"] size:CGSizeMake(320, 368)];
    view.backgroundColor = [UIColor colorWithPatternImage:bgImg];
    
	self.view=view;
	[view release];
    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加左导航键
    UIButton * backButton=[UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"返回按钮按下.png"] forState:UIControlStateHighlighted];
	[backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	backButton.frame=CGRectMake(3,3, 48, 30);
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = back;
    [back release];
    
    //设置导航栏
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NaviBarBg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    if ([self.tabBarController.tabBar respondsToSelector:@selector(setBackgroundImage:)]) {
        [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"TabBarBg.png"]];
    }
    self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:(82.0/255.0) green:(81.0/255.0) blue:(81.0/255.0) alpha:1];
    self.title = @"注册";
    

    UIImageView *topBg = PALEGREEN_BG_VIEW;
    topBg.frame = CGRectMake(0, 0, 320, 200);
    [self.view addSubview:topBg];
    topBg.userInteractionEnabled = YES;
    
	//邮箱输入框
	idTextField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 10.0, 280.0, 31.0)];
	idTextField.borderStyle = UITextBorderStyleRoundedRect;
	idTextField.keyboardType = UIKeyboardTypeEmailAddress;
    idTextField.returnKeyType = UIReturnKeyDone;
    idTextField.delegate=self;
    idTextField.placeholder = @"账号:example@gmail.com";
	idTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	
    //密码输入框
	passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 50.0, 280.0, 31.0)];
	passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
	//passwordField.enabled = NO;
    passwordTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    passwordTextField.returnKeyType = UIReturnKeyDone;
    passwordTextField.delegate=self;
    passwordTextField.placeholder = @"密码";
    passwordTextField.secureTextEntry = YES;
	passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    //密码确认输入框
    passwordVerifyTextField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 90.0, 280.0, 31.0)];
	passwordVerifyTextField.borderStyle = UITextBorderStyleRoundedRect;
	//passwordField.enabled = NO;
    passwordVerifyTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    passwordVerifyTextField.returnKeyType = UIReturnKeyDone;
    passwordVerifyTextField.delegate=self;
    passwordVerifyTextField.placeholder = @"再次输入密码";
    passwordVerifyTextField.secureTextEntry = YES;
	passwordVerifyTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    //注册确认按钮
    confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 140.0, 280.0, 31.0)];
    confirmButton.backgroundColor = [UIColor clearColor];
    UIImage *cbnImg = [LSUtil scaleToSize:[UIImage imageNamed:@"确认未按.png"] size:CGSizeMake(280, 31)];
    [confirmButton setBackgroundImage:cbnImg forState:UIControlStateNormal];
    [confirmButton setTitle:@"注册" forState:UIControlStateNormal];
    
    [confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    
	[topBg addSubview:idTextField];
	[topBg addSubview:passwordTextField];
    [topBg addSubview:passwordVerifyTextField];
    [topBg addSubview:confirmButton];
	
    
	
	[topBg release];
}

-(void) confirmAction:(id)sender//注册确认事件
{
    [idTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [passwordVerifyTextField resignFirstResponder];
    
    NSString *emailregex = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    
    //需要通过格式验证
    if(idTextField.text.length==0||passwordTextField.text.length==0||passwordVerifyTextField.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入账号或密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else if(![idTextField.text isMatchedByRegex:emailregex])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邮箱格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else if(![passwordTextField.text isEqualToString:passwordVerifyTextField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else
    {
        if([LSUtil connectedToNetwork])
        {
            //通过输入验证后，向服务器发送注册请求，根据返回内容判断是否成功
            RegisterResponse *registerre = [[RegisterResponse alloc] init];
            NSString *name = self.idTextField.text;
            NSString *pwd = self.passwordTextField.text;
            NSMutableArray *registerArray = [LoginAndRegisterFetcher fetchRegister:name pwd:pwd email:name nickname:name IMEI:@"000000" clientVersion:@"V1.0" userType:@"2"];
            registerre = [registerArray objectAtIndex:0];
            //[loginArray release];
            NSString *userID = registerre.UserID;
            [registerre release];
            if([userID isEqualToString:@"-2"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户已注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                [alert release];
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
                [alert show];
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                [alert release];
                
                UserInfoPlistIO *userInfoPlistIO = [[UserInfoPlistIO alloc] init];
                NSMutableArray *tmpArray = [[userInfoPlistIO readPlist:@""] mutableCopy];
                
                
                if([tmpArray count]==0)
                {
                    tmpArray = [[NSMutableArray alloc] init];
                    NSArray *tmpItem = [[NSArray alloc] initWithObjects:userID,@"",@"",name,nil];
                    [tmpArray addObject:tmpItem];
                    [tmpItem release];
                }else
                {
                    [tmpArray removeObjectAtIndex:[tmpArray count]-1];
                    bool exist = false;
                    NSArray *tmpItem = [[NSArray alloc] initWithObjects:userID,@"",@"",name,nil];
                    for(int i=0;i<[tmpArray count];i++)
                    {
                        if([userID isEqualToString:[[tmpArray objectAtIndex:i] objectAtIndex:0]])
                        {
                            [tmpArray removeObjectAtIndex:i];
                            [tmpArray addObject:tmpItem];
                            exist = true;
                            break;
                        }
                    }
                    if(!exist)
                    {
                        [tmpArray addObject:tmpItem];
                    }
                    [tmpItem release];
                }
                
                NSArray *nullArray = [[NSArray alloc] initWithObjects:@"",@"",@"",@"", nil];
                [tmpArray addObject:nullArray];
                [nullArray release];
                
                [userInfoPlistIO setLoginedOrNot:YES];
                [userInfoPlistIO writeToPlistFromArray:tmpArray];
                [tmpArray release];
                [userInfoPlistIO release];
                
                [LeisureSportAppDelegate setUserID:userID];
                LeisureSportAppDelegate *app=[[UIApplication sharedApplication] delegate];
                [app gotoController:self.lsViewController selection:self.ls_IWatchSelectedController];
            }

        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络状态不佳，注册失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
                //[self dismissModalViewControllerAnimated:YES];
    }
    [emailregex release];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   // return NO to not change text
{
    if([@"\n" isEqualToString:string] == YES){
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

//返回
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
