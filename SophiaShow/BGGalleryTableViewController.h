//
//  BGGalleryTableViewController.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/02.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATArrayView.h"

#ifndef kRemoveViewTag
#define kRemoveViewTag 118
#endif

@protocol BGGalleryTableViewControllerDelegate;

@interface BGGalleryTableViewController : ATArrayViewController{
    id<BGGalleryTableViewControllerDelegate> delegate;
    
    NSArray *dataSource;
    BOOL isOnlineData;
}

@property (nonatomic, assign) id<BGGalleryTableViewControllerDelegate> delegate;
@property (nonatomic, retain) NSArray *dataSource;
@property (nonatomic, assign) BOOL isOnlineData;

//- (id) initWithDataSource: (NSArray*) ds isOnlineData: (BOOL)online;

@end

// Define delegate methods
@protocol BGGalleryTableViewControllerDelegate <NSObject>
@required
- (void) itemCellSelected: (int) atIndex;

@end