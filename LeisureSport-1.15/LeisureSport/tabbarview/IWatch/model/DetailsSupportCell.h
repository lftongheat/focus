//
//  DetailsSupportCell.h
//  LeisureSport
//
//  Created by 高 峰 on 12-7-22.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizChartView.h"
@protocol SupportButtonDelegate1;

@interface DetailsSupportCell : UIView
{
    UILabel *supportA;
    UILabel *supportB;
    
    UILabel *numberSupportTeamA;
    UILabel *numberSupportTeamB;
    
    UIButton *supportTeamAButton;
    UIButton *supportTeamBButton;
    
    
    
    id<SupportButtonDelegate1> supportButtonDelegate;
    
    QuizChartView *m_chartView;
    
    NSTimer *timer;
    float initA;
    float initB;
    float thread;
}

@property (assign) UILabel *supportA;
@property (assign) UILabel *supportB;
@property (assign) UILabel *numberSupportTeamA;
@property (assign) UILabel *numberSupportTeamB;
@property (assign) UIButton *supportTeamAButton;
@property (assign) UIButton *supportTeamBButton;
@property (nonatomic,retain)id<SupportButtonDelegate1> supportButtonDelegate;

-(void) initializeCell:(id<SupportButtonDelegate1>)delegate homeSupport:(NSString *) a awaySupport:(NSString *) b aBegin:(NSString* )begina  bBegin:(NSString* )beginb aNumber:(NSString *) numberOfa bNumber:(NSString *) numberOfb;
//-(void) initializeCellNotFirst:(id<SupportButtonDelegate>)delegate homeSupport:(NSString *) a awaySupport:(NSString *) b;
- (IBAction)supportHome:(id)sender;
- (IBAction)supportAway:(id)sender;


@end

@protocol SupportButtonDelegate1 

-(void) supportAAction;
-(void) supportBAction;
@end
