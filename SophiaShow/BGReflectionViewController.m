//
//  BGReflectionViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/10.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGReflectionViewController.h"
#import "JMWhenTapped.h"
#import "DSReflectionLayer.h"
#import "UIView+BGReflection.h"

@interface BGReflectionViewController ()

@end

@implementation BGReflectionViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupReflectionArea];
    [self setupControlsActivity];
    [self.reflectionImage.layer setCornerRadius:6.0f];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    delegate=nil;
    [_popover release];
    [_reflectionLayer release];
    
    [_reflectionImage release];
    [_reflectionImageContainer release];
    [_btnCancel release];
    [_btnOK release];
    [_btnSaveAndShare release];
    [_switchReflection release];
    [_sliderReflectionOpacity release];
    [_btnMoveUp release];
    [_btnMoveRight release];
    [_btnMoveDown release];
    [_btnMoveLeft release];
    [_reflectionArea release];
    [_sliderReflectionHeight release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPopover:nil];
    [self setReflectionLayer:nil];
    
    [self setReflectionImage:nil];
    [self setReflectionImageContainer:nil];
    [self setBtnCancel:nil];
    [self setBtnOK:nil];
    [self setBtnSaveAndShare:nil];
    [self setSwitchReflection:nil];
    [self setSliderReflectionOpacity:nil];
    [self setBtnMoveUp:nil];
    [self setBtnMoveRight:nil];
    [self setBtnMoveDown:nil];
    [self setBtnMoveLeft:nil];
    [self setReflectionArea:nil];
    [self setSliderReflectionHeight:nil];
    [super viewDidUnload];
}

- (void) setupControlsActivity{
    // init values to some of controls
    [self.sliderReflectionHeight setValue:0.0f];
    [self.sliderReflectionOpacity setValue:0.0f];
    [self.switchReflection setOn:NO];
    
    // controls activity
    [self disableAllControls];
//    [self enableControl:self.btnOK];
}

- (void) setupReflectionArea{
    self.reflectionImage.image = [UIImage imageNamed:@"ui_cross_a.png"];
    [self.reflectionImage clearReflecitonLayer];
    self.reflectionLayer =nil;
    [self.reflectionImage whenTapped:^{
        UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"请选择文件来源"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"照相机",@"本地相簿",nil];
        [actionSheet showInView:self.view];
        [actionSheet release];
    }];
    
    [self.reflectionImageContainer setXRotation:0.0f];
    [self.reflectionImageContainer setYRotation:0.0f];

    
    // remove contains all guestures
    for (UIGestureRecognizer *recognizer in self.reflectionArea.gestureRecognizers) {
        [self.reflectionArea removeGestureRecognizer:recognizer];
    }
}

- (void) disableControl: (UIControl*) control{
    control.enabled = NO;
    control.layer.opacity = 0.5f;
}

- (void) enableControl: (UIControl*) control{
    control.enabled = YES;
    control.layer.opacity = 1.0f;
}

- (void) disableAllControls{
    [self disableControl:self.btnSaveAndShare];
    [self disableControl:self.switchReflection];
    [self disableControl:self.sliderReflectionOpacity];
    [self disableControl:self.sliderReflectionHeight];
    [self disableControl:self.btnMoveDown];
    [self disableControl:self.btnMoveUp];
    [self disableControl:self.btnMoveLeft];
    [self disableControl:self.btnMoveRight];
    [self disableControl:self.btnOK];
    [self disableControl:self.btnCancel];
}

- (void) enableAllControls{
    [self enableControl:self.btnSaveAndShare];
    [self enableControl:self.switchReflection];
    [self enableControl:self.sliderReflectionOpacity];
    [self enableControl:self.sliderReflectionHeight];
    [self enableControl:self.btnMoveDown];
    [self enableControl:self.btnMoveUp];
    [self enableControl:self.btnMoveLeft];
    [self enableControl:self.btnMoveRight];
    [self enableControl:self.btnOK];
    [self enableControl:self.btnCancel];
}

#pragma mark -
#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex = [%d]",buttonIndex);
    switch (buttonIndex) {
        case 0://照相机
        {   UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
            [imagePicker release];
        }
            break;
        case 1://本地相簿
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypePhotoLibrary]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.delegate = self;
                [imagePicker setAllowsEditing:NO];
                self.popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
                [self.popover presentPopoverFromRect:CGRectMake(0, 0, 450, 400) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                [imagePicker release];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Error accessing photo library!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    
    NSLog(@"selected image type: %@", mediaType);
    if ([mediaType isEqualToString:@"public.image"]){
        // UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSLog(@"found an image");
        [self.reflectionImage setContentMode:UIViewContentModeScaleAspectFit];
        [self.reflectionImage setImage:image];
    }
    
//    UIImage  *img = [info objectForKey:UIImagePickerControllerEditedImage];

//    self.reflectionImage.image = [UIImage imageNamed:@"Icon-72.png"];
    
    [self.popover dismissPopoverAnimated:YES];
    [self enableControl:self.btnOK]; // enable OK button
    [self enableControl:self.btnCancel]; // enable Cancel button
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Gesture Actions
- (void)pan:(UIPanGestureRecognizer*)pan
{
	CGPoint location = [pan locationInView:self.reflectionArea];
	CGSize viewSize = self.reflectionArea.bounds.size;
	location = CGPointMake((location.x - viewSize.width / 2) / viewSize.width,
						   (location.y - viewSize.height / 2) / viewSize.height);
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
    CALayer *layer = self.reflectionImageContainer.layer;
    
	layer.transform = CATransform3DRotate(CATransform3DMakeRotation(M_PI * location.x, 0, 1, 0), -M_PI * location.y, 1, 0, 0);
	// if I weren't using SMShadowedTransformLayer, here I would simply do:
	// [layer setTransform:layer.transform animatePerFrame:YES];
	[CATransaction commit];
}

- (void)tap:(UITapGestureRecognizer*)tap
{
	CGPoint location = [tap locationInView:self.reflectionArea];
	CGSize viewSize = self.reflectionArea.bounds.size;
	location = CGPointMake((location.x - viewSize.width / 2) / viewSize.width,
						   (location.y - viewSize.height / 2) / viewSize.height);
	[CATransaction begin];
	[CATransaction setAnimationDuration:1.f];
    CALayer *layer = self.reflectionImageContainer.layer;
    
	layer.transform = CATransform3DRotate(CATransform3DMakeRotation(M_PI * location.x, 0, 1, 0), -M_PI * location.y, 1, 0, 0);
	// if I weren't using SMShadowedTransformLayer, here I would simply do:
	// [layer setTransform:layer.transform animatePerFrame:YES];
	[CATransaction commit];
}

#pragma mark -
#pragma mark Action and Controls
- (IBAction)returnHome:(id)sender {
    if (nil != delegate) {
        [delegate switchViewTo:kPageMain fromView:kPageUI];
    }
}

- (IBAction)clickCancelButton:(id)sender {
    [self setupControlsActivity];
    
    [self setupReflectionArea];
}

- (IBAction)clickOkButton:(id)sender {
    [self enableAllControls];
    [self disableControl:self.btnOK];
    
    for (UIGestureRecognizer *recognizer in self.reflectionImage.gestureRecognizers) {
        [self.reflectionImage removeGestureRecognizer:recognizer];
    }
    
    // enable more controls and set them to default states
    self.reflectionLayer = [self.reflectionImage addReflectionToSuperLayer];
    self.reflectionLayer.verticalOffset = 4.0f;
    [self.reflectionImageContainer setYRotation:25];
    
    // set control default values
    [self.sliderReflectionOpacity setValue:self.reflectionLayer.opacity animated:YES];
    [self.sliderReflectionHeight setValue:self.reflectionLayer.reflectionHeight animated:YES];
    [self.switchReflection setOn:YES animated:YES];
    
    // add gesture to reflection image containter
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.reflectionArea addGestureRecognizer:pan];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.reflectionArea addGestureRecognizer:tap];
}

- (IBAction)clickSaveAndShare:(id)sender {
    // save to local photo album and display modal view to share to Weibo (iOS 6 above)
}

- (IBAction)changeSliderReflectionOpacity:(UISlider *)sender {
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    self.reflectionLayer.opacity = ((UISlider*)sender).value;
    [CATransaction commit];
}

- (IBAction)changeSliderReflectionHeight:(UISlider *)sender {
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    self.reflectionLayer.reflectionHeight = sender.value;
    [CATransaction commit];
}

- (IBAction)changeSwitchReflection:(UISwitch *)sender {
    BOOL switchOn = sender.isOn;
    if (switchOn) {
        self.reflectionLayer = [self.reflectionImage addReflectionToSuperLayer];
        self.reflectionLayer.verticalOffset = 4.0f;
        [self.reflectionImageContainer setYRotation:25];
        
        // set control default values
        [self.sliderReflectionOpacity setValue:self.reflectionLayer.opacity animated:YES];
        [self.sliderReflectionHeight setValue:self.reflectionLayer.reflectionHeight animated:YES];
        [self.switchReflection setOn:YES animated:YES];
        // enable controls
        [self enableControl:self.sliderReflectionOpacity];
        [self enableControl:self.sliderReflectionHeight];
    }else{
        // switch off
        [self.reflectionImage clearReflecitonLayer];
        self.reflectionLayer =nil;
        [self.sliderReflectionOpacity setValue:0.0f animated:YES];
        [self.sliderReflectionHeight setValue:0.0f animated:YES];
        // disable controls
        [self disableControl:self.sliderReflectionHeight];
        [self disableControl:self.sliderReflectionOpacity];
    }
}

- (IBAction)clickMove:(id)sender {
}

@end
