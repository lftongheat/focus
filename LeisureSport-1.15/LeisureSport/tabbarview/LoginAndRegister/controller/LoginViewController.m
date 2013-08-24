//
//  LoginViewController.m
//  LoginAndRegister
//
//  Created by 高 峰 on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "RegexKitLite.h"
#import "RegisterViewController.h"
#import "UserInfoPlistIO.h"
#import "LSUtil.h"
#import "LeisureSportAppDelegate.h"
#import "LoginResponse.h"
#import "LoginAndRegisterFetcher.h"
#import "LoginDropdownlist.h"

@implementation LoginViewController

//@synthesize idTextField;
@synthesize loginDropdownlist,passwordTextField,registerButton,loginButton,findPasswordButton,passwordcheckBox;
@synthesize lsViewController,ls_IWatchSelectedController;

-(id) initWithFrame:(LSViewController)controller selection:(LS_IWatchSelectedController) selected//初始化登录界面，记录要跳转的界面以及该界面的分段按钮选项
{
    self.lsViewController = controller;
    self.ls_IWatchSelectedController = selected;
    //从文件读取玩家登录的邮箱和密码信息
//    userLoginInfoArray = [[NSMutableArray alloc] initWithContentsOfFile:[GetFilePath getUserLoginInfoFilePath]];
    UserInfoPlistIO *userInfoPlistIO = [[UserInfoPlistIO alloc] init];
    userLoginInfoArray = [[userInfoPlistIO readPlist:@""] mutableCopy];
    
    if([userLoginInfoArray count]!=0)
    {
        [userLoginInfoArray removeObjectAtIndex:([userLoginInfoArray count]-1)];
    }
    
    [userInfoPlistIO release];
    
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
//    [idTextField release];
    [loginDropdownlist release];
	[passwordTextField release];
    [passwordcheckBox release];
    [findPasswordButton release];
	[registerButton release];
	[loginButton release];
    //[userLoginInfoArray release];
    
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
    
    //返回首页按钮
    UIButton * customView=[UIButton buttonWithType:UIButtonTypeCustom];
	[customView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"首页按钮" ofType:@"png"]] forState:0];
	[customView addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
	customView.frame=CGRectMake(3,3, 49, 31);
	
	UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.leftBarButtonItem = back;
    [back release];
    
    //导航栏设置
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NaviBarBg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    if ([self.tabBarController.tabBar respondsToSelector:@selector(setBackgroundImage:)]) {
        [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"TabBarBg.png"]];
    }
    self.title = @"登录";
    
    UIImageView *topBg = PALEGREEN_BG_VIEW;
    topBg.frame = CGRectMake(0, 0, 320, 200);
    [self.view addSubview:topBg];
    topBg.userInteractionEnabled = YES;
	
    
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
    
    
    
    
    //是否记住密码
    passwordcheckBox = [[CheckBox alloc]initWithFrame:CGRectMake(20, 90, 50, 50)];
    UILabel *remember = [[UILabel alloc] initWithFrame:CGRectMake(70, 90, 70, 50)];
    remember.backgroundColor = [UIColor clearColor];
    [remember setTextColor:[UIColor grayColor]];
    remember.text = @"记住密码";
    
    
    //将密码和QQ信息传递到下拉列表中初始化,此处下拉框的初始化要在密码输入框和时候记住密码之后，因为下拉框中的代理回调函数可能将为后两者赋值
    loginDropdownlist = [[LoginDropdownlist alloc] initWithFrame:CGRectMake(20.0, 10.0, 280.0, 31.0) userInfo:userLoginInfoArray Delegate:(id)self];
    
    //找回密码
    findPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(150.0, 90.0, 150.0, 50.0)];

    [findPasswordButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [findPasswordButton setTitle:@"找回登录密码" forState:UIControlStateNormal];
    
    
    //注册按钮
    registerButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 150.0, 130.0, 31.0)];
    registerButton.backgroundColor = [UIColor clearColor];
    UIImage *rbnImg = [LSUtil scaleToSize:[UIImage imageNamed:@"当天按钮1.png"] size:CGSizeMake(130, 31)];
    [registerButton setBackgroundImage:rbnImg forState:UIControlStateNormal];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    
    //登录按钮
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(165.0, 150.0, 130.0, 31.0)];
    loginButton.backgroundColor = [UIColor clearColor];
    UIImage *lbnImg = [LSUtil scaleToSize:[UIImage imageNamed:@"确认未按.png"] size:CGSizeMake(130, 31)];
    [loginButton setBackgroundImage:lbnImg forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    
	//为按钮添加事件
    [findPasswordButton addTarget:self action:@selector(findPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
	
	
//    [topBg addSubview:idTextField];
    [topBg addSubview:loginDropdownlist];
	[topBg addSubview:passwordTextField];
    [topBg addSubview:passwordcheckBox];
    [topBg addSubview:remember];
    [topBg addSubview:findPasswordButton];
    [topBg addSubview:registerButton];
    [topBg addSubview:loginButton];
    [remember release];
	
    //	[iv release];
    [topBg release];

}

- (void) loginAction:(id)sender//登录事件
{
//    [idTextField resignFirstResponder];
    [loginDropdownlist.textField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    if(loginDropdownlist.showList==true)
    {
        [loginDropdownlist DropUp];
    }
    
    NSString *emailregex = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    
    if(loginDropdownlist.textField.text.length==0||passwordTextField.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入账号或密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else if(![loginDropdownlist.textField.text isMatchedByRegex:emailregex])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邮箱格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else
    {
        if([LSUtil connectedToNetwork])
        {
            //通过输入验证，向服务器发送请求，通过返回结果判断是否登录成功
            LoginResponse *loginresponse = [[LoginResponse alloc] init];
            NSString *name = self.loginDropdownlist.textField.text;
            NSString *pwd = self.passwordTextField.text;
            NSMutableArray *loginArray = [LoginAndRegisterFetcher fetchLogin:name pwd:pwd clientVersion:@"V1.0" userType:@"2"];
            loginresponse = [loginArray objectAtIndex:0];
            //[loginArray release];
            NSString *userID = loginresponse.UserID;
            [loginresponse release];
            if([userID isEqualToString:@"-2"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                [alert release];
            }else if([userID isEqualToString:@"-3"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                [alert release];
            }else
            {
                [super viewDidLoad];
                UserInfoPlistIO *userInfoPlistIO = [[UserInfoPlistIO alloc] init];
                NSMutableArray *tmpArray = [[userInfoPlistIO readPlist:@""] mutableCopy];
                
                NSString *ischecked = [[NSString alloc] init];
                if(passwordcheckBox.isChecked)
                {
                    ischecked = @"1";
                }else
                {
                    ischecked = @"";
                    pwd=@"";
                }
                
                
                if([tmpArray count]==0)
                {
                    tmpArray = [[NSMutableArray alloc] init];
                    NSArray *tmpItem = [[NSArray alloc] initWithObjects:userID,pwd,ischecked,name,nil];
                    [tmpArray addObject:tmpItem];
                    [tmpItem release];
                }else
                {
                    [tmpArray removeObjectAtIndex:[tmpArray count]-1];
                    bool exist = false;
                    NSArray *tmpItem = [[NSArray alloc] initWithObjects:userID,pwd,ischecked,name,nil];
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
                
                [ischecked release];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络状态不佳，登录失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];

        }

        
    }
    [emailregex release];
}


-(void) findPasswordAction: (id)sender//找回密码事件
{
    if(loginDropdownlist.showList==true)
    {
        [loginDropdownlist DropUp];
    }
    if(loginDropdownlist.textField.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入账号或密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else
    {
        NSString *result = [LoginAndRegisterFetcher fetchFindPassword:loginDropdownlist.textField.text];
        if([result isEqualToString:@"0"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码已发送邮箱" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
}

-(void) registerAction: (id)sender//注册事件，跳转到注册界面，将之前要跳转的界面以及界面中分段按钮的选项作为参数传递
{
//    [idTextField resignFirstResponder];
    [loginDropdownlist.textField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    if(loginDropdownlist.showList==true)
    {
        [loginDropdownlist DropUp];
    }
    RegisterViewController *iv = [[RegisterViewController alloc] init];
    iv.lsViewController = self.lsViewController;
    iv.ls_IWatchSelectedController = self.ls_IWatchSelectedController;
    [self.navigationController pushViewController:iv animated:YES];
    [iv release];        
}

- (void) DidSelectQQNumfromDropdownlist:(NSString *)Pwd isRememberPwd:(BOOL) isrememberpwd
{
    passwordTextField.text = Pwd;
    passwordcheckBox.isChecked = isrememberpwd;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   // return NO to not change text
{
    if([@"\n" isEqualToString:string] == YES){
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)backToHome
{
	LeisureSportAppDelegate *app=[[UIApplication sharedApplication] delegate];
    [app gotoController:LSHomeViewController selection:OthersController];
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
