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
@synthesize dataSource, isOnlineData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // default is offline/local galleries
    return [self initWithNibName:nibNameOrNil
                          bundle:nibBundleOrNil
                 isOnlineGallery:NO
            ];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isOnlineGallery:(BOOL)online
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isOnlineData=online;
        self.dataSource = [[BGGlobalData sharedData] galleryImages];
        _currentArtIndex = 0;
        _bottomBarHeight = 180.0f;
        _isFullScreen = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIImage *backgroundPattern = [UIImage imageNamed:@"beauty_background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
    
    // load image scroll paging view
    self.scrollViewController = [[BGGalleryScrollViewController alloc] init];
    self.scrollViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.scrollViewController.delegate = self;
    self.scrollViewController.isOnlineData = self.isOnlineData;
    self.scrollViewController.dataSource = self.dataSource;
    [self.view addSubview:self.scrollViewController.view];
    
    // top navigation bar
    self.topToolBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [self.topToolBar setBarStyle:UIBarStyleBlackTranslucent];
    self.navItem = [[UINavigationItem alloc] init];
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Go Back"
                                                                 style:UIBarButtonItemStyleBordered
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
        [self performSelector:@selector(enterFullscreen) withObject:nil afterDelay:1.5f];
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
    
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    [scrollViewController release];
    [topToolBar release];
    [bottomToolBar release];
    [navItem release];
    [carousel release];
    
    [dataSource release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark BGGalleryScroll View Controller Delegate Methods
- (void) scrollerPageViewChanged: (int) newPageIndex{
    // when scroller image is changed, need to change thumbnail bar
    _currentArtIndex = newPageIndex;
    [self updateNavBarTitle];
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
        view = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180.0f, 180.0f)] autorelease];
        view.contentMode = UIViewContentModeCenter;
    }else{
        UIView *removeView = nil;
        removeView = [view viewWithTag:kRemoveViewTag];
        if (removeView) {
            [removeView removeFromSuperview];
        }
    }

    // add images
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10,10, 160, 160)] autorelease];
    imageView.tag = kRemoveViewTag;
    NSString *imageURI = [self.dataSource objectAtIndex:index];
    
    if (!isOnlineData){
        // local gallery
        UIImage *imageObj = [UIImage imageWithContentsOfFile:imageURI]; //get images
//        imageView.image =[self imageScaledToSize:imageObj withSize:CGSizeMake(160.0f, 160.0f)];
        imageView.image = [self resizeImageToSize:imageObj withSize:CGSizeMake(160.0f, 160.0f)];
    }else{
        // online gallery
        [imageView setImageWithURL:[NSURL URLWithString:imageURI] placeholderImage:[UIImage imageNamed:@"loading.jpg"]];
    }
    
    [view addSubview:imageView];
    return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    // when thumbnail is selected and centred
    // update nav title and update scroller
    NSLog(@"select thumbnail: %i", index);
    _currentArtIndex = index;
    [self updateNavBarTitle];
    [self.scrollViewController updateScrollerPagetoIndex:index];
}


#pragma mark -
#pragma mark Action and Private Methods
// when go home button is clicked
- (IBAction)clickGoHomeButton:(id)sender{
    if (nil != delegate) {
        if (!isOnlineData) {
            [delegate switchViewTo:kPageGalleryHome fromView:kPageGallery];
        }else{
            [delegate switchViewTo:kPageOnlineGalleryHome fromView:kPageOnlineGallery];
        }
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

- (void)updateNavBarTitle
{
    [self.navItem setTitle:[NSString stringWithFormat:@"%i of %i", _currentArtIndex+1, [self.dataSource count]]];
    
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
        NSLog(@"could not scale image");
    
    return newImage ;
}


@end
