//
//  BGSwitchViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/03/22.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGSwitchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BGHomeViewController.h"
#import "BGGalleryViewController.h"
#import "BGImageFilterViewController.h"
#import "BGSplashViewController.h"
#import "SVProgressHUD.h"
#import "NSObject+Blocks.h"

@interface BGSwitchViewController ()

@end

@implementation BGSwitchViewController
@synthesize homePageViewController, aboutPageViewController, galleryHomePageViewController, galleryPageViewController, reflectionViewController, imageFilterViewController, splashViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    BGHomeViewController *mainview = [[BGHomeViewController alloc] initWithNibName:@"BGHomeViewController" bundle:nil fromScene:kPageMain];
//    
//    self.homePageViewController = mainview;
//    self.homePageViewController.delegate=self;
//    [mainview release];
    
    [self prepareViewController:kPageSplash fromView:kPageMain];
    [self.view insertSubview: self.splashViewController.view atIndex:0];

    // transite to home page
    [self prepareViewController:kPageMain fromView:kPageSplash];
    // animation
    [self performBlock:^{
        NSLog(@"Switch to home page");
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.6f;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        //            animation.type = @"rippleEffect";
        animation.type = kCATransitionFade;
        
        // show views
        [self.splashViewController	viewWillDisappear:YES];
        [self.homePageViewController viewWillAppear:YES];
        
        [self.splashViewController.view removeFromSuperview];
        [self.view insertSubview:self.homePageViewController.view atIndex:0];
        
        [self.splashViewController viewDidDisappear:YES];
        [self.homePageViewController viewDidAppear:YES];
        
        // commit animation
        [self.view.layer addAnimation:animation forKey:@"Switch View Animation"];
        self.splashViewController=nil;
    } afterDelay:3.0f];

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
    if (self.galleryPageViewController.view.superview==nil) {
        self.galleryPageViewController=nil;
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
    self.splashViewController=nil;
    
    [super viewDidUnload];
}

- (void) dealloc{
    [homePageViewController release];
    [aboutPageViewController release];
    [galleryHomePageViewController release];
    [galleryPageViewController release];
    [reflectionViewController release];
    [imageFilterViewController release];
    [splashViewController release];
    
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
            BGHomeViewController *controller = [[BGHomeViewController alloc] initWithNibName:@"BGHomeViewController" bundle:nil fromScene:fromePage];

            self.homePageViewController = controller;
            [controller release];
        }
        self.homePageViewController.delegate = self;
    }
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
        if (self.imageFilterViewController.view.superview == nil) {
            BGImageFilterViewController *controller = [[BGImageFilterViewController alloc] initWithNibName:@"BGImageFilterViewController" bundle:nil];
            self.imageFilterViewController = controller;
            [controller release];
        }
        
        self.imageFilterViewController.delegate = self;
    }
    else if (toPage == kPageSplash){
        if (self.splashViewController == nil) {
            BGSplashViewController *controller = [[BGSplashViewController alloc] initWithNibName:@"BGSplashViewController" bundle:nil];
            self.splashViewController = controller;
            [controller release];
        }
        self.splashViewController.delegate = self;
    }
}

-(UIViewController *) getSwitchViewController: (int) pageNum{
	switch (pageNum) {
		case kPageMain:
        case kPageGalleryHome:
			return self.homePageViewController;
			break;
		case kPageGallery:
			return self.galleryPageViewController;
			break;            
        case kPageUI:
            return self.imageFilterViewController;
            break;
        case kPageSplash:
            return self.splashViewController;
            break;
	}
	return nil;
}

@end
