//
//  BGGalleryHomeViewController.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/02.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPageSwitcherDelegate.h"
#import "BGGalleryTableViewController.h"

@interface BGGalleryHomeViewController : UIViewController <BGGalleryTableViewControllerDelegate>{
    id<BGPageSwitcherDelegate> delegate;
    BOOL isOnlineData;
    NSArray *dataSource;

}

@property (nonatomic, assign) id<BGPageSwitcherDelegate> delegate;
@property (nonatomic, retain) NSArray *dataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isOnlineData:(BOOL) online;

@end
