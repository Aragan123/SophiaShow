//
//  BGViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/03/21.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGViewController.h"
#import "BGSplashViewController.h"

@interface BGViewController ()

@end

@implementation BGViewController
@synthesize delegate, splashVc;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
//    self.splashVc = [[BGSplashViewController alloc] initWithNibName:@"BGSplashViewController" bundle:nil];
//    self.splashVc.view.frame = self.view.frame;
//    [self.view addSubview:self.splashVc.view];
//    [self.view bringSubviewToFront:self.splashVc.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload{
    splashVc=nil;
    
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    [splashVc release];
    
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
