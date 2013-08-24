//
//  QuizChartViewController.m
//  QuizChart
//
//  Created by Lionel Cui on 11-6-16.
//  Copyright 2011 vlion soft studio. All rights reserved.
//

#import "QuizChartView.h"


static int color[2][3] = 
{
//    {0x00,0xff,0x00},
    {0x37,0xc3,0x00},
    {0xff,0x75,0x1b}
//	{0xff,0x00,0x00}
    
//	{0x6f,0x42,0x42},
	
//	{0x00,0x00,0xff},
//	{0xff,0x00,0xff},
//	{0xcd,0x7f,0x32},
//	{0xff,0xff,0x00},
//	{0xf0,0xf8,0xff},
//	{0xb8,0x73,0x33},
//	{0x5c,0x33,0x17}
};

@implementation QuizChartView
@synthesize m_aPercent;
@synthesize m_aHint;

-(id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self)
	{
		m_sperate = 1.0;
		CGRectDivide(self.bounds, &m_charRect, &m_hintRect, frame.size.width * m_sperate, CGRectMinXEdge);
		m_charCenter = CGPointMake(CGRectGetMidX(m_charRect), CGRectGetMidY(m_charRect));
		m_r = MIN(m_charCenter.x-5, m_charCenter.y-5);
	}
	return self;
}
//void CGContextSetPaintColor(CGContextRef context, int r, int g, int b, float alp)
//{
//	CGContextSetRGBFillColor(context, (float)((float)r/(float)255), (float)((float)g/(float)255), (float)((float)b/(float)255), alp);
//}
-(void)drawChart:(CGContextRef)ref
{
	float startAngle = 0;
	for(int i=0; i<[m_aPercent count]; i++)
	{
		NSString* spercent = [m_aPercent objectAtIndex:i];
		float fpercent = [spercent intValue] * 0.01;
		CGContextMoveToPoint(ref, m_charCenter.x, m_charCenter.y);
		int red = color[i][0];
		int green = color[i][1];
		int blue = color[i][2];
		//CGContextSetPaintColor(ref, red, green, blue, 1);
        
        CGContextSetRGBFillColor(ref, (float)((float)red/(float)255), (float)((float)green/(float)255), (float)((float)blue/(float)255), 1);
        
		CGContextAddArc(ref, m_charCenter.x, m_charCenter.y, m_r, startAngle, startAngle + 2*M_PI*fpercent, 0);
		CGContextClosePath(ref);
		CGContextFillPath(ref);
		startAngle = startAngle + 2*M_PI*fpercent;
	}
}
-(void)drawHint:(CGContextRef)ref
{
//	for(int i=0; i<[m_aPercent count]; i++)
//	{
//		NSString* value = [m_aHint objectAtIndex:i];
//		int red = color[i][0];
//		int green = color[i][1];
//		int blue = color[i][2];
//		CGContextSetPaintColor(ref, red, green, blue, 1);
//		CGRect rct = CGRectMake(CGRectGetMinX(m_hintRect), CGRectGetMinY(m_hintRect)+10+25*i, 30, 20);
//		CGContextFillRect(ref,rct);
//		[value drawAtPoint:CGPointMake(CGRectGetMaxX(rct), CGRectGetMinY(rct)) forWidth:50 withFont:[UIFont systemFontOfSize:15]
//			 lineBreakMode:UILineBreakModeCharacterWrap];
//	}
}
- (void)drawRect:(CGRect)rect
{
	CGContextRef ref = UIGraphicsGetCurrentContext();
	[self drawChart:ref];
	//[self drawHint:ref];
}
- (void)dealloc {
	[m_aPercent release];
	[m_aHint release];
    [super dealloc];
}

@end
