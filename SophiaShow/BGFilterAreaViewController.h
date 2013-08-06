//
//  BGFilterAreaViewController.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/06/21.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BGGlobalData.h"

#define GOLDEN_WIDTH 824
#define GOLDEN_HEIGHT 618

@interface BGFilterAreaViewController : UIViewController <UIScrollViewDelegate>{
    BOOL isPortrait;
}

@property (retain, nonatomic) UIImage *originalImage;
@property (retain, nonatomic) UIImage *cropedImage;
@property (assign, nonatomic) BGFilterData filterData;
@property (retain, nonatomic) NSArray *specialArray;

@property (retain, nonatomic) IBOutlet UIImageView *photoView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) UIImageView *frameView;
@property (retain, nonatomic) UIImageView *resultFilterView;
@property (retain, nonatomic) UIImageView *specialForeLayer;
@property (retain, nonatomic) UIImageView *specialBackLayer;

- (void) setupViewsWithSourceImage: (UIImage*) srcImage;
- (void) clearContents;
- (UIImage*) screenshot;

- (void) updateBackgroundPattern: (UIImage*) image;
- (void) updatePhotoFrame: (BGPhotoFrameData) data;
- (void) updatePhotoFilter: (BGFilterData) data;
- (void) updateFilterOpacity: (float) value;
- (void) updatePhotoSpecials: (NSDictionary*) dataDict;

@end
