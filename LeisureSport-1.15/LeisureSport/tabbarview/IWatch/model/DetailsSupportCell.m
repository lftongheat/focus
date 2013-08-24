//
//  DetailsSupportCell.m
//  LeisureSport
//
//  Created by 高 峰 on 12-7-22.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "QuizChartView.h"
#import "DetailsSupportCell.h"

@implementation DetailsSupportCell
@synthesize supportA;
@synthesize supportB;
@synthesize numberSupportTeamA;
@synthesize numberSupportTeamB;
@synthesize supportTeamAButton;
@synthesize supportTeamBButton;
@synthesize supportButtonDelegate;

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

-(void)dealloc
{
    [super dealloc];
}

-(void) initializeCell:(id<SupportButtonDelegate1>)delegate homeSupport:(NSString *) a awaySupport:(NSString *) b aBegin:(NSString* )begina  bBegin:(NSString* )beginb aNumber:(NSString *) numberOfa bNumber:(NSString *) numberOfb;
{
    self.backgroundColor = [UIColor whiteColor];
    
    supportButtonDelegate = delegate;
    
    UIImageView *bg = [[UIImageView alloc] init];
    bg.frame = CGRectMake(6, 5, 268, 111);
    bg.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"灰色背景-320" ofType:@"png"]];
    [self addSubview:bg];
    [bg release];
    
    supportA = [[UILabel alloc] init];
    supportA.frame = CGRectMake(112, 30, 42, 21);
    supportA.font = [UIFont systemFontOfSize:17.0f];
    //teamARecentPerformance.adjustsFontSizeToFitWidth=YES;
    supportA.backgroundColor = [UIColor clearColor];
    supportA.textAlignment = UITextAlignmentCenter;
    supportA.text = @"支持";
    [self addSubview:supportA];
    [supportA release];
    
    supportB = [[UILabel alloc] init];
    supportB.frame = CGRectMake(112, 70, 42, 21);
    supportB.font = [UIFont systemFontOfSize:17.0f];
    //teamARecentPerformance.adjustsFontSizeToFitWidth=YES;
    supportB.backgroundColor = [UIColor clearColor];
    supportB.textAlignment = UITextAlignmentCenter;
    supportB.text = @"支持";
    [self addSubview:supportB];
    [supportB release];
    
    
    numberSupportTeamA = [[UILabel alloc] init];
    numberSupportTeamA.frame = CGRectMake(156, 30, 42, 21);
    numberSupportTeamA.font = [UIFont systemFontOfSize:17.0f];
    numberSupportTeamA.adjustsFontSizeToFitWidth=YES;
    numberSupportTeamA.backgroundColor = [UIColor clearColor];
    numberSupportTeamA.textAlignment = UITextAlignmentCenter;
    numberSupportTeamA.text = [numberOfa stringByAppendingString:@"人"];
    [self addSubview:numberSupportTeamA];
    [numberSupportTeamA release];
    
    numberSupportTeamB = [[UILabel alloc] init];
    numberSupportTeamB.frame = CGRectMake(156, 71, 42, 21);
    numberSupportTeamB.font = [UIFont systemFontOfSize:17.0f];
    numberSupportTeamB.adjustsFontSizeToFitWidth=YES;
    numberSupportTeamB.backgroundColor = [UIColor clearColor];
    numberSupportTeamB.textAlignment = UITextAlignmentCenter;
    numberSupportTeamB.text = [numberOfb stringByAppendingString:@"人"];
    [self addSubview:numberSupportTeamB];
    [numberSupportTeamB release];
    
    UIImageView *Abg = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"橙色未按" ofType:@"png"]] stretchableImageWithLeftCapWidth:15 topCapHeight:15]];
    Abg.frame = CGRectMake(198, 20, 70, 36);
    [self addSubview:Abg];
    [Abg release];
    
    supportTeamAButton = [[UIButton alloc] init];
    supportTeamAButton.frame = CGRectMake(198, 20, 70, 36);
    supportTeamAButton.backgroundColor = [UIColor clearColor];
    supportTeamAButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [supportTeamAButton setTitle:[a stringByAppendingString:@"%顶主队"] forState:UIControlStateNormal];
    [supportTeamAButton addTarget:self action:@selector(supportHome:) forControlEvents:UIControlEventTouchUpInside];
    [supportTeamAButton setShowsTouchWhenHighlighted:YES];
    [self addSubview:supportTeamAButton];
    [supportTeamAButton release];
    
    UIImageView *Bbg = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"绿色未按" ofType:@"png"]] stretchableImageWithLeftCapWidth:15 topCapHeight:15]];
    Bbg.frame = CGRectMake(198, 64, 70, 36);
    [self addSubview:Bbg];
    [Bbg release];
    
    supportTeamBButton = [[UIButton alloc] init];
    supportTeamBButton.frame = CGRectMake(198, 64, 70, 36);
    supportTeamBButton.backgroundColor = [UIColor clearColor];
    supportTeamBButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [supportTeamBButton setTitle:[b stringByAppendingString:@"%顶客队"] forState:UIControlStateNormal];
    [supportTeamBButton addTarget:self action:@selector(supportAway:) forControlEvents:UIControlEventTouchUpInside];
    [supportTeamBButton setShowsTouchWhenHighlighted:YES];
    [self addSubview:supportTeamBButton];
    [supportTeamBButton release];
    
    
    if([a isEqualToString:begina])
    {
        m_chartView = [[QuizChartView alloc] initWithFrame:CGRectMake(16, 12, 100, 100)];
        m_chartView.backgroundColor = [UIColor clearColor];
        
        m_chartView.m_aPercent = [NSMutableArray arrayWithObjects:b,a,nil];
        UIImageView * circle = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"透明.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
        
        circle.frame = CGRectMake(3.6, 2.9, 92.4, 92.4);
        
        UIImageView *intervalBg = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"间隔条.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
        intervalBg.frame = CGRectMake(49.3, 48.8, 46.2, 1.0);
        
        
        
        [m_chartView addSubview:circle];
        [circle release];
        [m_chartView addSubview:intervalBg];
        [intervalBg release];
        
        [m_chartView removeFromSuperview];
        [self addSubview:m_chartView];
        [m_chartView release];
        
    }else
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = kCFNumberFormatterNoStyle;//取整（默认）
        NSNumber *tempA= [[NSNumber alloc] init];
        NSNumber *tempB= [[NSNumber alloc] init];
        tempA = [formatter numberFromString:begina];
        tempB = [formatter numberFromString:beginb];
        
        initA = [tempA floatValue];
        initB = [tempB floatValue];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.03f target:self selector:@selector(move:) userInfo:nil repeats:YES];
        
        
        //NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSNumber *threadString = [formatter numberFromString:a];
        thread = [threadString floatValue];
        [formatter release];
    }
    
}

- (void) move: (NSTimer *) aTimer
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    m_chartView = [[QuizChartView alloc] initWithFrame:CGRectMake(16, 12, 100, 100)];
	m_chartView.backgroundColor = [UIColor clearColor];
    
    NSNumber *tmpa = [[NSNumber alloc] init];
    tmpa = [NSNumber numberWithInt:initA];
    NSNumber *tmpb = [[NSNumber alloc] init];
    tmpb = [NSNumber numberWithInt:initB];
    NSString *aa= [[NSString alloc] init];
    NSString *bb=[[NSString alloc] init];
    aa= [formatter stringFromNumber:tmpa];
    bb = [formatter stringFromNumber:tmpb];
	m_chartView.m_aPercent = [NSMutableArray arrayWithObjects:bb,aa,nil];
    
    UIImageView * circle = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"透明.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
    
    circle.frame = CGRectMake(3.6, 2.9, 92.4, 92.4);
    
    UIImageView *intervalBg = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"间隔条.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
    intervalBg.frame = CGRectMake(49.3, 48.8, 46.2, 1.0);
    //intervalBg.userInteractionEnabled = YES;
    
    
    [m_chartView addSubview:circle];
    [circle release];
    [m_chartView addSubview:intervalBg];
    [intervalBg release];
    if(thread>50)
    {
        initA++;
        initB--;
        if(initA>=thread+1)
        {
            [timer invalidate];
            timer = nil;
        }
    }else
    {
        initA--;
        initB++;
        if(initA<=thread-1)
        {
            [timer invalidate];
            timer = nil;
        }
    }
    
    
    
    [m_chartView removeFromSuperview];
    [self addSubview:m_chartView];
    [m_chartView release];
    [formatter release];
    
    
    
}



- (void)supportHome:(id)sender {
    [supportButtonDelegate supportAAction];
}

- (void)supportAway:(id)sender {
    [supportButtonDelegate supportBAction];
}

@end
