//
//  BGSwitchViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/03/22.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGSwitchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BGViewController.h"
#import "BGAboutViewController.h"
#import "BGGalleryHomeViewController.h"
#import "BGGalleryViewController.h"

@interface BGSwitchViewController ()

@end

@implementation BGSwitchViewController
@synthesize homePageViewController, aboutPageViewController, galleryHomePageViewController, galleryPageViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    BGViewController *mainview = [[BGViewController alloc] initWithNibName:@"BGViewController" bundle:nil];
    self.homePageViewController = mainview;
    self.homePageViewController.delegate=self;
    [mainview release];
    
    [self.view insertSubview: self.homePageViewController.view atIndex:0];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow landscape orientation only.
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.homePageViewController.view.superview==nil) {
        self.homePageViewController=nil;
    }
    if (self.aboutPageViewController.view.superview==nil) {
        self.aboutPageViewController=nil;
    }
    if (self.galleryHomePageViewController.view.superview==nil) {
        self.galleryHomePageViewController=nil;
    }
    if (self.galleryPageViewController.view.superview==nil) {
        self.galleryPageViewController=nil;
    }
}

- (void) viewDidUnload{
    self.homePageViewController=nil;
    self.aboutPageViewController=nil;
    self.galleryHomePageViewController=nil;
    self.galleryPageViewController=nil;
    
    [super viewDidUnload];
}

- (void) dealloc{
    [homePageViewController release];
    [aboutPageViewController release];
    [galleryHomePageViewController release];
    [galleryPageViewController release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark PageSwitcher delegate Functons
-(void) switchViewTo: (int)toPage fromView:(int)fromPage  {
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.55f];
    [animation setType:kCATransitionReveal];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
	// set different transition types
	if (toPage > fromPage) {
        [animation setSubtype:kCATransitionFromTop];
	}else {
        [animation setSubtype:kCATransitionFromBottom];
	}
    
    if (toPage == kPageMain) {
        NSLog(@"toPage = MainPage");
        
        if (self.homePageViewController == nil) {
            BGViewController *controller = [[BGViewController alloc] initWithNibName:@"BGViewController" bundle:nil];
            self.homePageViewController = controller;
            [controller release];
        }
        self.homePageViewController.delegate = self;
    }
    
    else if (toPage == kPageAbout) {
        NSLog(@"toPage = AboutPage");
        
        if (self.aboutPageViewController == nil) {
            BGAboutViewController *controller = [[BGAboutViewController alloc] initWithNibName:@"BGAboutViewController" bundle:nil];
            self.aboutPageViewController = controller;
            [controller release];
        }
        self.aboutPageViewController.delegate = self;
    }
    
    else if (toPage == kPageGalleryHome) {
        NSLog(@"toPage = GalleryHomePage");
        
        if (self.galleryHomePageViewController == nil) {
            BGGalleryHomeViewController *controller = [[BGGalleryHomeViewController alloc] initWithNibName:@"BGGalleryHomeViewController" bundle:nil];
            self.galleryHomePageViewController = controller;
            [controller release];
        }
        
        self.galleryHomePageViewController.delegate = self;
        [self.galleryHomePageViewController loadDataSource:NO];
    }
    
    else if (toPage == kPageGallery) {
        NSLog(@"toPage = Gallery Page");
        
        if (self.galleryPageViewController.view.superview == nil) {
            BGGalleryViewController *controller = [[BGGalleryViewController alloc] initWithNibName:@"BGGalleryHomeViewController" bundle:nil isOnlineGallery:NO];
            self.galleryPageViewController = controller;
            [controller release];
        }
        
        self.galleryPageViewController.delegate = self;
    }
    
    // get from and to view controller
	UIViewController *fromViewController = [self getSwitchViewController:fromPage];
	UIViewController *toViewController = [self getSwitchViewController:toPage];
    
	// show views
	[fromViewController	viewWillDisappear:YES];
	[toViewController viewWillAppear:YES];
	
	[fromViewController.view removeFromSuperview];
	[self.view insertSubview:toViewController.view atIndex:0];
	
	[fromViewController viewDidDisappear:YES];
	[toViewController viewDidAppear:YES];
    
	// commit animation
    [self.view.layer addAnimation:animation forKey:@"Switch View Animation"];

}

#pragma mark -
#pragma mark Methods
-(UIViewController *) getSwitchViewController: (int) pageNum{
	switch (pageNum) {
		case kPageMain:
			return self.homePageViewController;
			break;
			
		case kPageGalleryHome:
        case kPageOnlineGalleryHome:
			return self.galleryHomePageViewController;
			break;
            
		case kPageGallery:
        case kPageOnlineGallery:
			return self.galleryPageViewController;
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
