//
//  BGImageFilterViewController.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/06/15.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPageSwitcherDelegate.h"
#import "iCarousel.h"
#import "BGFilterAreaViewController.h"

@class HMSideMenu;

#ifndef kRemoveViewTag
#define kRemoveViewTag 118
#endif



@interface BGImageFilterViewController : UIViewController <iCarouselDataSource, iCarouselDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    id<BGPageSwitcherDelegate> delegate;
    int selectedMenu;
    BOOL isEdited;
}

@property (nonatomic, assign) id<BGPageSwitcherDelegate> delegate;
@property (nonatomic, retain) HMSideMenu *sideMenu;
@property (nonatomic, retain) iCarousel *carousel;
@property (nonatomic, retain) NSArray *iCarousel_ds;
@property (retain, nonatomic) IBOutlet UIButton *btnChoosePhoto;
@property (retain, nonatomic) IBOutlet UISlider *sliderParameter;
@property (retain, nonatomic) IBOutlet UIButton *btnRotateFrame;
@property (retain, nonatomic) UIPopoverController *popover;
@property (nonatomic, retain) BGFilterAreaViewController *filterAreaViewController;

- (IBAction)clickChoosePhoto:(UIButton *)sender;
- (IBAction)clickCancelAll:(UIButton *)sender;
- (IBAction)sliderValueChange:(UISlider *)sender;

- (IBAction)clickReturnButton:(id)sender;
- (IBAction) selectFilterAreaOrientation :(UIButton*)sender;
@end
