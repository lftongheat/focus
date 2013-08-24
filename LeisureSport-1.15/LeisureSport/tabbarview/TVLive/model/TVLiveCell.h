//
//  TVLiveCell.h
//  LeisureSport
//
//  Created by 高 峰 on 12-6-9.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVLiveCell : UITableViewCell
{
    IBOutlet UIImageView *homeTeamImg;
    IBOutlet UIImageView *awayTeamImg;
    IBOutlet UILabel *gameTime;
    IBOutlet UILabel *homeTeamName;
    IBOutlet UILabel *awayTeamName;
    IBOutlet UILabel *isFinished;
    IBOutlet UILabel *liveTVAll;
}

@property(nonatomic, retain) UIImageView *homeTeamImg;
@property(nonatomic, retain) UIImageView *awayTeamImg;
@property(nonatomic, retain) UILabel *gameTime;
@property(nonatomic, retain) UILabel *homeTeamName;
@property(nonatomic, retain) UILabel *awayTeamName;
@property(nonatomic, retain) UILabel *isFinished;
@property(nonatomic, retain) UILabel *liveTVAll;

@end
