//
//  BGReflectionViewController.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/10.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPageSwitcherDelegate.h"

@class DSReflectionLayer;

@interface BGReflectionViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>{
    id<BGPageSwitcherDelegate> delegate;
    BOOL newImage;
    
}

@property (nonatomic, assign) id<BGPageSwitcherDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIView *reflectionArea;
@property (retain, nonatomic) IBOutlet UIView *reflectionImageContainer;
@property (retain, nonatomic) IBOutlet UIView *reflectionScrollContainer;

@property (retain, nonatomic) UIScrollView *reflectionScrollView;
@property (retain, nonatomic) UIImageView *scrollImageView;

@property (retain, nonatomic) UIImageView *reflectionImageView;

@property (retain, nonatomic) UIPopoverController *popover;
@property (retain, nonatomic) DSReflectionLayer *reflectionLayer;
@property (retain, nonatomic) UIImage *savedImage;

// controls
@property (retain, nonatomic) IBOutlet UIButton *btnCancel;
@property (retain, nonatomic) IBOutlet UIButton *btnOK;
@property (retain, nonatomic) IBOutlet UIButton *btnSaveAndShare;
@property (retain, nonatomic) IBOutlet UISwitch *switchReflection;
@property (retain, nonatomic) IBOutlet UISlider *sliderReflectionHeight;
@property (retain, nonatomic) IBOutlet UISlider *sliderReflectionOpacity;
@property (retain, nonatomic) IBOutlet UIButton *btnMoveA;
@property (retain, nonatomic) IBOutlet UIButton *btnMoveB;
@property (retain, nonatomic) IBOutlet UIButton *btnMoveC;
@property (retain, nonatomic) IBOutlet UIButton *btnMoveD;
@property (retain, nonatomic) IBOutlet UIButton *btnMoveE;
@property (retain, nonatomic) IBOutlet UIButton *btnMoveF;
@property (retain, nonatomic) IBOutlet UIButton *btnMoveG;
@property (retain, nonatomic) IBOutlet UIButton *btnMoveH;
@property (retain, nonatomic) IBOutlet UIButton *btnMoveI;


- (IBAction)returnHome:(id)sender;
- (IBAction)clickCancelButton:(id)sender;
- (IBAction)clickOkButton:(id)sender;
- (IBAction)clickSaveAndShare:(id)sender;
- (IBAction)changeSliderReflectionOpacity:(UISlider *)sender;
- (IBAction)changeSliderReflectionHeight:(UISlider *)sender;
- (IBAction)changeSwitchReflection:(UISwitch *)sender;
- (IBAction)clickBtnMove:(UIButton *)sender;


@end
