//
//  BGSplashViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/09/12.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGSplashViewController.h"
#import "NSObject+Blocks.h"

@interface BGSplashViewController ()

@end

@implementation BGSplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // Do any additional setup after loading the view from its nib.
    self.animation.animationImages = [NSArray arrayWithObjects:
//                                      [UIImage imageNamed:@"splash_pifeng0.png"],
                                      [UIImage imageNamed:@"splash_pifeng1.png"],
                                      [UIImage imageNamed:@"splash_pifeng2.png"],
                                      [UIImage imageNamed:@"splash_pifeng0.png"],
                                      [UIImage imageNamed:@""],
                                      nil];
    self.animation.animationDuration = 0.8f;
    self.animation.animationRepeatCount = 0;
    
    // sart logo and spirit jump
    CGPoint logo_centre = self.logo_text.center;
    logo_centre.y = 243.0f + self.logo_text.frame.size.height*0.5;
//    CGPoint jump_centre = self.jump.center;
    CGPoint jump_centre1 = self.jump.center;
    jump_centre1.y = 264.0f + self.jump.frame.size.height*0.5;
    CGPoint jump_centre2 = jump_centre1;
    jump_centre2.y -= 12.0f;
    
    
    [UIView animateWithDuration:0.6f animations:^{
        self.land.alpha = 1.0f;
        self.animation.alpha = 1.0f;
        self.jump.alpha = 1.0f;
    } completion:^(BOOL finished) {
        self.logo_text.alpha = 1.0f;
        [self.animation startAnimating];
        
        [UIView animateWithDuration:0.4f
                         animations:^{
                             self.logo_text.center = logo_centre;
                         }
                         completion:^(BOOL complete){
                             [UIView animateWithDuration:0.6f animations:^{
//                             self.jump.center = jump_centre;
                                 self.jump.center = jump_centre2;
                                 self.jump.center = jump_centre1;
                                 
                             } completion:^(BOOL complete){
                                 NSLog(@"animation done");
                             }];
                             
                         }];
    }];
    

    
    
//    [self performBlock:^{
//        if (self.delegate) {
//            NSLog(@"Switch to home page");
//            [self.delegate switchViewTo:kPageMain fromView:kPageSplash];
//        }
//    } afterDelay:4.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    _delegate=nil;
    [_logo_text release];
    [_animation release];
    [_jump release];
    [_land release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLogo_text:nil];
    if ([self.animation isAnimating]) {
        [self.animation stopAnimating];
    }
    [self setAnimation:nil];
    [self setJump:nil];
    [self setLand:nil];
    [super viewDidUnload];
}

@end
