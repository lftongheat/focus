//
//  CommentPublish.h
//  LeisureSport
//
//  Created by 高 峰 on 12-6-17.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol CommentDelegate;

@interface CommentPublish : UIView <UITextViewDelegate>
{
    UITextView *commentView;
    UIButton *commentPublish;
    UIButton *upOrDown;
    UILabel *remindLable;
    id<CommentDelegate> dropDownTitleChangedDelegate;
    bool hide;
    bool original;
}
@property (nonatomic,retain) UITextView *commentView;
@property (nonatomic,retain) UIButton *commentPublish;
@property (nonatomic,retain) UIButton *upOrDown;
@property (nonatomic,retain)id<CommentDelegate> commentDelegate; 
@property (nonatomic) bool hide;
@property (nonatomic) bool original;

- (id)initWithFrame:(CGRect)frame  Delegate:(id<CommentDelegate>)delegate;

@end
@protocol CommentDelegate 
-(void) changeFrame:(BOOL) hideParameter;
-(void) publish;
-(void) beginFrameChange;
-(void) afterFrameChange;
@end