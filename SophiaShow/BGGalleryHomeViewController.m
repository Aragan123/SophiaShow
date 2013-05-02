//
//  BGGalleryHomeViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/02.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGGalleryHomeViewController.h"
#import "BGGlobalData.h"

@interface BGGalleryHomeViewController ()

@end

@implementation BGGalleryHomeViewController
@synthesize delegate, dataSource;

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
    BGGalleryTableViewController *tableViewController = [[BGGalleryTableViewController alloc] initWithDataSource:self.dataSource isOnlineData:isOnlineData];
    tableViewController.view.frame = CGRectMake(20, 20, 984, 676);
    tableViewController.delegate = self;
    [self.view addSubview:tableViewController.view];
    [tableViewController release];
    
    
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


- (void) loadDataSource: (BOOL) online{
    if (!online) {
        // this is offline
        self.dataSource = [[BGGlobalData sharedData] galleryBooks];
    }else{
        // this is On Line
        self.dataSource = [[BGGlobalData sharedData] onlineGalleryBooks];
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
        if (!isOnlineData) {
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
    if (!isOnlineData) {
        // this is offline
        [delegate switchViewTo:kPageGallery fromView:kPageGalleryHome];
    }else{
        // this is online
        [delegate switchViewTo:kPageOnlineGallery fromView:kPageOnlineGalleryHome];
    }
}


@end
