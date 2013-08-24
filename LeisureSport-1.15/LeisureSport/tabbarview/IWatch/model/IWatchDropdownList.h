//
//  IWatchDropdownList.h
//  LeisureSport
//
//  Created by 高 峰 on 12-5-30.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

@protocol DropDownTitleChangedDelegate;

@interface IWatchDropdownList : UIView  <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIButton *dropdownButton;
    UIButton *btDropdown;     //打开下拉列表  
    NSMutableArray* list;            //下拉列表数据
    BOOL showList;             //是否弹出下拉列表
    UITableView* listView;    //下拉列表
    CGRect oldFrame,newFrame;   //整个控件（包括下拉前和下拉后）的矩形
    UIColor *lineColor,*listBgColor;//下拉框的边框色、背景色
    CGFloat lineWidth;               //下拉框边框粗细
    UITextBorderStyle borderStyle;   //文本框边框style
    NSMutableArray *dataInfo;  //下拉框信息;
    NSArray *tmpArray;  //暂存信息
    id<DropDownTitleChangedDelegate> dropDownTitleChangedDelegate;
    
}
@property (nonatomic,retain)UIButton *dropdownButton;
@property (nonatomic,retain)UIButton *btDropdown;
@property (nonatomic,retain)NSMutableArray* list;
@property (nonatomic,assign)BOOL showList;  
@property (nonatomic,retain)UITableView* listView;
@property (nonatomic,retain)UIColor *lineColor,*listBgColor;
@property (nonatomic,assign)UITextBorderStyle borderStyle;
@property (nonatomic,retain)id<DropDownTitleChangedDelegate> dropDownTitleChangedDelegate; 


-(void) drawView:(NSString *) initTitleparameter;
- (void)setShowList:(BOOL)b;
-(void) DropUp;


//隐藏软键盘，将该功能开放给调用该类的UI控制类


-(id) initWithFrame:(CGRect)frame dataInfo:(NSMutableArray *)datainfoparameter initTitle:(NSString *) initTitleparameter Delegate:(id<DropDownTitleChangedDelegate>)delegate;


@end

@protocol DropDownTitleChangedDelegate 

-(void) refreshAction;
-(void)setCurrentTitle:(NSString *) currentTitle;
@end

