//
//  QuizChartViewController.h
//  QuizChart
//
//  Created by Lionel Cui on 11-6-16.
//  Copyright 2011 vlion soft studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuizChartView : UIView 
{
	NSMutableArray* m_aPercent;
	NSMutableArray* m_aHint;

	CGPoint m_charCenter;
	CGRect m_charRect;
	CGRect m_hintRect;
	float m_r;
	float m_sperate;
}
@property(nonatomic,retain)NSMutableArray* m_aPercent;
@property(nonatomic,retain)NSMutableArray* m_aHint;
@end

