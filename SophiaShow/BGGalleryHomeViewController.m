//
//  BGGalleryHomeViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/06.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGGalleryHomeViewController.h"
#import "BGGlobalData.h"

@interface BGGalleryHomeViewController ()

@end

@implementation BGGalleryHomeViewController
@synthesize delegate, dataSource, isOnlineData;

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
    // Do any additional setup after loading the view from its nib.
    
    BGGalleryTableViewController *tableViewController = [[[BGGalleryTableViewController alloc] init] autorelease];
    tableViewController.view.frame = CGRectMake(20, 20, 600, 800);
    tableViewController.isOnlineData = self.isOnlineData;
    tableViewController.dataSource = self.dataSource;
    [self.view addSubview:tableViewController.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload{
    dataSource=nil;
    
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    [dataSource release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Action and Private Methods
- (void) loadDataSource: (BOOL) online{
    if (!online) {
        // this is offline
        self.dataSource = [[BGGlobalData sharedData] galleryBooks];
    }else{
        // this is On Line
        self.dataSource = [[BGGlobalData sharedData] onlineGalleryBooks];
    }
}

// when go home button is clicked
- (IBAction)clickGoHomeButton:(id)sender{
    if (nil != delegate) {
        if (!isOnlineData) {
            [delegate switchViewTo:kPageMain fromView:kPageGalleryHome];
        }else{
            [delegate switchViewTo:kPageMain fromView:kPageOnlineGalleryHome];
        }
    }
}


@end
