//
//  CheckBox.m
//  QQMJ_IOS
//
//  Created by Ashrum on 11-10-27.
//  Copyright 2011年 Harbin University of Technology. All rights reserved.
//

#import "CheckBox.h"


@implementation CheckBox
@synthesize isChecked;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentLeft;		
		[self setImage:[UIImage imageNamed:@"打钩框.png"] forState:UIControlStateNormal];
		[self addTarget:self action:@selector(checkBoxClicked) forControlEvents:UIControlEventTouchUpInside];
	}
    return self;
}

-(void)setTarget:(id)tar fun:(SEL)ff
{
	target=tar;
	fun=ff;
}
-(void)setIsChecked:(BOOL)check
{   
	isChecked=check;
	if (check) {
		[self setImage:[UIImage imageNamed:@"打钩.png"] forState:UIControlStateNormal];
		
	}
	else {
		[self setImage:[UIImage imageNamed:@"打钩框.png"] forState:UIControlStateNormal];
	}
}

-(IBAction) checkBoxClicked
{
	if(self.isChecked ==NO){
		self.isChecked =YES;
		[self setImage:[UIImage imageNamed:@"打钩.png"] forState:UIControlStateNormal];
		
	}else{
		self.isChecked =NO;
		[self setImage:[UIImage imageNamed:@"打钩框.png"] forState:UIControlStateNormal];
		
	}
	[target performSelector:fun];
}

- (void)dealloc {
	target=nil;
    [super dealloc];
}


@end
