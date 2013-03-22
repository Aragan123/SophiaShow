//
//  BGAboutViewController.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/03/22.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGAboutViewController : UIViewController<UIScrollViewDelegate>{
    UIScrollView *scroll;
    UIPageControl *pages;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scroll;
@property (nonatomic, retain) IBOutlet UIPageControl *pages;

@end
