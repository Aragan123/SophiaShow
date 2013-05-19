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
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // add gallery image table view
    BGGalleryTableViewController *tableViewController = [[[BGGalleryTableViewController alloc] initWithDataSource:self.dataSource isOnlineData:self.isOnlineData] autorelease];
    tableViewController.view.frame = CGRectMake(20, self.view.frame.size.height, 984, 673);
    tableViewController.delegate = self;
    [self.view addSubview:tableViewController.view];
    
    // add go home button
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setFrame:CGRectMake(944, 688, 60, 60)];
    [homeBtn setImage:[UIImage imageNamed:@"home_2.png"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(clickGoHomeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeBtn];
    
    // run animation of gallery table view
    [UIView animateWithDuration:0.5f delay:0.5f options:0 animations:^{
        tableViewController.view.center = CGPointMake(20+tableViewController.view.frame.size.width*0.5, 20+tableViewController.view.frame.size.height*0.5);
    } completion:nil];
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
#pragma mark Public Methods
- (void) loadDataSource: (BOOL) online{
    self.isOnlineData = online;
    
    if (!online) {
        // this is offline
        self.dataSource = [[BGGlobalData sharedData] galleryBooks];
    }else{
        // this is On Line
        self.dataSource = [[BGGlobalData sharedData] onlineGalleryBooks];
    }
}

#pragma mark -
#pragma mark Action and Private Methods
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

#pragma mark -
#pragma mark BGGalleryTable View Controller Delegate Methods
- (void) itemCellSelected: (int) atIndex{
    if (nil == delegate) {
        return;
    }
    
    NSDictionary *gallaryBook = [self.dataSource objectAtIndex:atIndex];
    NSString *galleryURI = [gallaryBook objectForKey:@"GalleryURI"];
    NSArray *galleryImageNames = [gallaryBook objectForKey:@"GalleryImageNames"];
    NSMutableArray *galleryImageArray = [NSMutableArray arrayWithCapacity:[galleryImageNames count]];
    
    // construct gallery image URI array
    for (int i=0; i<galleryImageNames.count; i++) {
        NSString *galleryImageName = [galleryImageNames objectAtIndex:i];
        NSString *galleryImageURI;
        if (!self.isOnlineData) {
            // this is offline
            galleryImageURI = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@/%@", galleryURI, galleryImageName];
        }else{
            // this is online
            galleryImageURI = [NSString stringWithFormat:@"%@/%@", galleryURI, galleryImageName];
        }
        
        [galleryImageArray addObject:galleryImageURI];
    }
    // persistent
    [[BGGlobalData sharedData] setGalleryImages:[galleryImageArray copy]];
    
    // re-direct to gallery art page
    if (!self.isOnlineData) {
        // this is offline
        [delegate switchViewTo:kPageGallery fromView:kPageGalleryHome];
    }else{
        // this is online
        [delegate switchViewTo:kPageOnlineGallery fromView:kPageOnlineGalleryHome];
    }
}

@end
