//
//  BGSwitchViewController.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/03/22.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPageSwitcherDelegate.h"

@class BGViewController;
@class BGAboutViewController;
@class BGGalleryHomeViewController;
@class BGGalleryViewController;

@interface BGSwitchViewController : UIViewController <BGPageSwitcherDelegate> {
    BGViewController *homeageViewController;
    BGAboutViewController *aboutPageViewController;
    BGGalleryHomeViewController *galleryHomePageViewController;
    BGGalleryViewController *galleryPageViewController;
}

@property (nonatomic, retain) BGViewController *homePageViewController;
@property (nonatomic, retain) BGAboutViewController *aboutPageViewController;
@property (nonatomic, retain) BGGalleryHomeViewController *galleryHomePageViewController;
@property (nonatomic, retain) BGGalleryViewController *galleryPageViewController;

@end
