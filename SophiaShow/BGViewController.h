//
//  BGViewController.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/03/21.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPageSwitcherDelegate.h"

@interface BGViewController : UIViewController{
    id<BGPageSwitcherDelegate> delegate;
    
    UIButton *gotoAbout;
}

@property (nonatomic, assign) id<BGPageSwitcherDelegate> delegate;

@property (nonatomic, retain) UIButton *gotoAbout;

@end
