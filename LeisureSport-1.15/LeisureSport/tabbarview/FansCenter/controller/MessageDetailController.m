//
//  MessageDetailController.m
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-15.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "MessageDetailController.h"
#import "FansCenterFetcher.h"
#import "Message.h"
#import "LSUtil.h"
#import "UserDetailController.h"
#import "LeisureSportAppDelegate.h"
#import "UIButton+WebCache.h"
#import "MBProgressHUD.h"

@implementation MessageDetailController
@synthesize fromUserID, toUserID, timer;

#define TEXTFIELDTAG	100
#define TOOLBARTAG		200
#define TABLEVIEWTAG	300
#define LOADINGVIEWTAG	400
#define SENDBUTTONTAG   500

#pragma mark Table view methods
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf {
    float bubbleWidth = 200.0f;
    float headWidth = 45.0f;
	// build single chat bubble cell with given text
	UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
	returnView.backgroundColor = [UIColor clearColor];
    
	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"对话框_self":@"对话框_other" ofType:@"png"]];
	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    
	UIFont *font = [UIFont systemFontOfSize:12];
	CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(150.0f, 1000.0f) lineBreakMode:UILineBreakModeCharacterWrap];
    
	UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(21.0f, 14.0f, size.width+10, size.height+10)];
	bubbleText.backgroundColor = [UIColor clearColor];
	bubbleText.font = font;
	bubbleText.numberOfLines = 0;
	bubbleText.lineBreakMode = UILineBreakModeCharacterWrap;
	bubbleText.text = text;
    
    UIButton *headImageButton = [[UIButton alloc] init];
	if(fromSelf){
        bubbleImageView.frame = CGRectMake(0.0f, 0.0f, bubbleWidth, size.height+40.0f);
        headImageButton.frame = CGRectMake(bubbleWidth-4.0f, 5.0f, headWidth, headWidth);
		returnView.frame = CGRectMake(320-headWidth-bubbleWidth, 10.0f, headWidth+bubbleWidth, size.height+50.0f);        
        [headImageButton setImageWithURL:IMAGE_URL(fromUser.ImageID) placeholderImage:IMAGEWITHCONTENTSOFFILE(@"默认头像")];
        
    } else{
        headImageButton.frame = CGRectMake(4.0f, 5.0f, headWidth, headWidth);
        bubbleImageView.frame = CGRectMake(headWidth, 0.0f, bubbleWidth, size.height+40.0f);
		returnView.frame = CGRectMake(0.0f, 10.0f, headWidth+bubbleWidth, size.height+50.0f);
        bubbleText.frame = CGRectMake(headWidth+21.0f, 14.0f, size.width+10, size.height+10);
        [headImageButton setImageWithURL:IMAGE_URL(toUser.ImageID) placeholderImage:IMAGEWITHCONTENTSOFFILE(@"默认头像")];
        [headImageButton addTarget:self action:@selector(jumpToUserView) forControlEvents:UIControlEventTouchUpInside];
	}
    [returnView addSubview:headImageButton];
    [headImageButton release];
	[returnView addSubview:bubbleImageView];
	[bubbleImageView release];
	[returnView addSubview:bubbleText];
	[bubbleText release];
    
	return [returnView autorelease];
}


#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    UIToolbar *toolbar = (UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
	toolbar.frame = CGRectMake(0.0f, 460-44-44-keyboardRect.size.height, 320.0f, 44.0f);
	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 460-44-44-keyboardRect.size.height);
	if([chatArray count])
		[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
//    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
	UIToolbar *toolbar = (UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
	toolbar.frame = CGRectMake(0.0f, 372.0f, 320.0f, 44.0f);
	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 372.0f);
}

#pragma mark text file methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version<5.0) {
        UIToolbar *toolbar = (UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
        toolbar.frame = CGRectMake(0.0f, 156.0f, 320.0f, 44.0f);
        UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
        tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 156.0f);
        if([chatArray count])
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
	
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version<5.0) {
        UIToolbar *toolbar = (UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
        toolbar.frame = CGRectMake(0.0f, 372.0f, 320.0f, 44.0f);
        UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
        tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 372.0f);
	}
	return YES;
} 
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// called when 'return' key pressed. return NO to ignore.

    //向服务器发送数据
    [FansCenterFetcher sendMsgFrom:fromUserID TO:toUserID Content:textField.text];
    
	textField.text = @"";
	return YES;
}


#pragma mark navigation button methods
- (BOOL) hideKeyboard {
	UITextField *textField = (UITextField *)[self.view viewWithTag:TEXTFIELDTAG];
	if(textField.editing) {
		textField.text = @"";
		[self.view endEditing:YES];
		
		return YES;
	}
	
	return NO;
}

- (void) clickOutOfTextField:(id)sender {
	[self hideKeyboard];
}


//加载私信记录
- (void) loadMsgRecord
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    msgArray = [[FansCenterFetcher fetchMsgFrom:fromUserID TO:toUserID Time:[LSUtil now] Count:15 Direction:0 Index:@""] mutableCopy];
    [pool release];
    for (int i=0; i<[msgArray count]; i++) {
        Message *msg = [msgArray objectAtIndex:i];
        if([[LeisureSportAppDelegate userID] isEqualToString:msg.FromUserID])
            isMySpeaking = YES;
        else
            isMySpeaking = NO;
        
        UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@", msg.MainContent] from:isMySpeaking];
        [chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:msg.MainContent, @"text",chatView, @"view", nil]];
    }
	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	[tableView reloadData];
    if ([chatArray count] > 0) {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    [HUD hide:YES];
}

- (void)viewDidAppear:(BOOL)animated
{    
    fromUser = [FansCenterFetcher fetchUserInfo:fromUserID myUserID:@""];
    toUser = [FansCenterFetcher fetchUserInfo:toUserID myUserID:@""];
    [self loadMsgRecord];
    
    [HUD hide:YES];
}

#pragma mark view controller methods


-(void)viewDidLoad
{
    self.view = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:GREEN_BG_IMAGE];
    
    chatArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    isMySpeaking = YES;
    
    currentString = [[NSMutableString alloc] initWithCapacity:0];
    currentChatInfo = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    //返回按钮
    UIButton * backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"返回按钮.png"] forState:0];
    [backButton setImage:[UIImage imageNamed:@"返回按钮按下.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame=CGRectMake(3,3, 48, 30);
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = back;
    [back release];
    
    //刷新按钮
    UIButton * refreshButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setImage:[UIImage imageNamed:@"刷新按钮.png"] forState:UIControlStateNormal];
    [refreshButton setImage:[UIImage imageNamed:@"刷新按钮按下.png"] forState:UIControlStateHighlighted];
    [refreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    refreshButton.frame=CGRectMake(303,3, 48, 30);
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.rightBarButtonItem = refresh;
    [refresh release];
    
    //输入框
    UITextField *textfield = [[[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 280.0f, 31.0f)] autorelease];
    textfield.tag = TEXTFIELDTAG;
    textfield.delegate = self;
    textfield.autocorrectionType = UITextAutocorrectionTypeNo;
    textfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textfield.enablesReturnKeyAutomatically = YES;
    textfield.borderStyle = UITextBorderStyleRoundedRect;
    textfield.returnKeyType = UIReturnKeySend;
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 372.0f, 320.0f, 44.0f)];
    toolBar.tag = TOOLBARTAG;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    
    NSMutableArray* allitems = [[NSMutableArray alloc] init];
    [allitems addObject:[[[UIBarButtonItem alloc] initWithCustomView:textfield] autorelease]];
    [toolBar setItems:allitems];
    [allitems release];
    [self.view addSubview:toolBar];
    [toolBar release];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 372.0f) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundView = [[[UIImageView alloc] initWithImage:GREEN_BG_IMAGE] autorelease];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.tag = TABLEVIEWTAG;
    
    //增加隐藏键盘手势
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [tableView addGestureRecognizer:gestureRecognizer];
    [self.view addSubview:tableView];
    [tableView release];

    // 键盘高度变化通知，ios5.0新增的  
    #ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    #endif

    //创建定时器
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.delegate = self;
	[HUD show:YES];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)jumpToUserView
{
    UserDetailController *userDetailController = [[UserDetailController alloc] init];
    userDetailController.userID = toUserID;
    userDetailController.myUserID = fromUserID;
    [self.navigationController pushViewController:userDetailController animated:YES];
    [userDetailController release];
}

- (void)back
{
    [timer invalidate];
    timer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refresh
{
    NSLog(@"refresh------------------refresh");
    Message *last = [msgArray lastObject];
    if (last) {
        NSString *time = [self addOneSecond:last.MessageDT];
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSMutableArray *tmpArray = [[FansCenterFetcher fetchMsgFrom:fromUserID TO:toUserID Time:time Count:5  Direction:1 Index:last.MessageID] mutableCopy];
        if ([tmpArray count]>0) {
            for (int i=0; i<[tmpArray count]; i++) {
                Message *msg = [tmpArray objectAtIndex:i];
                [msgArray addObject:msg];//更新消息数组
                if([[LeisureSportAppDelegate userID] isEqualToString:msg.FromUserID])
                    isMySpeaking = YES;
                else
                    isMySpeaking = NO;
                
                UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@", msg.MainContent] from:isMySpeaking];
                //更新界面显示
                [chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:msg.MainContent, @"text", chatView, @"view", nil]];
            }
            UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
            [tableView reloadData];
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        [tmpArray release];
        [pool release];
    }

}

//增加一秒钟时间
- (NSString *)addOneSecond: (NSString *)time
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:time];
    NSDate *newdate = [date dateByAddingTimeInterval:1];
    return [formatter stringFromDate:newdate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [chatArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UIView *chatView = [[chatArray objectAtIndex:[indexPath row]] objectForKey:@"view"];
	return chatView.frame.size.height+10.0f;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];        
		cell.backgroundColor = [UIColor greenColor];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    // Set up the cell...
	NSDictionary *chatInfo = [chatArray objectAtIndex:[indexPath row]];
	for(UIView *subview in [cell.contentView subviews])
		[subview removeFromSuperview];
	[cell.contentView addSubview:[chatInfo objectForKey:@"view"]];
    return cell;
}

- (void)dealloc {
    [fromUser release];
    [toUser release];
    [timer release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[currentChatInfo release];
	[currentString release];
	[chatArray release];
    [msgArray release];
    [super dealloc];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}
@end
