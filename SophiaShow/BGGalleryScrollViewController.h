//
//  BGGalleryScrollViewController.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/06.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "ATPagingView.h"

#ifndef kRemoveViewTag
#define kRemoveViewTag 118
#endif

@protocol BGGalleryScrollViewControllerDelegate;

@interface BGGalleryScrollViewController : ATPagingViewController{
    id<BGGalleryScrollViewControllerDelegate> delegate;
    NSArray *dataSource;
    BOOL isOnlineData;
}

@property (nonatomic, assign) id<BGGalleryScrollViewControllerDelegate> delegate;
@property (nonatomic, retain) NSArray *dataSource;
@property (nonatomic, assign) BOOL isOnlineData;

- (void) updateScrollerPagetoIndex: (int) index;
@end


@protocol BGGalleryScrollViewControllerDelegate <NSObject>
@required
- (void) scrollerPageViewChanged: (int) newPageIndex;
- (void) scrollerPageIsSingleTapped;

@end