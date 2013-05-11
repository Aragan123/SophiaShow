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

@interface BGReflectionViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    id<BGPageSwitcherDelegate> delegate;
    
}

@property (nonatomic, assign) id<BGPageSwitcherDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIImageView *reflectionImage;
@property (retain, nonatomic) IBOutlet UIView *reflectionImageContainer;
@property (retain, nonatomic) IBOutlet UIView *reflectionArea;

@property (retain, nonatomic) UIPopoverController *popover;
@property (retain, nonatomic) DSReflectionLayer *reflectionLayer;

// controls
@property (retain, nonatomic) IBOutlet UIButton *btnCancel;
@property (retain, nonatomic) IBOutlet UIButton *btnOK;
@property (retain, nonatomic) IBOutlet UIButton *btnSaveAndShare;
@property (retain, nonatomic) IBOutlet UISwitch *switchReflection;
@property (retain, nonatomic) IBOutlet UISlider *sliderReflectionHeight;
@property (retain, nonatomic) IBOutlet UISlider *sliderReflectionOpacity;
@property (retain, nonatomic) IBOutlet UIButton *btnMoveUp;
@property (retain, nonatomic) IBOutlet UIButton *btnMoveRight;
@property (retain, nonatomic) IBOutlet UIButton *btnMoveDown;
@property (retain, nonatomic) IBOutlet UIButton *btnMoveLeft;


- (IBAction)returnHome:(id)sender;
- (IBAction)clickCancelButton:(id)sender;
- (IBAction)clickOkButton:(id)sender;
- (IBAction)clickSaveAndShare:(id)sender;
- (IBAction)changeSliderReflectionOpacity:(UISlider *)sender;
- (IBAction)clickMove:(id)sender;
- (IBAction)changeSliderReflectionHeight:(UISlider *)sender;
- (IBAction)changeSwitchReflection:(UISwitch *)sender;


@end
