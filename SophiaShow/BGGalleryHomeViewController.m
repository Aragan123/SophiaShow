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
@synthesize delegate, dataSource, isOnlineData, galleryCarousel;

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
//    BGGalleryTableViewController *tableViewController = [[[BGGalleryTableViewController alloc] initWithDataSource:self.dataSource isOnlineData:self.isOnlineData] autorelease];
//    tableViewController.view.frame = CGRectMake(20, self.view.frame.size.height, 984, 673);
//    tableViewController.delegate = self;
//    [self.view addSubview:tableViewController.view];
    
    // add gallery carousel view
    self.galleryCarousel.type = iCarouselTypeWheel;
    
    
    // add go home button
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setFrame:CGRectMake(944, 688, 60, 60)];
    [homeBtn setImage:[UIImage imageNamed:@"home_2.png"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(clickGoHomeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeBtn];
    
    // run animation of gallery table view
//    [UIView animateWithDuration:0.5f delay:0.5f options:0 animations:^{
//        tableViewController.view.center = CGPointMake(20+tableViewController.view.frame.size.width*0.5, 20+tableViewController.view.frame.size.height*0.5);
//    } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload{
    dataSource=nil;

    galleryCarousel = nil;
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    [dataSource release];
    
    galleryCarousel.delegate=nil;
    galleryCarousel.dataSource=nil;
    [galleryCarousel release];
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

- (NSString*) getGalleryImageURI: (NSDictionary*)galleryBook {
    NSString *uri = [galleryBook objectForKey:@"GalleryURI"];
    if (!isOnlineData) {
        // is offline data
        return [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@/index.jpg", uri];
    }else{
        // is online data
        return [NSString stringWithFormat:@"%@/index.jpg", uri];
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

#pragma mark - 
#pragma mark iCarousel DataSource and delegate methods
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.dataSource count];
}

- (NSUInteger) numberOfPlaceholdersInCarousel:(iCarousel *)carousel{
    return 10;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if (view == nil) {
        // create new view
        view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)] autorelease];
        [view setBackgroundColor:[UIColor clearColor]];
    }else{
        UIView *removeView = nil;
        removeView = [view viewWithTag:kRemoveViewTag];
        if (removeView) {
            [removeView removeFromSuperview];
        }
    }
    
    UIImageView *snapView = [[[UIImageView alloc] initWithFrame:view.frame] autorelease];
    snapView.tag = kRemoveViewTag;
    NSString *imageURI = [self getGalleryImageURI:[self.dataSource objectAtIndex:index]];
    NSLog(@"loading gallery imagURI: %@", imageURI);
    snapView.image = [UIImage imageWithContentsOfFile:imageURI];
    snapView.contentMode = UIViewContentModeRedraw;
    
    [view addSubview:snapView];
    
    return view;
}

//- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
//{
//    //implement 'flip3D' style carousel
//    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
//    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * galleryCarousel.itemWidth);
//}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 2.0f;
        }
        default:
        {
            return value;
        }
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"Gallery book is selected at index: %i", index);
    [self itemCellSelected:index];
}

@end
