//
//  BGAppDelegate.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/03/21.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UMENG_APPKEY @"51dbb76c56240b8dde03b33b"

@class BGSwitchViewController;

@interface BGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BGSwitchViewController *viewController;

@end
