//
//  BGViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/03/21.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGViewController.h"

@interface BGViewController ()

@end

@implementation BGViewController
@synthesize delegate, gotoAbout;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // go to About page button
    self.gotoAbout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.gotoAbout.frame = CGRectMake(50, 100, 100, 80);
    [self.gotoAbout addTarget:self action:@selector(clickAboutButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gotoAbout];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload{
    self.gotoAbout=nil;
}

- (void) dealloc{
    delegate=nil;
    [gotoAbout release];
    
    [super dealloc];
}

#pragma mark - 
#pragma mark Private Methods
- (void) clickAboutButton: (id) sender{
//    int pageNum = [(UIButton*)sender tag];
//	NSLog(@"MainPage: button pressed, pagenum=%d", pageNum);
    
	if (delegate != nil) {
		[delegate switchViewTo:kPageAbout fromView:kPageMain];
	}

}

@end
