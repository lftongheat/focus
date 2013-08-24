//
//  DetailsCommentCustomCell.h
//  LeisureSport
//
//  Created by 高 峰 on 12-6-5.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UserIDDelegate;

@interface DetailsCommentCustomCell : UITableViewCell
{
    IBOutlet UILabel *name;
    IBOutlet UILabel *comment;
    IBOutlet UILabel *commentTime;
    IBOutlet UIButton *imageButton;
    NSString *userID;
    
    id<UserIDDelegate> userIDDelegate;
}


@property (assign) UILabel *name;
@property (assign) UILabel *comment;
@property (assign) UILabel *commentTime;
@property (assign) UIButton *imageButton;
@property (nonatomic,retain) NSString *userID;
@property (nonatomic,retain)id<UserIDDelegate> userIDDelegate;


-(void) initializeCell:(id<UserIDDelegate>)delegate;
- (IBAction)clickImage:(id)sender;


@end

@protocol UserIDDelegate 

-(void) jumpPersonal:(NSString *) userIDParamenter;
@end
