//
//  BGGalleryHomeViewController.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/06.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPageSwitcherDelegate.h"
#import "BGGalleryTableViewController.h"

@interface BGGalleryHomeViewController : UIViewController{
    id<BGPageSwitcherDelegate> delegate;
    
    NSArray *dataSource;
    BOOL isOnlineData;
    
}

@property (nonatomic, assign) id<BGPageSwitcherDelegate> delegate;
@property (nonatomic, retain) NSArray *dataSource;
@property (nonatomic, assign) BOOL isOnlineData;

- (void) loadDataSource: (BOOL) online;

@end
