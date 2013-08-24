//
//  NewsViewController.m
//  LeisureSport
//
//  Created by ACE hitsz302 on 12-7-13.
//  Copyright (c) 2012年 Harbin University of Technology. All rights reserved.
//

#import "NewsViewController.h"
#import "LSUtil.h"

@implementation NewsViewController
@synthesize urlStr;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460-44-48)];
    view.backgroundColor = [UIColor colorWithPatternImage:GREEN_BG_IMAGE];    
	self.view=view;
	[view release];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 368)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"怡情体育";
    
    //添加左导航键
    UIButton * backButton=[UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"返回按钮按下.png"] forState:UIControlStateHighlighted];
	[backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	backButton.frame=CGRectMake(3,3, 48, 30);
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = back;
    [back release];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 368)];
    [webView setBackgroundColor:[UIColor clearColor]];
    [webView setDelegate:self];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
    [self.view addSubview:webView];
    [webView release];
}

//返回
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
- (void)dealloc
{
    NSLog(@"NewsVC--dealloc");
    [super dealloc];
}
*/

#pragma mark -
#pragma mark UIWebViewDelegate methods
- (void)webViewDidStartLoad:(UIWebView *)webView{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.delegate = self;
	[HUD show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{ 
    [HUD hide:YES];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}

@end
