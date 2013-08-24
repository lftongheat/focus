//
//  MatchDetails.h
//  LeisureSport
//
//  Created by 高 峰 on 12-6-1.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//
#import "DetailInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "CommentPublish.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"


@interface MatchDetailsConrroller : UIViewController<EGORefreshTableHeaderDelegate,UITableViewDelegate ,UITableViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIWebViewDelegate,MBProgressHUDDelegate>
{
    UIView *topView;//背景
    UIView *bottomView;
    
    UISegmentedControl *detailsSementedControl;//分段按钮
    UITableView *detailsTableView;//主要tableview
    UIWebView *webView;//赛况新闻

    
    NSInteger segmentedNumber;//当前分段按钮选项
    NSString *currentGameID;//当前比赛ID
    NSMutableArray *detailArray;//主要tableview数据
    DetailInfo *currentGameDetail;//初始化赛事详情参数
    CommentPublish *comment;//评论控件
    
    UIImageView *bottomBg;//背景
    
    EGORefreshTableHeaderView *_refreshHeaderView;//下拉刷新
    BOOL _reloading;
    
   // MoreCell *loadMoreCell;//加载更多
    
    NSMutableString *usrID;

    MBProgressHUD *HUD;
    int Anamation_FiratTime;//
    NSString *LastA;//记录百分比动画的开始百分比
    NSString *lastB;
    int isfIRST;
    
    NSMutableArray *tmpArray;

    MBProgressHUD *HUDforPublish;
}
@property(nonatomic) NSInteger segmentedNumber;
@property(nonatomic,retain) UIView *topView;
@property(nonatomic,retain) UIView *bottomView;
@property(nonatomic,retain) UISegmentedControl *detailsSementedControl;
@property(nonatomic,retain) UITableView *detailsTableView;

@property(nonatomic,retain) UIWebView *webView;
@property(nonatomic,retain) NSString *currentGameID;
@property(nonatomic,retain) NSMutableArray *detailArray;
@property(nonatomic,retain) DetailInfo *currentGameDetail;
@property(nonatomic,retain) CommentPublish *comment;
@property(nonatomic,retain) UIImageView *bottomBg;
- (id) initWithFrame:(NSInteger)selected gameID:(NSString *)gameid;

-(void) refreshAction;
-(void) supportAAction;
-(void) supportBAction;
-(void) jumpPersonal:(NSString *) userIDParamenter;
-(void)requestData;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
