//
//  Feedback.m
//  LeisureSport
//
//  Created by 高 峰 on 12-6-25.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "Feedback.h"
#import "LSUtil.h"
#import "RegexKitLite.h"
#import "LoginAndRegisterFetcher.h"
#import <MessageUI/MessageUI.h>

@implementation Feedback
@synthesize feedbackTextView,feedbackTextField,commitButton;
//@synthesize recommendButton,moreSoftButton;

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

-(void)dealloc
{
    [super dealloc];
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 368)];
	
    view.backgroundColor = [UIColor colorWithPatternImage:GREEN_BG_IMAGE];
    self.view =view;
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

    self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:(82.0/255.0) green:(81.0/255.0) blue:(81.0/255.0) alpha:1];
    self.title = @"意见反馈";
    
    UIImageView *Bg = PALEGREEN_BG_VIEW;
//    Bg.frame = CGRectMake(0, 5, 320, 320);
    Bg.frame = CGRectMake(0, 5, 320, 260);
    Bg.userInteractionEnabled = YES;
    [self.view addSubview:Bg];
    
    
    feedbackTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 15, 280, 100)];
    feedbackTextView.layer.cornerRadius = 6;
    feedbackTextView.layer.masksToBounds = YES;
    feedbackTextView.font = [UIFont systemFontOfSize:12];
    remindLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
    remindLable.textColor = [UIColor lightGrayColor];
    remindLable.text = @"请输入您的反馈意见";
    [feedbackTextView addSubview:remindLable];
    [remindLable release];
    feedbackTextView.delegate = self;
    feedbackTextView.returnKeyType = UIReturnKeyDone;
    
    [Bg addSubview:feedbackTextView];
    [feedbackTextView release];
    
    feedbackTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 130, 220, 40)];
    feedbackTextField.backgroundColor = [UIColor whiteColor];
    feedbackTextField.clipsToBounds = YES;
    feedbackTextField.borderStyle = UITextBorderStyleRoundedRect;
	feedbackTextField.keyboardType = UIKeyboardTypeEmailAddress;
    feedbackTextField.returnKeyType = UIReturnKeyDone;
    feedbackTextField.delegate=self;
    feedbackTextField.placeholder = @"Email";
	feedbackTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [Bg addSubview:feedbackTextField];
    [feedbackTextField release];
    
    commitButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 130, 50, 40)];
    [commitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [commitButton setBackgroundImage:[[UIImage imageNamed:@"反馈按钮-320.png"] 
                                      stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateNormal];
    [commitButton setTitle:@"发表" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    [Bg addSubview:commitButton];
    [commitButton release];
    
    UILabel *tmp1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, 200, 15)];
    tmp1.backgroundColor = [UIColor clearColor];
    tmp1.font = [UIFont boldSystemFontOfSize:13.0];
    tmp1.text = @"怡情体育";
    UILabel *tmp2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 195, 200, 15)];
    tmp2.backgroundColor = [UIColor clearColor];
    tmp2.text = [@"版本号:" stringByAppendingString:[LoginAndRegisterFetcher fetchVersion]];
    tmp2.font = [UIFont boldSystemFontOfSize:13.0];
    UILabel *tmp3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 210, 200, 15)];
    tmp3.backgroundColor = [UIColor clearColor];
    tmp3.font = [UIFont boldSystemFontOfSize:13.0];
    tmp3.text = @"联系电话:0755-26985155";
    UILabel *tmp4 = [[UILabel alloc] initWithFrame:CGRectMake(20, 225, 200, 15)];
    tmp4.backgroundColor = [UIColor clearColor];
    tmp4.font = [UIFont boldSystemFontOfSize:13.0];
    tmp4.text = @"联系邮箱:zjj@janzsoft.com";
    
    [Bg addSubview:tmp1];
    [Bg addSubview:tmp2];
    [Bg addSubview:tmp3];
    [Bg addSubview:tmp4];
    [tmp1 release];
    [tmp2 release];
    [tmp3 release];
    [tmp4 release];
    
    /*
    recommendButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 230, 120, 40)];
    [recommendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [recommendButton setBackgroundImage:[[UIImage imageNamed:@"反馈按钮-320.png"] 
                              stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateNormal];
    [recommendButton setTitle:@"推荐给好友" forState:UIControlStateNormal];
    [recommendButton addTarget:self action:@selector(recommendAction:) forControlEvents:UIControlEventTouchUpInside];
    [Bg addSubview:recommendButton];
    [recommendButton release];
    
    moreSoftButton = [[UIButton alloc] initWithFrame:CGRectMake(180, 230, 120, 40)];
    [moreSoftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [moreSoftButton setBackgroundImage:[[UIImage imageNamed:@"反馈按钮-320.png"]stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateNormal];
    [moreSoftButton setTitle:@"更多软件" forState:UIControlStateNormal];
    [moreSoftButton addTarget:self action:@selector(moreSoftAction:) forControlEvents:UIControlEventTouchUpInside];
    [Bg addSubview:moreSoftButton];
    [moreSoftButton release];*/
    
    [Bg release];
}

-(void) commitAction: (id)sender
{
    [feedbackTextField resignFirstResponder];
    [feedbackTextView resignFirstResponder];
    
    //邮箱格式验证
    NSString *emailregex = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    
    
    if(![feedbackTextField.text isMatchedByRegex:emailregex])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的email" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else if(feedbackTextView.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入你要反馈的信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else
    {
        NSString *content = feedbackTextView.text;
        NSString *email = feedbackTextField.text;
        
        [LoginAndRegisterFetcher fetchFeedback:content email:email IMEI:@"" userID:@""];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功，感谢您的反馈" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
}
/*
-(void) recommendAction: (id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"推荐给好友" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

-(void) moreSoftAction: (id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"更多软件" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    [alert release];
}*/

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [remindLable setHidden:YES]; 
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSInteger number = [textView.text length];
    if(number==0)
    {
        [remindLable setHidden:NO];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([@"\n" isEqualToString:text] == YES){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   // return NO to not change text
//{
//    if([@"\n" isEqualToString:string] == YES){
//        [textField resignFirstResponder];
//        return NO;
//    }
//    return YES;
//}

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
