//
//  SportsNews.h
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-6-8.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SportsNews : NSObject
{
    NSString *GameID;
    NSString *ImageUrl;
    NSString *NewsID;
    NSString *PostTime;
    NSString *ShortIntro;
    NSString *Title;
    NSString *UpdateTime;
    NSString *Url;
}
@property(nonatomic, retain) NSString *GameID;
@property(nonatomic, retain) NSString *ImageUrl;
@property(nonatomic, retain) NSString *NewsID;
@property(nonatomic, retain) NSString *PostTime;
@property(nonatomic, retain) NSString *ShortIntro;
@property(nonatomic, retain) NSString *Title;
@property(nonatomic, retain) NSString *UpdateTime;
@property(nonatomic, retain) NSString *Url;

@end
