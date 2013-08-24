//
//  LoginDropdownlist.m
//  LeisureSport
//
//  Created by 高 峰 on 12-7-13.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//


#import "LoginDropdownlist.h"
//#import "GetFilePath.h"
#import "UserInfoPlistIO.h"

@implementation LoginDropdownlist
@synthesize textField;
@synthesize btDropdown;
//@synthesize list;
@synthesize showList;
@synthesize listView;
@synthesize lineColor;
@synthesize listBgColor;
@synthesize borderStyle;
@synthesize qqNumChangedDelegate;

- (id)initWithFrame:(CGRect)frame userInfo:(NSMutableArray *)userlogin_Info Delegate:(id<QQNumChangedDelegate>)delegate
{
    
    if(self=[super initWithFrame:frame]){
        userLoginInfo = userlogin_Info;
        userLoginInfo = [[NSMutableArray alloc] init];
        //倒序，使得最近使用的数据放在最前端
        for (int i = [userlogin_Info count] - 1; i >= 0; i--) 
        {
            [userLoginInfo addObject:[userlogin_Info objectAtIndex:i]];
        }
        //        [userLoginInfo retain];
        qqNumChangedDelegate = delegate;
        //borderStyle = UITextBorderStyleNone;
        borderStyle = UITextBorderStyleRoundedRect;
        showList=NO; //默认不显示下拉框
        oldFrame=frame; //未下拉时控件初始大小
        //当下拉框显示时，计算出控件的大小，最大为5倍行高
        //        int qqNumHeight = [userlogin_Info count] >> 1;
        //        qqNumHeight = qqNumHeight > 5 ? 5 : qqNumHeight;
        //        NSLog(@"the count is %d",[userLoginInfo count]);
        newFrame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height * 5);
        lineColor=[UIColor lightGrayColor];//默认列表边框线为灰色
        listBgColor=[UIColor whiteColor];//默认列表框背景色为白色
        lineWidth=1;     //默认列表边框粗细为1
        //把背景色设置为透明色，否则会有一个黑色的边
        self.backgroundColor=[UIColor clearColor];
        [self drawView];//调用方法，绘制控件
    }
    return self;
}

- (NSString *) getQQNum
{
    return textField.text;
}

- (void)drawView{
    //文本框
//    UIImageView  *textFieldBg = [[UIImageView alloc] initWithFrame:CGRectMake(-5, 0, oldFrame.size.width, oldFrame.size.height)];
//    [textFieldBg setImage:[UIImage imageNamed:@"inputKuan.png"]];
//    [self addSubview:textFieldBg];
//    [textFieldBg release];
    
    textField=[[UITextField alloc]
               initWithFrame:CGRectMake(0, 0,
                                        oldFrame.size.width, 
                                        oldFrame.size.height)];
    textField.borderStyle=borderStyle;//设置文本框的边框风格
    [textField setPlaceholder:@"账号:example@gmail.com"];
    //textField.font = [UIFont systemFontOfSize:22.0];
    //[textField setBackgroundColor:[UIColor clearColor]];
    //[textField setClearButtonMode:UITextFieldViewModeWhileEditing];//输入时显示清除按钮
    //    [textField setClearsContextBeforeDrawing:YES];
    [textField setKeyboardType:UIKeyboardTypeEmailAddress];
    [self addSubview:textField];
    textField.delegate = self;
    int userLoginInfoCount = [userLoginInfo count];
    if (userLoginInfoCount > 0)
    {
        //如果上次登录成功，则文件中会有记录，将上次登录的QQ号和密码显示在登录框中
        //tmpArray = [userLoginInfo objectAtIndex:userLoginInfoCount - 1];
        
        tmpArray = [userLoginInfo objectAtIndex:0];
        
        //        textField.text = (NSString *)[userLoginInfo objectAtIndex:userLoginInfoCount - 2];
        //NSLog(@"tmpArray%@",tmpArray);
        textField.text = (NSString *)[tmpArray objectAtIndex:3];
        //将密码参数通过代理传到LoginView中去
        //        [qqNumChangedDelegate DidSelectQQNumfromDropdownlist:(NSString *)[userLoginInfo objectAtIndex:userLoginInfoCount - 1]];
        BOOL isRememberPwd = NO;
//        BOOL isAutoLogin = NO;
        if (((NSString *)[tmpArray objectAtIndex:2]).length!=0)
            isRememberPwd = YES;
//        if ([((NSString *)[tmpArray objectAtIndex:3]) isEqualToString:@"1"])
//            isAutoLogin = YES;
       // NSLog(@"[tmpArray objectAtIndex:1]%@",[tmpArray objectAtIndex:1]);
        [qqNumChangedDelegate DidSelectQQNumfromDropdownlist:(NSString*)[tmpArray objectAtIndex:1] isRememberPwd:isRememberPwd];
        [btDropdown setEnabled:YES];
    }
    //    [textField addTarget:self action:@selector(dropdown) forControlEvents:UIControlEventAllTouchEvents];
    
    btDropdown = [[UIButton alloc] initWithFrame:CGRectMake(oldFrame.size.width - 40, 1.5, 40, oldFrame.size.height - 3)];
    //NSLog(@"oldFrame.size.height - 3:%f",oldFrame.size.height - 3);
    //btDropdown.backgroundColor = [UIColor grayColor];
    [btDropdown setBackgroundImage:[UIImage imageNamed:@"框内按钮3-320.png"] forState:UIControlStateNormal];
    //[btDropdown setBackgroundImage:[UIImage imageNamed:@"框内按钮3-320.png"] forState:UIControlStateHighlighted];
    
    [self addSubview:btDropdown];
    if (userLoginInfoCount == 0)
    {
        [btDropdown setEnabled:NO];
    }
    [btDropdown addTarget:self action:@selector(DropDown) forControlEvents:UIControlEventTouchUpInside];
    //下拉列表
    
    //    int qqNumHeight = userLoginInfoCount >> 1;
    //    qqNumHeight = qqNumHeight > 5 ? 5 : qqNumHeight;
    
    listView=[[UITableView alloc]initWithFrame:
              CGRectMake(lineWidth,oldFrame.size.height+lineWidth, oldFrame.size.width-lineWidth*2,
                         oldFrame.size.height * 4 - lineWidth*2 )/* (qqNumHeight - 1))*/];
    listView.dataSource=self;
    listView.delegate=self;
    listView.backgroundColor=listBgColor;
    listView.separatorColor=lineColor;
    listView.hidden=!showList;//一开始listView是隐藏的，此后根据showList的值显示或隐藏
    [self.listView setEditing:YES animated:YES];//显示编辑按钮
    self.listView.allowsSelectionDuringEditing = YES;
    
    [self addSubview:listView]; 
    [listView release];
}

//弹出下拉列表
-(void)DropDown
{
    [textField resignFirstResponder];//当使用下拉列表时隐藏软键盘
    if (showList) 
    {//如果下拉框已显示，什么都不做
        return;
    }
    else 
    {//如果下拉框尚未显示，则进行显示
        //把dropdownList放到前面，防止下拉框被别的控件遮住
        [self.superview bringSubviewToFront:self];
        [self setShowList:YES];//显示下拉框
    }
    [btDropdown setBackgroundImage:[UIImage imageNamed:@"框内按钮2-320.png"] forState:UIControlStateNormal];
    [btDropdown removeTarget:self action:@selector(DropDown) forControlEvents:UIControlEventTouchUpInside];
    [btDropdown addTarget:self action:@selector(DropUp) forControlEvents:UIControlEventTouchUpInside];
}

//隐藏下拉列表
-(void) DropUp
{
    showList = YES;
    [textField resignFirstResponder];//当使用下拉列表时隐藏软键盘
    [self setShowList:NO];
    [btDropdown setBackgroundImage:[UIImage imageNamed:@"框内按钮3-320.png"] forState:UIControlStateNormal];
   // [btDropdown setBackgroundImage:[UIImage imageNamed:@"框内按钮3-320.png"] forState:UIControlStateHighlighted];
    [btDropdown removeTarget:self action:@selector(DropUp) forControlEvents:UIControlEventTouchUpInside];
    [btDropdown addTarget:self action:@selector(DropDown) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark listViewdataSource method and delegate method
-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    //    return ([userLoginInfo count] >> 1);//userLoginInfo数组中是QQ号和密码一一对应，故需要跳过密码,故要除以2
    return [userLoginInfo count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"listviewid";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell==nil){
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellid]autorelease];
    }
    //文本标签
    tmpArray = [userLoginInfo objectAtIndex:indexPath.row];
    //    cell.textLabel.text=(NSString*)[userLoginInfo objectAtIndex:(indexPath.row << 1)];//跳过密码
    cell.textLabel.text = (NSString *)[tmpArray objectAtIndex:3];
    cell.textLabel.font=textField.font;
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    return cell;
}

//设置下拉列表中每项的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return oldFrame.size.height * 1.6;
}

//当选择下拉列表中的一行时，设置文本框中的值，隐藏下拉列表
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    textField.text=(NSString*)[userLoginInfo objectAtIndex:(indexPath.row << 1)];//跳过密码
    //将选中的密码传给代理
    //    [qqNumChangedDelegate DidSelectQQNumfromDropdownlist:(NSString*)[userLoginInfo objectAtIndex:(indexPath.row << 1) + 1]];
    tmpArray = [userLoginInfo objectAtIndex:indexPath.row];
    textField.text = (NSString *)[tmpArray objectAtIndex:3];
    BOOL isRememberPwd = NO;
//    BOOL isAutoLogin = NO;
    if (((NSString *)[tmpArray objectAtIndex:2]).length!=0)
        isRememberPwd = YES;
//    if ([((NSString *)[tmpArray objectAtIndex:3]) isEqualToString:@"1"])
//        isAutoLogin = YES;
//    [qqNumChangedDelegate DidSelectQQNumfromDropdownlist:(NSString*)[tmpArray objectAtIndex:1] isRememberPwd:isRememberPwd isAutoLogin:isAutoLogin];
    [qqNumChangedDelegate DidSelectQQNumfromDropdownlist:(NSString*)[tmpArray objectAtIndex:1] isRememberPwd:isRememberPwd];
    [self DropUp];
}

//定义编辑下拉列表是显示中文的“删除”，默认的是“Delete”
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return @"删除";
}

//点击编辑中的删除时做出相应的操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
       // NSLog(@"indexPath.row  is %d",indexPath.row);
        //        [userLoginInfo removeObjectAtIndex:indexPath.row << 1];  //删除数组中的QQNum,数组前移一位
        //        [userLoginInfo removeObjectAtIndex:indexPath.row << 1];  //删除数组中的QQPwd
        [userLoginInfo removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        //[tableView reloadData];
//        [userLoginInfo writeToFile:[GetFilePath getUserLoginInfoFilePath] atomically:YES];
        NSMutableArray *tmpMyArray = [[NSMutableArray alloc] init];
        //倒序，使得最近使用的数据放在最前端
        for (int i = [userLoginInfo count] - 1; i >= 0; i--) 
        {
            [tmpMyArray addObject:[userLoginInfo objectAtIndex:i]];
        }

        NSArray *nullArray = [[NSArray alloc] initWithObjects:@"",@"",@"",@"", nil];
        [tmpMyArray addObject:nullArray];
        [nullArray release];

        //将修改后的数据写入文件中
       // NSLog(@"tmpMyArray%@",tmpMyArray);
        UserInfoPlistIO *plistIO = [[UserInfoPlistIO alloc] init];
        [plistIO writeToPlistFromArray:tmpMyArray];
        
        
        [tmpMyArray release];
        [plistIO release];
        
        if ([userLoginInfo count] == 0)
        {
            [btDropdown setEnabled:NO];
            //清空账号和密码框中的内容
            [textField setText:@""];
            [qqNumChangedDelegate DidSelectQQNumfromDropdownlist:@"" isRememberPwd:NO];
            [self DropUp];//隐藏下拉列表
        }
        if(indexPath.row==0)
        {
            [textField setText:@""];
            [qqNumChangedDelegate DidSelectQQNumfromDropdownlist:@"" isRememberPwd:NO];
        }
    }
}

#pragma mark UITextField delegate
//开始输入textfield时，此时隐藏下拉列表
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self setShowList:NO];
    
    [btDropdown setBackgroundImage:[UIImage imageNamed:@"框内按钮3-320.png"] forState:UIControlStateNormal];
    [btDropdown removeTarget:self action:@selector(DropUp) forControlEvents:UIControlEventTouchUpInside];
    [btDropdown addTarget:self action:@selector(DropDown) forControlEvents:UIControlEventTouchUpInside];
}

-(BOOL)showList{//setShowList:No为隐藏，setShowList:Yes为显示
    return showList;
}

-(void)setShowList:(BOOL)b{
    showList=b;
    if(showList){
        self.frame=newFrame;
    }else {
        self.frame=oldFrame;
    }
    listView.hidden=!b;
}

//点击Enter的时候隐藏软键盘：
- (BOOL)textFieldShouldReturn:(UITextField *)textfield
{
    [textField resignFirstResponder];
	//[super touchesBegan:touches withEvent:event];
    return YES;
}
- (BOOL)textField:(UITextField *)textFieldn shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{    //QQ号码位数超过10为非法
    //    if ([textField.text length] > 9)
    //    {
    //        [qqNumChangedDelegate QQNumLengthInvalid];
    //        return NO;
    //    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textFieldn
{
    //    //QQ号码以0开始为非法
    //    if([textField.text length] > 1)//保证下面的截取字符串不会溢出
    //    {
    //        if ([[textField.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"])
    //        {
    //            [qqNumChangedDelegate QQNumLengthInvalid];
    //            [textField setText:@""];
    //            return NO;
    //        }
    //    }
    
    //QQ号码位数低于5位为非法
    //    if ([textField.text length] < 5)
    //    {
    //        [qqNumChangedDelegate QQNumLengthInvalid];
    //        [textField setText:@""];
    //    }
    return YES;
}
//点击View的其他区域隐藏软键盘和下拉列表
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hidKeyBoard];
}


//隐藏软键盘
- (void) hidKeyBoard
{
    [textField resignFirstResponder];
    [self DropUp];
}

/*
 
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

- (void)dealloc
{
    [super dealloc];
    [userLoginInfo release];
    [textField release];
    [btDropdown release];

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
   // [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */

- (void)viewDidUnload
{
    //[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end

