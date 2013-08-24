//
//  LSUtil.h
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-5-24.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

//淡绿色背景图 已拉伸
#define PALEGREEN_BG_VIEW [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"淡绿色背景" ofType:@"png"]] stretchableImageWithLeftCapWidth:15 topCapHeight:15]]

#define PALEGREEN_BG_VIEW_AUTORELEASE [[[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"淡绿色背景" ofType:@"png"]] stretchableImageWithLeftCapWidth:15 topCapHeight:15]] autorelease]
//灰色背景图 已拉伸
#define GRAY_BG_VIEW [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"灰色背景" ofType:@"png"]] stretchableImageWithLeftCapWidth:15 topCapHeight:15]]
#define GRAY_BG_VIEW_AUTORELEASE [[[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"灰色背景" ofType:@"png"]] stretchableImageWithLeftCapWidth:15 topCapHeight:15]] autorelease]

//灰色背景 已拉伸
#define GRAY_BG_IMAGE [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"灰色背景" ofType:@"png"]] stretchableImageWithLeftCapWidth:15 topCapHeight:15]
//输入框
#define INPUT_BG_IMAGE [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"输入框" ofType:@"png"]] stretchableImageWithLeftCapWidth:15 topCapHeight:15]

//绿色背景图
#define GREEN_BG_IMAGE [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"greenbg" ofType:@"png"]]
//内部的边界框背景
#define INNER_BG_VIEW [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"内部背景" ofType:@"png"]]]
#define INNER_BG_VIEW_AUTORELEASE [[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"内部背景" ofType:@"png"]]] autorelease]


//返回UIIMAGE
#define IMAGEWITHCONTENTSOFFILE(IMAGENAME) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:IMAGENAME ofType:@"png"]]

//返回图片的服务器URL
#define IMAGE_URL(IMAGEID) [NSURL URLWithString: [NSString stringWithFormat:@"http://113.106.89.74:8081/leisuresport/image.aspx?id=%@", IMAGEID]]

//日期背景灰色框
#define DATE_BG_VIEW [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"日期背景灰色框.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15]]
//间隔条
#define INTERVAL_BG_VIEW [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"间隔条.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15]]

//tags
#define ACTIVITY_TAG 501
#define MORE_LABEL_TAG 502

@interface LSUtil : NSObject

//检查网络状态
+ (BOOL) connectedToNetwork;
//根据imgaeID从服务器获取图片
+ (UIImage *)fetchImage: (NSString *)imageID;
//上传头像到服务器
+ (BOOL)uploadImage:(UIImage*)image UserID: (NSString *)userID;
//获取当前时间
+ (NSString *)now;
+ (NSString *)today;

//修改图片大小
+ (UIImage*)scaleToSize: (UIImage*)img size:(CGSize)size;
@end
