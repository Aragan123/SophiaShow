//
//  BGSplashViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/08.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGSplashViewController.h"
#import "BGButterFly.h"

@interface BGSplashViewController ()

@end

@implementation BGSplashViewController
@synthesize butterflyArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.butterflyArray = [[NSMutableArray alloc] initWithCapacity:12];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"load splash view controller");
    
    // create butterflys
    BGButterFly *bf = [[[BGButterFly alloc] initWithFrame:CGRectMake(0, 0, 256, 256)] autorelease];
    bf.moveTo = CGPointMake(512, 800);
    [self.butterflyArray addObject:bf];
    [self.view addSubview:bf];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidUnload{
    butterflyArray=nil;
    
    [super viewDidUnload];
}

-(void) dealloc{
    [butterflyArray release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Action and Private Methods
- (IBAction)startFlyingAnimations:(id)sender{
    NSLog(@"start flying animation");
    
    UIButton *starBtn = (UIButton*)sender;
    [starBtn removeFromSuperview];
    
    for (BGButterFly *bf in self.butterflyArray) {
        [bf animateFlyingAndMoving];
    }
}

@end
