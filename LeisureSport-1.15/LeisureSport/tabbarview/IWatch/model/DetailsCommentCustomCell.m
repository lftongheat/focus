//
//  DetailsCommentCustomCell.m
//  LeisureSport
//
//  Created by 高 峰 on 12-6-5.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "DetailsCommentCustomCell.h"

@implementation DetailsCommentCustomCell

@synthesize name;
@synthesize comment;
@synthesize commentTime;
@synthesize userID;
@synthesize imageButton;
@synthesize userIDDelegate;

-(void)dealloc
{
//    [name release];
//    [comment release];
//    [commentTime release];
//    [userID release];
//    [imageButton release];
}

-(void) initializeCell:(id<UserIDDelegate>)delegate
{
    userIDDelegate = delegate;
}

- (IBAction)clickImage:(id)sender {
    [userIDDelegate jumpPersonal:userID];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
