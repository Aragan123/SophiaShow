//
//  BGFilterAreaViewController.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/06/21.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define GOLDEN_WIDTH 824
#define GOLDEN_HEIGHT 618

@interface BGFilterAreaViewController : UIViewController <UIScrollViewDelegate>{
    
}

@property (retain, nonatomic) UIImage *originalImage;
@property (retain, nonatomic) UIImage *cropedImage;
@property (retain, nonatomic) UIImage *filterImage;

@property (retain, nonatomic) IBOutlet UIImageView *photoView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) UIImageView *frameView;
@property (retain, nonatomic) CALayer *filterLayer;
@property (retain, nonatomic) CALayer *specialLayer;

- (void) setupViewsWithSourceImage: (UIImage*) srcImage;

- (void) updateBackgroundPattern: (UIImage*) image;
- (void) updatePhotoFrame: (UIImage*) image;
- (void) updatePhotoFilter: (UIImage*) image;
- (void) updateFilterOpacity: (float) value;

@end
