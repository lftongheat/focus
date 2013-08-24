//
//  FourCrossCell.m
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-7.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "FourCrossCell.h"

@implementation FourCrossCell
@synthesize leftupButton,leftdownButton,rightupButton,rightdownButton;
@synthesize followerLabel, followerNumLabel;
@synthesize fansLabel, fansNumLabel;
@synthesize commentLabel, commentNumLabel;
@synthesize messageLabel, messageNumLabel;

-(void)dealloc
{
    [leftupButton release];
    [rightupButton release];
    [leftdownButton release];
    [rightdownButton release];
    
    [followerLabel release];
    [followerNumLabel release];
    [fansLabel release];
    [fansNumLabel release];
    [commentLabel release];
    [commentNumLabel release];
    [messageLabel release];
    [messageNumLabel release];
    
    [super dealloc];
}
@end
