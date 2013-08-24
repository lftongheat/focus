//
//  SportsNews.m
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-8.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "SportsNews.h"

@implementation SportsNews
@synthesize GameID, ImageUrl, NewsID, PostTime, ShortIntro, Title, UpdateTime, Url;

-(void)dealloc
{
    [GameID release];
    [ImageUrl release];
    [NewsID release];
    [PostTime release];
    [ShortIntro release];
    [Title release];
    [UpdateTime release];
    [Url release];
    
    [super dealloc];
}
@end
