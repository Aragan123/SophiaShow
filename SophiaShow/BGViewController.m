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
    [self.view setUserInteractionEnabled:NO]; // disable user interaction till all animations complete
    
    self.btn_about.center = CGPointMake(0-self.btn_about.frame.size.width*0.5, 0-self.btn_about.frame.size.height*0.5);
    self.btn_gallery.center = CGPointMake(self.view.frame.size.width + self.btn_gallery.frame.size.width*0.5, self.view.frame.size.height + self.btn_gallery.frame.size.height*0.5);
    self.btn_ui.center = CGPointMake(self.view.frame.size.width*0.5, 0-self.btn_ui.frame.size.height*0.5);
    // animation of appearance of buttons
    [UIView animateWithDuration:0.75 delay:0.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.btn_about.center = CGPointMake(0+self.btn_about.frame.size.width*0.5, 270 +self.btn_about.frame.size.height*0.5);
    } completion:nil];
     
    [UIView animateWithDuration:0.75 delay:1.2f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.btn_ui.center = CGPointMake(135+self.btn_ui.frame.size.width*0.5, 0+self.btn_ui.frame.size.height*0.5);
    } completion:nil];
    
    [UIView animateWithDuration:0.75 delay:1.45f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.btn_gallery.center = CGPointMake(480+self.btn_gallery.frame.size.width*0.5, 260+self.btn_gallery.frame.size.height*0.5);
    } completion:^(BOOL complete){
        [self.view setUserInteractionEnabled:YES]; // enable interaction finally
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload{
    splashVc=nil;
    
    [self setBtn_ui:nil];
    [self setBtn_gallery:nil];
    [self setBtn_about:nil];
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    [splashVc release];
    
    [_btn_ui release];
    [_btn_gallery release];
    [_btn_about release];
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
