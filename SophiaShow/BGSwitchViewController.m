//
//  BGSwitchViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/03/22.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGSwitchViewController.h"
#import "BGViewController.h"
#import "BGAboutViewController.h"

@interface BGSwitchViewController ()

@end

@implementation BGSwitchViewController
@synthesize mainPageViewController, aboutPageViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    BGViewController *mainview = [[BGViewController alloc] initWithNibName:@"BGViewController" bundle:nil];
    self.mainPageViewController = mainview;
    self.mainPageViewController.delegate=self;
    [mainview release];
    
    [self.view insertSubview: mainPageViewController.view atIndex:0];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow landscape orientation only.
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.mainPageViewController.view.subviews==nil) {
        self.mainPageViewController=nil;
    }
    if (self.aboutPageViewController.view.subviews==nil) {
        self.aboutPageViewController=nil;
    }
}

- (void) viewDidUnload{
    self.mainPageViewController=nil;
    self.aboutPageViewController=nil;
}

- (void) dealloc{
    [mainPageViewController release];
    [aboutPageViewController release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark PageSwitcher delegate Functons
-(void) switchViewTo: (int)toPage fromView:(int)fromPage  {
	[UIView beginAnimations:@"PageSwitch" context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	// set different transition types
	if (toPage > fromPage) {
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
	}else {
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
	}
    
    if (toPage == kPageMain) {
        NSLog(@"toPage = MainPage");
        
        if (self.mainPageViewController == nil) {
            BGViewController *controller = [[BGViewController alloc] initWithNibName:@"BGViewController" bundle:nil];
            self.mainPageViewController = controller;
            [controller release];
        }
        self.mainPageViewController.delegate = self;
    }
    
    else if (toPage == kPageAbout) {
        NSLog(@"toPage = AboutPage");
        
        if (self.aboutPageViewController == nil) {
            BGAboutViewController *controller = [[BGAboutViewController alloc] initWithNibName:@"BGAboutViewController" bundle:nil];
            self.aboutPageViewController = controller;
            [controller release];
        }
//        self.aboutPageViewController.delegate = self;
    }
    
    
    // get from and to view controller
	UIViewController *fromViewController = [self getSwitchViewController:fromPage];
	UIViewController *toViewController = [self getSwitchViewController:toPage];
    
	// show views
	[fromViewController	viewWillDisappear:YES];
	[toViewController viewWillAppear:YES];
	
	[fromViewController.view removeFromSuperview];
//	[self.view addSubview:toViewController.view];
	[self.view insertSubview:toViewController.view atIndex:0];
	
	[fromViewController viewDidDisappear:YES];
	[toViewController viewDidAppear:YES];
    
	// commit animation
	[UIView commitAnimations];

}

#pragma mark -
#pragma mark Methods
-(UIViewController *) getSwitchViewController: (int) pageNum{
	switch (pageNum) {
		case kPageMain:
			return self.mainPageViewController;
			break;
			
		case kPageGalleryHome:
//			return self.galleryHomePageViewController;
			break;
            
		case kPageGallery:
//			return self.galleryPageViewController;
			break;
            
        case kPageAbout:
            return self.aboutPageViewController;
            break;
            
        case kPageUI:
            // return self.uiPageViewController;
            break;
	}
	return nil;
}

@end
