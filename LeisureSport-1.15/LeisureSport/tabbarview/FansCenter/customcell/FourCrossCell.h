//
//  FourCrossCell.h 
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-7.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//  关注、粉丝、说说、私信 单元格

#import <UIKit/UIKit.h>

@interface FourCrossCell : UITableViewCell
{
    IBOutlet UIButton *leftupButton;
    IBOutlet UIButton *rightupButton;
    IBOutlet UIButton *leftdownButton;
    IBOutlet UIButton *rightdownButton;
    
    IBOutlet UILabel *followerLabel;
    IBOutlet UILabel *followerNumLabel;
    IBOutlet UILabel *fansLabel;
    IBOutlet UILabel *fansNumLabel;
    IBOutlet UILabel *commentLabel;
    IBOutlet UILabel *commentNumLabel;
    IBOutlet UILabel *messageLabel;
    IBOutlet UILabel *messageNumLabel;
}

@property(nonatomic, retain) UIButton *leftupButton;
@property(nonatomic, retain) UIButton *rightupButton;
@property(nonatomic, retain) UIButton *leftdownButton;
@property(nonatomic, retain) UIButton *rightdownButton;

@property(nonatomic, retain) UILabel *followerLabel;
@property(nonatomic, retain) UILabel *followerNumLabel;
@property(nonatomic, retain) UILabel *fansLabel;
@property(nonatomic, retain) UILabel *fansNumLabel;
@property(nonatomic, retain) UILabel *commentLabel;
@property(nonatomic, retain) UILabel *commentNumLabel;
@property(nonatomic, retain) UILabel *messageLabel;
@property(nonatomic, retain) UILabel *messageNumLabel;

@end
