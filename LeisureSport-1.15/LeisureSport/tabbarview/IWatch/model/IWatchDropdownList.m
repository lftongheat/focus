//
//  IWatchDropdownList.m
//  LeisureSport
//
//  Created by 高 峰 on 12-5-30.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "IWatchDropdownList.h"
#import "LSUtil.h"
//#import "IWatchController.h"

@implementation IWatchDropdownList
//@synthesize textField;
@synthesize dropdownButton;
@synthesize btDropdown;
@synthesize list;
@synthesize listView;
@synthesize lineColor;
@synthesize listBgColor;
@synthesize borderStyle;
@synthesize showList;
@synthesize dropDownTitleChangedDelegate;

-(id) initWithFrame:(CGRect)frame dataInfo:(NSMutableArray *)datainfoparameter initTitle:(NSString *) initTitleparameter Delegate:(id<DropDownTitleChangedDelegate>)delegate
{
    if(self=[super initWithFrame:frame]){
       // dataInfo = datainfoparameter;
        dataInfo = [[NSMutableArray alloc] init];
        //倒序，使得最近使用的数据放在最前端
        for (int i = 0; i <= [datainfoparameter count] - 1; i++) 
        {
            [dataInfo addObject:[datainfoparameter objectAtIndex:i]];
        }
        //        [userLoginInfo retain];
        dropDownTitleChangedDelegate = delegate;
        borderStyle = UITextBorderStyleNone;
        showList=NO; //默认不显示下拉框
        oldFrame=frame; //未下拉时控件初始大小
        //当下拉框显示时，计算出控件的大小，最大为5倍行高
        newFrame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height * 5);
        lineColor=[UIColor lightGrayColor];//默认列表边框线为灰色
        listBgColor=[UIColor colorWithRed:32.0/255.0 green:126.0/255.0 blue:126.0/255.0 alpha:1];
        lineWidth=1;     //默认列表边框粗细为1
        //把背景色设置为透明色，否则会有一个黑色的边
        self.backgroundColor=[UIColor clearColor];
        [self drawView:initTitleparameter];//调用方法，绘制控件
    }
    return self;

}

- (void)drawView:(NSString *) initTitleparameter{

    
    dropdownButton=[[UIButton alloc] initWithFrame:CGRectMake(15, 0,
                                                              oldFrame.size.width - 20, 
                                                              oldFrame.size.height)];
    dropdownButton.tintColor=[UIColor colorWithRed:(90.0/255.0) green:(182.0/255.0) blue:(45.0/255.0) alpha:1];

    [dropdownButton setTitle:initTitleparameter forState:UIControlStateNormal];

    
    [self addSubview:dropdownButton];
    //textField.delegate = self;
    int dataInfoCount = [dataInfo count];
    if (dataInfoCount > 0)
    {
        [dropdownButton setEnabled:YES];
    }

    
    btDropdown = [[UIButton alloc] initWithFrame:CGRectMake(oldFrame.size.width - 20, 10, 20, oldFrame.size.height - 20)];
    btDropdown.tintColor=[UIColor colorWithRed:(90.0/255.0) green:(182.0/255.0) blue:(45.0/255.0) alpha:1];
    [btDropdown setBackgroundImage:[UIImage imageNamed:@"导航栏下小箭头.png"] forState:UIControlStateNormal];
    btDropdown.enabled = NO;

    [self addSubview:btDropdown];
    if (dataInfoCount == 0)
    {
        [dropdownButton setEnabled:NO];
    }
    [dropdownButton addTarget:self action:@selector(DropDown) forControlEvents:UIControlEventTouchUpInside];
   

    
    listView=[[UITableView alloc]initWithFrame:
              CGRectMake(lineWidth - 5,oldFrame.size.height+lineWidth, oldFrame.size.width-lineWidth*2,
                         oldFrame.size.height * 4 - lineWidth*2 )/* (qqNumHeight - 1))*/];

    listView.dataSource=self;
    listView.delegate=self;
    listView.backgroundColor=listBgColor;
    listView.alpha = 0.7;

    listView.separatorColor=lineColor;
    listView.hidden=!showList;//一开始listView是隐藏的，此后根据showList的值显示或隐藏
    [self.listView setEditing:NO animated:YES];
   // [self.listView setEditing:YES animated:YES];//显示编辑按钮
    self.listView.allowsSelectionDuringEditing = YES;
    
    [self addSubview:listView]; 
    [listView release];
}

//弹出下拉列表
-(void)DropDown
{
    //[textField resignFirstResponder];//当使用下拉列表时隐藏软键盘
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
    [btDropdown setBackgroundImage:[UIImage imageNamed:@"导航栏上小箭头.png"] forState:UIControlStateNormal];
    [dropdownButton removeTarget:self action:@selector(DropDown) forControlEvents:UIControlEventTouchUpInside];
    [dropdownButton addTarget:self action:@selector(DropUp) forControlEvents:UIControlEventTouchUpInside];
}

//隐藏下拉列表
-(void) DropUp
{
    showList = YES;
    //[textField resignFirstResponder];//当使用下拉列表时隐藏软键盘
    [self setShowList:NO];
    [btDropdown setBackgroundImage:[UIImage imageNamed:@"导航栏下小箭头.png"] forState:UIControlStateNormal];
    [dropdownButton removeTarget:self action:@selector(DropUp) forControlEvents:UIControlEventTouchUpInside];
    [dropdownButton addTarget:self action:@selector(DropDown) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark listViewdataSource method and delegate method
-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    //    return ([userLoginInfo count] >> 1);//userLoginInfo数组中是QQ号和密码一一对应，故需要跳过密码,故要除以2
    return [dataInfo count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"listviewid";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell==nil){
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellid]autorelease];
    }

    cell.textLabel.text = (NSString *)[dataInfo objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    return cell;
}

//设置下拉列表中每项的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return oldFrame.size.height * 1.0;
}

//当选择下拉列表中的一行时，设置文本框中的值，隐藏下拉列表
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *tmpstr = (NSString *)[dataInfo objectAtIndex:indexPath.row];
    if([tmpstr isEqualToString:@"全部"])
    {
        [dropdownButton setTitle:@"我的关注" forState:UIControlStateNormal];
        [dropDownTitleChangedDelegate setCurrentTitle:@"我的关注"];
        [dropDownTitleChangedDelegate refreshAction];
    }
    else
    {
        [dropdownButton setTitle:tmpstr forState:UIControlStateNormal];
        [dropDownTitleChangedDelegate setCurrentTitle:tmpstr];
        [dropDownTitleChangedDelegate refreshAction];
    }

    [self DropUp];
}


#pragma mark UITextField delegate


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
    return YES;
}
- (BOOL)textField:(UITextField *)textFieldn shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textFieldn
{
    return YES;
}
//点击View的其他区域隐藏软键盘和下拉列表
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[self hidKeyBoard];
}


//隐藏软键盘
- (void) hidKeyBoard
{
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
    
    [dataInfo release];
    //[textField release];
    [list release];
    [btDropdown release];
    //[listView release];
    [dropdownButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
  //  [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
//    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
