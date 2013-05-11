//
//  BGSplashViewController.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/08.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGSplashViewController : UIViewController{
    NSMutableArray *butterflyArray;
    
}

@property (nonatomic, retain) NSMutableArray *butterflyArray;

- (IBAction)startFlyingAnimations:(id)sender;

@end
