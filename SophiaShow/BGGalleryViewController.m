//
//  BGGalleryViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/06.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGGalleryViewController.h"
#import "UIImageView+AFNetworking.h"
#import "BGGlobalData.h"

@interface BGGalleryViewController ()

@end

@implementation BGGalleryViewController
@synthesize delegate;
@synthesize scrollViewController, topToolBar, bottomToolBar, navItem, carousel;
@synthesize dataSource, galleryTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // default is offline/local galleries
    return [self initWithNibName:nibNameOrNil
                          bundle:nibBundleOrNil
                    galleryTitle:[[BGGlobalData sharedData] getCurrentGalleryTitle]
            ];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil galleryTitle:(NSString *)title
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.galleryTitle=title;
        self.dataSource = [[BGGlobalData sharedData] getCurrentGalleryImageURIs];
        _currentArtIndex = 0;
        _bottomBarHeight = 160.0f;
        _isFullScreen = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // load image scroll paging view
    self.scrollViewController = [[BGGalleryScrollViewController alloc] init];
    self.scrollViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.scrollViewController.delegate = self;
    self.scrollViewController.isOnlineData = NO; // always false
    self.scrollViewController.dataSource = self.dataSource;
    [self.view addSubview:self.scrollViewController.view];
    
    // top navigation bar
    self.topToolBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [self.topToolBar setBarStyle:UIBarStyleBlackTranslucent];
    self.navItem = [[UINavigationItem alloc] init];
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" 返 回 "
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(clickGoHomeButton:)];
    [self.topToolBar setItems:[NSArray arrayWithObject:self.navItem]];
    [self.view addSubview:self.topToolBar];
    [self updateNavBarTitle]; // set title
    
    // bottom tool bar
    self.bottomToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - _bottomBarHeight,
                                                                    self.view.frame.size.width, _bottomBarHeight)];
    [self.bottomToolBar setBarStyle:UIBarStyleBlackTranslucent];
    // add thumbnail tool - iCarousel
    self.carousel = [[iCarousel alloc] initWithFrame:self.bottomToolBar.frame];
    self.carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.carousel.type = iCarouselTypeLinear;
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    
    UIBarButtonItem *btnItem = [[[UIBarButtonItem alloc] initWithCustomView:carousel] autorelease];
    NSArray *barItems = [NSArray arrayWithObjects:btnItem, nil];
    [self.bottomToolBar setItems:barItems animated:YES];
    
    [self.view addSubview:self.bottomToolBar];
}


- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];    
    // to full screen
    if (!_isFullScreen) {
        [self performSelector:@selector(enterFullscreen) withObject:nil afterDelay:1.2f];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload{
    scrollViewController=nil;
    topToolBar=nil;
    bottomToolBar=nil;
    navItem=nil;
    carousel=nil;
    dataSource=nil;
    galleryTitle=nil;
    
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    [scrollViewController release];
    [topToolBar release];
    [bottomToolBar release];
    [navItem release];
    [carousel release];
    [galleryTitle release];
    
    [dataSource release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark BGGalleryScroll View Controller Delegate Methods
- (void) scrollerPageViewChanged: (int) newPageIndex{
    // when scroller image is changed, need to change thumbnail bar
    _currentArtIndex = newPageIndex;
//    [self updateNavBarTitle];
    //update thumbnail view current image index
    [self.carousel scrollToItemAtIndex:newPageIndex animated:YES];
}

- (void) scrollerPageIsSingleTapped{
    // show top bar and image navigation bar
    [self toggleFullScreen];
}

#pragma mark --
#pragma mark iCarousel delegate and its DataSrouce delegate methods
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.dataSource count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{    
    //create new view if no view is available for recycling
    if (view == nil){
        view = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 160.0f, _bottomBarHeight)] autorelease];
        view.contentMode = UIViewContentModeCenter;
    }else{
        UIView *removeView = nil;
        removeView = [view viewWithTag:kRemoveViewTag];
        if (removeView) {
            [removeView removeFromSuperview];
        }
    }

    // add images
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0f,10.0f, view.frame.size.width, 120.0f)] autorelease];
    imageView.tag = kRemoveViewTag;
    NSString *imageURI = [self.dataSource objectAtIndex:index];

    UIImage *imageObj = [UIImage imageWithContentsOfFile:imageURI]; //get images
//  imageView.image =[self imageScaledToSize:imageObj withSize:CGSizeMake(160.0f, 160.0f)];
    imageView.image = [self resizeImageToSize:imageObj withSize:imageView.frame.size];
    [view addSubview:imageView];
    
    // add lable
    UIView *lbl = [view viewWithTag:kRemoveLabelTag];
    if (lbl == nil) {
        UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, imageView.frame.size.height+15.0f, view.frame.size.width, 20.0f)] autorelease];
        lbl.tag = kRemoveLabelTag;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont fontWithName:@"Verdana" size:12.0f];
        lbl.text = [NSString stringWithFormat:@"%i", index+1];
        [view addSubview:lbl];
    }else{
        ((UILabel*)lbl).text = [NSString stringWithFormat:@"%i", index+1];
    }
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option){
        case iCarouselOptionWrap:{
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing:{
            //add a bit of spacing between the item views
            return value+0.1f;
        }
        default:{
            return value;
        }
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    // when thumbnail is selected and centred
    // update nav title and update scroller
    NSLog(@"select thumbnail: %i", index);
    _currentArtIndex = index;
//    [self updateNavBarTitle];
    [self.scrollViewController updateScrollerPagetoIndex:index];
}


#pragma mark -
#pragma mark Action and Private Methods
// when go home button is clicked
- (IBAction)clickGoHomeButton:(id)sender{
    if (nil != delegate) {
        [delegate switchViewTo:kPageGalleryHome fromView:kPageGallery];
    }
}

- (void) toggleFullScreen {
    // don't change when scrolling
    //	if( _isScrolling || !_isActive ) return;
	
	// toggle fullscreen.
	if( _isFullScreen == NO ) {
		[self enterFullscreen];
	}
	else {
		[self exitFullscreen];
	}
}

- (void)enterFullscreen
{
	_isFullScreen = YES;
	[self disableApp];
	
	[UIView beginAnimations:@"galleryOut" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(enableApp)];
	self.topToolBar.alpha = 0.0;
    self.bottomToolBar.alpha= 0.0;
	[UIView commitAnimations];
}

- (void)exitFullscreen
{
	_isFullScreen = NO;
	[self disableApp];
    
	[UIView beginAnimations:@"galleryIn" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(enableApp)];
	self.topToolBar.alpha = 1.0;
    self.bottomToolBar.alpha= 1.0;
	[UIView commitAnimations];
}

- (void)enableApp
{
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}
- (void)disableApp
{
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

// for image thumbnail creation
- (UIImage*) imageScaledToSize: (UIImage*) image withSize: (CGSize) newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect: CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// set top bar
- (void)updateNavBarTitle
{
    [self.navItem setTitle:self.galleryTitle];
}

- (UIImage *)resizeImageToSize: (UIImage*) sourceImage withSize: (CGSize)targetSize
{
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // make image center aligned
        if (widthFactor < heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor > heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil)
        NSLog(@"Error: could not scale image");
    
    return newImage ;
}


@end
