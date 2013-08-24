//
//  CheckBox.h
//  QQMJ_IOS
//
//  Created by Ashrum on 11-10-27.
//  Copyright 2011年 Harbin University of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CheckBox : UIButton {
	BOOL isChecked;
	id target;
	SEL fun;
}
@property (nonatomic,assign) BOOL isChecked;

-(IBAction) checkBoxClicked;
-(void)setTarget:(id)tar fun:(SEL )ff;
@end