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

@interface BGSwitchViewController : UIViewController <BGPageSwitcherDelegate> {
    BGViewController *homeageViewController;
    BGAboutViewController *aboutPageViewController;
}

@property (nonatomic, retain) BGViewController *homePageViewController;
@property (nonatomic, retain) BGAboutViewController *aboutPageViewController;

@end
