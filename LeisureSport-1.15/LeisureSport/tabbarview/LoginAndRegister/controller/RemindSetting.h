//
//  RemindSetting.h
//  LeisureSport
//
//  Created by 高 峰 on 12-6-25.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckBox.h"

@interface RemindSetting : UIViewController
{
    UISwitch *mySwitch;//是否开启提醒
    
    UIImageView *switchBg;//背景
    UIImageView *switchOffBg;
    UIImageView *switchOnBg;
    
    CheckBox *ringCheckBox;//是否开启铃声
    CheckBox *vibrateCheckBox;//是否开启震动
    
    CheckBox *footballCheckBox;//是否开启足球提示
    CheckBox *basketballCheckBox;//是否开启篮球提示
}
@end
