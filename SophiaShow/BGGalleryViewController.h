//
//  BGGalleryViewController.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/06.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPageSwitcherDelegate.h"
#import "BGGalleryScrollViewController.h"
#import "iCarousel.h"

#ifndef kRemoveViewTag
#define kRemoveViewTag 118
#endif

#ifndef kRemoveLabelTag
#define kRemoveLabelTag 119
#endif

@interface BGGalleryViewController : UIViewController <BGGalleryScrollViewControllerDelegate, iCarouselDataSource, iCarouselDelegate>{
    id<BGPageSwitcherDelegate> delegate;
    // views
    BGGalleryScrollViewController *scrollViewController;
    UINavigationBar *topToolBar;
    UIToolbar *bottomToolBar;
    UINavigationItem *navItem;
    iCarousel *carousel;
    
    // data
    NSString *galleryTitle;
    NSArray *dataSource;
    
    int _currentArtIndex;
    BOOL _isFullScreen;
    float _bottomBarHeight;
}

@property (nonatomic, assign) id<BGPageSwitcherDelegate> delegate;
@property (nonatomic, retain) BGGalleryScrollViewController *scrollViewController;
@property (nonatomic, retain) UINavigationBar *topToolBar;
@property (nonatomic, retain) UIToolbar *bottomToolBar;
@property (nonatomic, retain) UINavigationItem *navItem;
@property (nonatomic, retain) iCarousel *carousel;

@property (nonatomic, copy) NSString *galleryTitle;
@property (nonatomic, retain) NSArray *dataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil galleryTitle:(NSString*)title;

@end
