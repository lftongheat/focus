//
//  CommentPublish.m
//  LeisureSport
//
//  Created by 高 峰 on 12-6-17.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "CommentPublish.h"
#import "LSUtil.h"

@implementation CommentPublish
@synthesize commentView,commentPublish,upOrDown;
@synthesize commentDelegate;
@synthesize hide;
@synthesize original;

- (id)initWithFrame:(CGRect)frame  Delegate:(id<CommentDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        hide = YES;
        original = YES;
        
        commentDelegate = delegate;
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
        bg.image = [UIImage imageNamed:@"对话背景5-320.png"];
        
        [self addSubview:bg];
        [bg release];
        commentView = [[UITextView alloc] initWithFrame:CGRectMake(20, 40, 200, 70)];
        commentView.layer.cornerRadius = 6;
        commentView.layer.masksToBounds = YES;
        commentView.font = [UIFont systemFontOfSize:12];
        remindLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        remindLable.textColor = [UIColor lightGrayColor];
        remindLable.text = @"说点什么吧（字数限制140个字）";
        remindLable.font=[UIFont systemFontOfSize:12];
        [commentView addSubview:remindLable];
        [remindLable release];
        commentView.delegate = self;
        commentView.returnKeyType = UIReturnKeyDone;

        upOrDown = [[UIButton alloc] initWithFrame:CGRectMake(140, 0, 50, 35)];
        
        [upOrDown addTarget:self action:@selector(upOrDownAction) forControlEvents:UIControlEventTouchUpInside];
            
        commentPublish = [[UIButton alloc] initWithFrame:CGRectMake(250, 60, 50, 30)];
        UIImage *publishButtonBG = [LSUtil scaleToSize:[UIImage imageNamed:@"发表未按.png"] size:CGSizeMake(50, 40)];
        [commentPublish setBackgroundImage:publishButtonBG forState:UIControlStateNormal];
        [commentPublish setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [commentPublish setTitle:@"发表" forState:UIControlStateNormal];
        [commentPublish addTarget:self action:@selector(commentPublishAction:) forControlEvents:UIControlEventTouchUpInside];
    
            
        [self addSubview:upOrDown];
        [self addSubview:commentPublish];
        [self addSubview:commentView];
        
        [upOrDown release];
        [commentPublish release];
        [commentView release];
        

    }

    return self;
}

-(void) upOrDownAction
{
    if(hide)
    {
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
        bg.image = [UIImage imageNamed:@"对话背景4-320.png"];
        
        [self addSubview:bg];
        [bg release];
    }else
    {
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
        bg.image = [UIImage imageNamed:@"对话背景5-320.png"];
        
        [self addSubview:bg];
        [bg release];
    }
    [self addSubview:upOrDown];
    [self addSubview:commentPublish];
    [self addSubview:commentView];
    
    [commentDelegate changeFrame:hide];
    if(hide)
    {
        hide=NO;
    }else
    {
        hide=YES;
    }
}


-(void) commentPublishAction:(id) sender
{
    if(commentView.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评论内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else
    {
        [self upOrDownAction];
        [commentDelegate publish];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([@"\n" isEqualToString:text] == YES){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [remindLable setHidden:YES];
    [commentDelegate beginFrameChange];
}

-(void) textViewDidChange:(UITextView *)textView
{
    NSInteger number = [textView.text length];
    if(number>140)
    {
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"提示" message:@"字数不能超过140" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        textView.text = [textView.text substringToIndex:10];
        number=10;
        [alert release];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSInteger number = [textView.text length];
    if(number==0)
    {
        [remindLable setHidden:NO];
    }
    [commentDelegate afterFrameChange];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
