//
//  BGGalleryViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/06.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGGalleryViewController.h"
#import "UIImage+BGAdditional.h"
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
    [self disableApp];
    // load image scroll paging view
    BGGalleryScrollViewController *scrollView = [[BGGalleryScrollViewController alloc] init];
    scrollView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.scrollViewController = scrollView;
    [scrollView release];
    
    self.scrollViewController.delegate = self;
    self.scrollViewController.dataSource = self.dataSource;
    [self.view addSubview:self.scrollViewController.view];
    
    // top navigation bar
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [navBar setBarStyle:UIBarStyleBlackTranslucent];
    self.topToolBar = navBar;
    [navBar release];
    self.navItem = [[[UINavigationItem alloc] init] autorelease];
    self.navItem.title = self.galleryTitle; // set title
    self.navItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@" 返 回 "
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(clickGoHomeButton:)] autorelease];
    [self.topToolBar setItems:[NSArray arrayWithObject:self.navItem]];
    [self.view addSubview:self.topToolBar];
    
    // bottom tool bar
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - _bottomBarHeight,
                                                                    self.view.frame.size.width, _bottomBarHeight)];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    self.bottomToolBar = toolbar;
    [toolbar release];
    // add thumbnail tool - iCarousel
    self.carousel = [[[iCarousel alloc] initWithFrame:self.bottomToolBar.frame] autorelease];
    self.carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.carousel.type = iCarouselTypeLinear;
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    
    UIBarButtonItem *btnItem = [[[UIBarButtonItem alloc] initWithCustomView:carousel] autorelease];
    NSArray *barItems = [NSArray arrayWithObjects:btnItem, nil];
    [self.bottomToolBar setItems:barItems animated:YES];
    
    [self.view addSubview:self.bottomToolBar];
    
    [self enableApp];
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
        view.backgroundColor = [UIColor clearColor];
        // image view
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0f,10.0f, view.frame.size.width, 120.0f)] autorelease];
        imageView.tag = kRemoveViewTag;
        [view addSubview:imageView];
        
        // label view
        UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, imageView.frame.size.height+15.0f, view.frame.size.width, 20.0f)] autorelease];
        lbl.tag = kRemoveLabelTag;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont fontWithName:@"Verdana" size:12.0f];
        [view addSubview:lbl];
    }
    
    // add image
    UIImageView *imageView = (UIImageView*)[view viewWithTag:kRemoveViewTag];    
    NSString *imageURI = [self.dataSource objectAtIndex:index];
    UIImage *imageObj = [UIImage imageWithContentsOfFile:imageURI]; //get images
    imageView.image = [imageObj resizeImageToSize:imageView.frame.size]; // and resize it
    
    // add lable
    UILabel *lbl = (UILabel*)[view viewWithTag:kRemoveLabelTag];
    lbl.text = [NSString stringWithFormat:@"%i", index+1];
    
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


@end
