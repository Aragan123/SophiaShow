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
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload{

    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    
    [super dealloc];
}

#pragma mark - 
#pragma mark Private Methods
- (void) clickMenuButton: (id) sender{
    int pageNum = [(UIButton*)sender tag];
	NSLog(@"MainPage: button pressed, pagenum=%d", pageNum);
    
	if (delegate != nil) {
		[delegate switchViewTo:pageNum fromView:kPageMain];
	}

}

@end
