//
//  BGSplashViewController.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/09/12.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPageSwitcherDelegate.h"


@interface BGSplashViewController : UIViewController

@property (nonatomic, assign) id<BGPageSwitcherDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIImageView *logo_text;
@property (retain, nonatomic) IBOutlet UIImageView *animation;
@property (retain, nonatomic) IBOutlet UIImageView *jump;
@property (retain, nonatomic) IBOutlet UIImageView *land;


@end
