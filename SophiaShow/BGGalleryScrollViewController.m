//
//  BGGalleryScrollViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/06.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGGalleryScrollViewController.h"
#import "SPXFrameScroller.h"

@interface BGGalleryScrollViewController ()

@end

@implementation BGGalleryScrollViewController
@synthesize delegate, dataSource;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.pagingView.horizontal = YES;
    self.pagingView.currentPageIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload {
    [dataSource release];
    dataSource=nil;
    
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    [dataSource release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Public Methods & Actions
- (void) updateScrollerPagetoIndex: (int) index{
    self.pagingView.currentPageIndex = index;
}

// when image is tapped
- (void) scrollerPageIsTapped{
    if (nil != delegate) {
        [delegate scrollerPageIsSingleTapped];
    }
}

#pragma mark -
#pragma mark ATPagingViewDelegate methods
- (NSInteger)numberOfPagesInPagingView:(ATPagingView *)pagingView {
    return [self.dataSource count];
}

- (UIView *)viewForPageInPagingView:(ATPagingView *)pagingView atIndex:(NSInteger)index {
    
    SPXFrameScroller *view = (SPXFrameScroller*)[pagingView dequeueReusablePage]; // get a reusable item
    if (view == nil) {
        view = [[[SPXFrameScroller alloc] initWithFrame:self.view.frame] autorelease];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        view.backgroundColor = [UIColor clearColor];
        view.maximumZoomScale = 2.0f;
        view.minimumZoomScale = 1.0f;
        view.contentSize = self.view.frame.size; // set view content size

        // add imageview
        UIImageView *imageView = [[UIImageView alloc] initWithFrame: self.view.frame];
        [imageView setContentMode:UIViewContentModeScaleAspectFit]; // very important
        imageView.tag = kRemoveViewTag;
        [view addSubview:imageView];
        [imageView release];

        // when single tap
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerPageIsTapped)];
        [view addGestureRecognizer:tap];
        [tap release];
    }
    
    UIImageView *imageView = (UIImageView*)[view viewWithTag:kRemoveViewTag];
    NSString *imageURI = [self.dataSource objectAtIndex:index];
    NSLog(@"loadng imagURI: %@", imageURI);
    imageView.image = [UIImage imageWithContentsOfFile:imageURI];
    
    return view;
}

- (void)currentPageDidChangeInPagingView:(ATPagingView *)pagingView {
    if (nil != delegate && [delegate respondsToSelector:@selector(scrollerPageViewChanged:)]){
        NSLog (@"scroller page to : %i", pagingView.currentPageIndex);
        [delegate scrollerPageViewChanged:pagingView.currentPageIndex];
    } else
        NSLog(@"BGScrollViewController: there is no delegate is defined");
}

@end
