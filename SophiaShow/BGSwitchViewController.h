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
@class BGHomeViewController;
@class BGAboutViewController;
@class BGGalleryHomeViewController;
@class BGGalleryViewController;
@class BGReflectionViewController;
@class BGImageFilterViewController;

@interface BGSwitchViewController : UIViewController <BGPageSwitcherDelegate> {
    BGViewController *homePageViewController;
//    BGHomeViewController *homePageViewController;
    BGAboutViewController *aboutPageViewController;
    BGGalleryHomeViewController *galleryHomePageViewController;
    BGGalleryViewController *galleryPageViewController;
    BGReflectionViewController *reflectionViewController;
    BGImageFilterViewController *imageFilterViewController;
}

@property (nonatomic, retain) BGViewController *homePageViewController;
//@property (nonatomic, retain) BGHomeViewController *homePageViewController;
@property (nonatomic, retain) BGAboutViewController *aboutPageViewController;
@property (nonatomic, retain) BGGalleryHomeViewController *galleryHomePageViewController;
@property (nonatomic, retain) BGGalleryViewController *galleryPageViewController;
@property (nonatomic, retain) BGReflectionViewController *reflectionViewController;
@property (nonatomic, retain) BGImageFilterViewController *imageFilterViewController;

@end
