//
//  BGGalleryHomeViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/02.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGGalleryHomeViewController.h"
#import "BGGalleryTableViewController.h"

@interface BGGalleryHomeViewController ()

@end

@implementation BGGalleryHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithNibName:nibNameOrNil
                          bundle:nibBundleOrNil
                    isOnlineData:NO];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isOnlineData:(BOOL) online
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isOnlineData = online;
        [self loadDataSource:isOnlineData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    BGGalleryTableViewController *tableViewController = [[BGGalleryTableViewController alloc] initWithDataSource:dataSource isOnlineData:isOnlineData];
    tableViewController.view.frame = CGRectMake(20, 20, 984, 676);
    [self.view addSubview:tableViewController.view];
    [tableViewController release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadDataSource: (BOOL) online{
    if (!online) {
        // this is offline
        
    }else{
        // this is On Line
        
    }
}

@end
