//
//  BGGalleryScrollViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/06.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGGalleryScrollViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SPXFrameScroller.h"
#import "JMWhenTapped.h"

@interface BGGalleryScrollViewController ()

@end

@implementation BGGalleryScrollViewController
@synthesize delegate, dataSource, isOnlineData;

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
#pragma mark Public Methods
- (void) updateScrollerPagetoIndex: (int) index{
    self.pagingView.currentPageIndex = index;
}

#pragma mark -
#pragma mark ATPagingViewDelegate methods
- (NSInteger)numberOfPagesInPagingView:(ATPagingView *)pagingView {
    return [self.dataSource count];
}

- (UIView *)viewForPageInPagingView:(ATPagingView *)pagingView atIndex:(NSInteger)index {
    // get imageview to be displayed
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame: self.view.frame] autorelease];
    [imageView setContentMode:UIViewContentModeScaleAspectFit]; // very important
    imageView.tag = kRemoveViewTag;
    NSString *imageURI = [self.dataSource objectAtIndex:index];
    NSLog(@"loadng imagURI: %@", imageURI);
    
    if (!self.isOnlineData){
        // local gallery
        imageView.image = [UIImage imageWithContentsOfFile:imageURI];
    }else{
        // online gallery
        [imageView setImageWithURL:[NSURL URLWithString:imageURI] placeholderImage:[UIImage imageNamed:@"loading_b.png"]];
    }
    
    // construct view to display
    SPXFrameScroller *view = (SPXFrameScroller*)[pagingView dequeueReusablePage]; // get a reusable item
    if (view == nil) {
        view = [[[SPXFrameScroller alloc] initWithFrame:self.view.frame] autorelease];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        view.backgroundColor = [UIColor clearColor];
        view.maximumZoomScale = 2.0f;
        view.minimumZoomScale = 1.0f;
    }else{
        UIView *removeView = nil;
        removeView = [view viewWithTag:kRemoveViewTag];
        if (removeView) {
            [removeView removeFromSuperview];
        }
    }
    
    view.contentSize = self.view.frame.size; // must put over here, not in initialization block above
    [view addSubview:imageView];
    
    // when single tap
    [view whenTapped:^{
        if (nil != delegate) {
            [delegate scrollerPageIsSingleTapped];
        }
    }];
    
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
