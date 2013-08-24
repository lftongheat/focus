//
//  IWatchViewController.h
//  DelightSports
//
//  Created by ACE ; on 12-5-18.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWatchDropdownList.h"
#import "LeisureSportAppDelegate.h"
#import "MBProgressHUD.h"

@interface IWatchController : UITableViewController <UITableViewDelegate ,UITableViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,MBProgressHUDDelegate>
{
    UILabel *dateUilabel;//日期显示
    UIView *dateUiview;//日期控件
    
    UIView *title;//导航栏title控件
    UIButton *dropDownListButton;//下拉框按钮
    UIButton *pointButton;//三角指示按钮
    IWatchDropdownList *dropDownList;//下拉框
    UISegmentedControl *segmentedContorller;//分段按钮
    
    UITableView * iWatchTableView;//主要tableview
    
    NSInteger segmentedNumber;//当前分段按钮选项
    
    NSMutableArray *iWatchDropDownArray;//下拉框数据
    NSMutableArray *iWatchTableArray;//主要tableview数据
    
    NSString *dropDownInitTitle;//下拉框初始化内容
    NSString *dropDownInitTitle0;//记录热点赛事当前内容
    NSString *dropDownInitTitle1;//记录关注联赛当前内容
    NSString *dropDownInitTitle2;//记录关注球队当前内容
    
    NSString *date;
    
    NSMutableString *usrID;//用户ID
    
    NSMutableDictionary *dictionary;//字典，记录赛事类属个数、名称，以及每类有多少场次
    
    
    NSMutableArray *leagueArray;//关注联赛数据
    
    NSMutableArray *favorLeagueArray;   //关注的联赛
    MBProgressHUD *HUD;    
    MBProgressHUD *HUDforRefresh;
    BOOL islogined; 

}

@property (nonatomic,retain)UILabel *dateUilabel;
@property (nonatomic,retain)UIView *dateUiview;
@property (nonatomic,retain)UIView *title;
@property (nonatomic,retain)UIButton *dropDownListButton;
@property (nonatomic,retain)UIButton *pointButton;
@property (nonatomic,retain)UISegmentedControl *segmentedContorller;
@property (nonatomic)NSInteger segmentedNumber;
@property (nonatomic,retain)  NSMutableArray *iWatchDropDownArray;
@property (nonatomic,retain) NSMutableArray *iWatchTableArray;

@property (nonatomic,retain)NSString *dropDownInitTitle;
@property (nonatomic,retain)NSString *dropDownInitTitle0;
@property (nonatomic,retain)NSString *dropDownInitTitle1;
@property (nonatomic,retain)NSString *dropDownInitTitle2;
@property (nonatomic,retain)NSString *date;
@property (nonatomic,retain)NSMutableString *usrID;

@property (nonatomic,retain)NSMutableArray *favorLeagueArray; 
@property (nonatomic,retain)NSMutableArray *leagueArray;

- (id) initWithFrame:(LS_IWatchSelectedController)selected;//初始化，参数为所选择分段按钮
-(void) refreshAction;//以当前日起、下拉框内容以及分段按钮内容刷新当前
-(void) refreshAction_NoNeedInDropDown;//以当前日起、下拉框内容以及分段按钮内容刷新当前不需要更新下拉框内容
- (void) segmentAction:(UISegmentedControl *) sender;//分段按钮事件
- (void) showDateOfToday:(id)sender;//显示当前日期
- (void) showNextDateOfCurrent:(id)sender;//显示下一天日期
- (void) showPreviousDateOfCurrent:(id)sender;//显示上一天日期
-(void)setCurrentTitle:(NSString *) currentTitle;

@end
