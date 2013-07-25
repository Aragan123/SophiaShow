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
#import "BGHomeViewController.h"
#import "BGAboutViewController.h"
#import "BGGalleryHomeViewController.h"
#import "BGGalleryViewController.h"
#import "BGReflectionViewController.h"
#import "BGImageFilterViewController.h"
#import "SVProgressHUD.h"

@interface BGSwitchViewController ()

@end

@implementation BGSwitchViewController
@synthesize homePageViewController, aboutPageViewController, galleryHomePageViewController, galleryPageViewController, reflectionViewController, imageFilterViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    BGViewController *mainview = [[BGViewController alloc] initWithNibName:@"BGViewController" bundle:nil];
    BGHomeViewController *mainview = [[BGHomeViewController alloc] initWithNibName:@"BGHomeViewController" bundle:nil fromScene:kPageMain];
    
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
    if (self.reflectionViewController.view.superview==nil) {
        self.reflectionViewController=nil;
    }
    if (self.imageFilterViewController.view.superview==nil) {
        self.imageFilterViewController=nil;
    }
}

- (void) viewDidUnload{
    self.homePageViewController=nil;
    self.aboutPageViewController=nil;
    self.galleryHomePageViewController=nil;
    self.galleryPageViewController=nil;
    self.reflectionViewController=nil;
    self.imageFilterViewController=nil;
    
    [super viewDidUnload];
}

- (void) dealloc{
    [homePageViewController release];
    [aboutPageViewController release];
    [galleryHomePageViewController release];
    [galleryPageViewController release];
    [reflectionViewController release];
    [imageFilterViewController release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark PageSwitcher delegate Functons
-(void) switchViewTo: (int)toPage fromView:(int)fromPage  {
    // show HUD first, has to use like this to be async, rest works has to start after HUD is displayed
    [UIView animateWithDuration:0.0f animations:^{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    } completion:^(BOOL finished) {
        
        /*
          Perform transition between view controllers
         */
        [self prepareViewController:toPage fromView:fromPage];
        // get from and to view controller
        UIViewController *fromViewController = [self getSwitchViewController:fromPage];
        UIViewController *toViewController = [self getSwitchViewController:toPage];

        // special transitions
        if (fromPage == kPageUI || toPage == kPageUI) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.55f];
            if (toPage > fromPage) {
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:NO];
            }else{
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:NO];
            }
            
            // show views
            [fromViewController	viewWillDisappear:YES];
            [toViewController viewWillAppear:YES];
            
            [fromViewController.view removeFromSuperview];
            [self.view insertSubview:toViewController.view atIndex:0];
            
            [fromViewController viewDidDisappear:YES];
            [toViewController viewDidAppear:YES];
            
            [UIView commitAnimations];
        }
        else{
            
            // others use general transition
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
                    
            // show views
            [fromViewController	viewWillDisappear:YES];
            [toViewController viewWillAppear:YES];
            
            [fromViewController.view removeFromSuperview];
            [self.view insertSubview:toViewController.view atIndex:0];
            
            [fromViewController viewDidDisappear:YES];
//            [toViewController viewDidAppear:YES];

            // commit animation
            [self.view.layer addAnimation:animation forKey:@"Switch View Animation"];

        }
        
        // finally dismiss HUD
        [SVProgressHUD dismiss];
    }];
}

#pragma mark -
#pragma mark Methods
- (void) prepareViewController: (int) toPage fromView:(int)fromePage{
    if (toPage == kPageMain || toPage == kPageGalleryHome) {
        NSLog(@"toPage = MainPage");
        
        if (self.homePageViewController == nil) {
//            BGViewController *controller = [[BGViewController alloc] initWithNibName:@"BGViewController" bundle:nil];
            BGHomeViewController *controller = [[BGHomeViewController alloc] initWithNibName:@"BGViewController" bundle:nil fromScene:fromePage];

            self.homePageViewController = controller;
            [controller release];
        }
        self.homePageViewController.delegate = self;
    }
    
    else if (toPage == kPageAbout) {
        NSLog(@"toPage = AboutPage");
        
        if (self.aboutPageViewController.view.superview == nil) {
            BGAboutViewController *controller = [[BGAboutViewController alloc] initWithNibName:@"BGAboutViewController" bundle:nil];
            self.aboutPageViewController = controller;
            [controller release];
        }
        self.aboutPageViewController.delegate = self;
    }
    
//    else if (toPage == kPageGalleryHome) {
//        NSLog(@"toPage = GalleryHomePage");
//        
//        if (self.galleryHomePageViewController == nil) {
//            BGGalleryHomeViewController *controller = [[BGGalleryHomeViewController alloc] initWithNibName:@"BGGalleryHomeViewController" bundle:nil];
//            self.galleryHomePageViewController = controller;
//            [controller release];
//        }
//        
//        self.galleryHomePageViewController.delegate = self;
//        [self.galleryHomePageViewController loadDataSource:NO];
//    }
//    
    else if (toPage == kPageGallery) {
        NSLog(@"toPage = Gallery Page");
        
        if (self.galleryPageViewController.view.superview == nil) {
            BGGalleryViewController *controller = [[BGGalleryViewController alloc] initWithNibName:@"BGGalleryViewController" bundle:nil];
            self.galleryPageViewController = controller;
            [controller release];
        }
        
        self.galleryPageViewController.delegate = self;
    }
    
    else if (toPage == kPageUI) {
        NSLog(@"toPage = Reflection Page");
        
//        if (self.reflectionViewController.view.superview == nil) {
//            BGReflectionViewController *controller = [[BGReflectionViewController alloc] initWithNibName:@"BGReflectionViewController" bundle:nil];
//            self.reflectionViewController = controller;
//            [controller release];
//        }
//        
//        self.reflectionViewController.delegate = self;
        
        if (self.imageFilterViewController.view.superview == nil) {
            BGImageFilterViewController *controller = [[BGImageFilterViewController alloc] initWithNibName:@"BGImageFilterViewController" bundle:nil];
            self.imageFilterViewController = controller;
            [controller release];
        }
        
        self.imageFilterViewController.delegate = self;
    }
}

-(UIViewController *) getSwitchViewController: (int) pageNum{
	switch (pageNum) {
		case kPageMain:
        case kPageGalleryHome:
			return self.homePageViewController;
			break;
			
//		case kPageGalleryHome:
//        case kPageOnlineGalleryHome:
//			return self.galleryHomePageViewController;
//			break;
            
		case kPageGallery:
        case kPageOnlineGallery:
			return self.galleryPageViewController;
			break;
            
        case kPageAbout:
            return self.aboutPageViewController;
            break;
            
        case kPageUI:
//            return self.reflectionViewController;
            return self.imageFilterViewController;
            break;
	}
	return nil;
}

@end
