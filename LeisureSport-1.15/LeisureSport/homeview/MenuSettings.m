//
//  MenuSettings.m
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-5-23.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "MenuSettings.h"

@implementation MenuSettings

@synthesize cellSize;
@synthesize cellSpacing;
@synthesize marginToTop;
@synthesize marginToSide;
@synthesize cellNumOfView;


- (id) initWithMarginTop: (int)marginTop AndCellNum: (int) num
{
    if (self = [super init]) {
        cellSize = 50;
        marginToTop = marginTop;
        marginToSide = 20;
        cellNumOfView = num;
        cellSpacing = (320-cellSize*4-marginToSide*2)/(4-1);
    }
    return self;
}

@end
