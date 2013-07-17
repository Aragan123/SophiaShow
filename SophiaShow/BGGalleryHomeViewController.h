//
//  BGGalleryHomeViewController.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/06.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPageSwitcherDelegate.h"
#import "iCarousel.h"

#ifndef kRemoveViewTag
#define kRemoveViewTag 118
#endif

@interface BGGalleryHomeViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>{
    id<BGPageSwitcherDelegate> delegate;
    
    iCarousel *galleryCarousel;
    NSArray *dataSource;
    BOOL isOnlineData;
    
}

@property (nonatomic, assign) id<BGPageSwitcherDelegate> delegate;
@property (nonatomic, retain) NSArray *dataSource;
@property (nonatomic, assign) BOOL isOnlineData;
@property (nonatomic, retain) IBOutlet iCarousel *galleryCarousel;

- (void) loadDataSource: (BOOL) online;

@end
