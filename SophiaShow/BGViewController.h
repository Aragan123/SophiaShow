//
//  BGViewController.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/03/21.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPageSwitcherDelegate.h"

@class BGSplashViewController;

@interface BGViewController : UIViewController{
    id<BGPageSwitcherDelegate> delegate;
    BGSplashViewController *splashVc;
}

@property (retain, nonatomic) IBOutlet UIButton *btn_ui;
@property (retain, nonatomic) IBOutlet UIButton *btn_gallery;

@property (nonatomic, assign) id<BGPageSwitcherDelegate> delegate;
@property (nonatomic, retain) BGSplashViewController *splashVc;

- (IBAction) clickMenuButton: (id) sender;

@end
