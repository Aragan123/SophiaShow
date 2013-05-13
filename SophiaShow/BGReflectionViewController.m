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
    [_reflectionImageView release];
    [_reflectionScrollView release];
    [_scrollImageView release];
    
    [_reflectionImageContainer release];
    [_btnCancel release];
    [_btnOK release];
    [_btnSaveAndShare release];
    [_switchReflection release];
    [_sliderReflectionOpacity release];
    [_reflectionArea release];
    [_sliderReflectionHeight release];
    [_btnMoveA release];
    [_btnMoveB release];
    [_btnMoveC release];
    [_btnMoveD release];
    [_btnMoveE release];
    [_btnMoveF release];
    [_btnMoveG release];
    [_btnMoveH release];
    [_btnMoveI release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPopover:nil];
    [self setReflectionLayer:nil];
    [self setReflectionImageView:nil];
    [self setReflectionScrollView:nil];
    [self setScrollImageView:nil];
    
    [self setReflectionImageContainer:nil];
    [self setBtnCancel:nil];
    [self setBtnOK:nil];
    [self setBtnSaveAndShare:nil];
    [self setSwitchReflection:nil];
    [self setSliderReflectionOpacity:nil];
    [self setReflectionArea:nil];
    [self setSliderReflectionHeight:nil];
    [self setBtnMoveA:nil];
    [self setBtnMoveB:nil];
    [self setBtnMoveC:nil];
    [self setBtnMoveD:nil];
    [self setBtnMoveE:nil];
    [self setBtnMoveF:nil];
    [self setBtnMoveG:nil];
    [self setBtnMoveH:nil];
    [self setBtnMoveI:nil];
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
    // reflection scroll and image views
    self.reflectionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(160.0, 80.0, 450.0, 400.0)];
    [self.reflectionScrollView setBackgroundColor:[UIColor clearColor]];
    [self.reflectionScrollView setDelegate:self];
    [self.reflectionScrollView setShowsHorizontalScrollIndicator:NO];
    [self.reflectionScrollView setShowsVerticalScrollIndicator:NO];
    [self.reflectionScrollView setMaximumZoomScale:2.0f];
        
    // reflection image view
    UIImage *firstImage = [UIImage imageNamed:@"ui_cross_a.png"];
    self.scrollImageView = [[UIImageView alloc] initWithImage:firstImage];
    [self.scrollImageView setFrame:CGRectMake(0.0, 0.0, 450.0, 400.0)];
    [self.scrollImageView whenTapped:^{
        UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"请选择文件来源"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"照相机",@"本地相簿",nil];
        [actionSheet showInView:self.view];
        [actionSheet release];
    }];
    
    [self.reflectionScrollView addSubview:self.scrollImageView];
    [self.reflectionImageContainer addSubview:self.reflectionScrollView];
    
    // remove reflctionImageView
    if (self.reflectionImageView.superview != nil) {
        [self.reflectionImageView clearReflecitonLayer];
        self.reflectionLayer =nil;
        [self.reflectionImageView removeFromSuperview];
        
        [self.reflectionImageContainer setXRotation:0.0f];
        [self.reflectionImageContainer setYRotation:0.0f];
    }
    
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
    [self disableControl:self.btnOK];
    [self disableControl:self.btnCancel];
    
    [self disableControl:self.btnMoveA];
    [self disableControl:self.btnMoveB];
    [self disableControl:self.btnMoveC];
    [self disableControl:self.btnMoveD];
    [self disableControl:self.btnMoveE];
    [self disableControl:self.btnMoveF];
    [self disableControl:self.btnMoveG];
    [self disableControl:self.btnMoveH];
    [self disableControl:self.btnMoveI];
}

- (void) enableAllControls{
    [self enableControl:self.btnSaveAndShare];
    [self enableControl:self.switchReflection];
    [self enableControl:self.sliderReflectionOpacity];
    [self enableControl:self.sliderReflectionHeight];
    [self enableControl:self.btnOK];
    [self enableControl:self.btnCancel];
    
    [self enableControl:self.btnMoveA];
    [self enableControl:self.btnMoveB];
    [self enableControl:self.btnMoveC];
    [self enableControl:self.btnMoveD];
    [self enableControl:self.btnMoveE];
    [self enableControl:self.btnMoveF];
    [self enableControl:self.btnMoveG];
    [self enableControl:self.btnMoveH];
    [self enableControl:self.btnMoveI];
}


#pragma mark -
#pragma mark UIScrollView Delegate methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.scrollImageView;
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
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSLog(@"selected image type: %@", mediaType);
    
    if ([mediaType isEqualToString:@"public.image"]){
        // UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSLog(@"found an image");
        [self.scrollImageView setImage:image];
        [self.scrollImageView setFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
        self.reflectionScrollView.contentMode = UIViewContentModeScaleAspectFit;
        [self.reflectionScrollView setContentSize:self.scrollImageView.frame.size];
        [self.reflectionScrollView setMinimumZoomScale:self.reflectionScrollView.frame.size.width / self.scrollImageView.frame.size.width];
        [self.reflectionScrollView setZoomScale:[self.reflectionScrollView minimumZoomScale]];
        self.scrollImageView.center = CGPointMake(self.reflectionScrollView.frame.size.width*0.5, self.reflectionScrollView.frame.size.height*0.5);

    }
    
//    UIImage  *img = [info objectForKey:UIImagePickerControllerEditedImage];
    
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
//	location = CGPointMake((location.x - viewSize.width*0.5) / viewSize.width,
//						   (location.y - viewSize.height*0.5) / viewSize.height);
//	[CATransaction begin];
//	[CATransaction setDisableActions:YES];
//    CALayer *layer = self.reflectionImageContainer.layer;
//    
//	layer.transform = CATransform3DRotate(CATransform3DMakeRotation(M_PI * location.x, 0, 1, 0), -M_PI * location.y, 1, 0, 0);
//	[CATransaction commit];
    
    location = CGPointMake((location.x - viewSize.width*0.5) / viewSize.width, (location.y - viewSize.height*0.5) / viewSize.height);
    [self.reflectionImageContainer setXRotation:(180*location.y) andYRotation:(-180*location.x)];
}

- (void)tap:(UITapGestureRecognizer*)tap
{
	CGPoint location = [tap locationInView:self.reflectionArea];
	CGSize viewSize = self.reflectionArea.bounds.size;
//	location = CGPointMake((location.x - viewSize.width*0.5) / viewSize.width,
//						   (location.y - viewSize.height*0.5) / viewSize.height);
//	[CATransaction begin];
//	[CATransaction setAnimationDuration:1.f];
//    CALayer *layer = self.reflectionImageContainer.layer;
//    
//	layer.transform = CATransform3DRotate(CATransform3DMakeRotation(M_PI * location.x, 0, 1, 0), -M_PI * location.y, 1, 0, 0);
//	[CATransaction commit];
    location = CGPointMake((location.x - viewSize.width*0.5) / viewSize.width, (location.y - viewSize.height*0.5) / viewSize.height);
    [self.reflectionImageContainer setXRotation:(180*location.y) andYRotation:(-180*location.x)];
}

#pragma mark -
#pragma mark Action and Controls
- (IBAction)returnHome:(id)sender {
    if (nil != delegate) {
        [delegate switchViewTo:kPageMain fromView:kPageUI];
    }
}

- (IBAction)clickCancelButton:(id)sender {
    [self.scrollImageView removeFromSuperview];
    self.scrollImageView=nil;
    [self.reflectionScrollView removeFromSuperview];
    self.reflectionScrollView=nil;
    
    [self setupControlsActivity];
    [self setupReflectionArea];
}

- (IBAction)clickOkButton:(id)sender {
    if (self.reflectionImageView == nil) {
        self.reflectionImageView = [[UIImageView alloc] initWithFrame:self.reflectionScrollView.frame];
    }
    [self.reflectionImageView setImage:[self finishCropping]]; // set image
    
    [self.reflectionImageContainer addSubview:self.reflectionImageView];
    [self.scrollImageView removeFromSuperview];
    self.scrollImageView=nil;
    [self.reflectionScrollView removeFromSuperview];
    self.reflectionScrollView=nil;
    
    [self enableAllControls];
    [self disableControl:self.btnOK];
    
    for (UIGestureRecognizer *recognizer in self.reflectionImageView.gestureRecognizers) {
        [self.reflectionImageView removeGestureRecognizer:recognizer];
    }
    
    
    // enable more controls and set them to default states
    self.reflectionLayer = [self.reflectionImageView addReflectionToSuperLayer];
    self.reflectionLayer.verticalOffset = 4.0f;
    [self.reflectionImageContainer setYRotation:25.0f];
    
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

- (UIImage*)finishCropping {
	float zoomScale = 1.0 / [self.reflectionScrollView zoomScale];
	
	CGRect rect;
	rect.origin.x = [self.reflectionScrollView contentOffset].x * zoomScale;
	rect.origin.y = [self.reflectionScrollView contentOffset].y * zoomScale;
	rect.size.width = [self.reflectionScrollView bounds].size.width * zoomScale;
	rect.size.height = [self.reflectionScrollView bounds].size.height * zoomScale;
	
	CGImageRef cr = CGImageCreateWithImageInRect([[self.scrollImageView image] CGImage], rect);
	UIImage *cropped = [UIImage imageWithCGImage:cr];
	CGImageRelease(cr);
    
    return cropped;
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
        self.reflectionLayer = [self.reflectionImageView addReflectionToSuperLayer];
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
        [self.reflectionImageView clearReflecitonLayer];
        self.reflectionLayer =nil;
        [self.sliderReflectionOpacity setValue:0.0f animated:YES];
        [self.sliderReflectionHeight setValue:0.0f animated:YES];
        // disable controls
        [self disableControl:self.sliderReflectionHeight];
        [self disableControl:self.sliderReflectionOpacity];
    }
}

- (IBAction)clickBtnMove:(UIButton *)sender {
    int tag = sender.tag;
    switch (tag) {
        case 1: // UpLeft
            [self.reflectionImageContainer setXRotation:-25.0f andYRotation:45.0f];
            break;
        case 2: // Up 45
            [self.reflectionImageContainer setXRotation:-45.0f];
            break;
        case 3: // Up Right
            [self.reflectionImageContainer setXRotation:-25.0f andYRotation:-45.0f];
            break;
        case 4: // Left 45
            [self.reflectionImageContainer setYRotation:45.0f];
            break;
        case 5: // Centre
            [self.reflectionImageContainer setYRotation:0.0f];
            break;
        case 6: // Right 45
            [self.reflectionImageContainer setYRotation:-45.0f];
            break;
        case 7: // Down Left
             [self.reflectionImageContainer setXRotation:25.0f andYRotation:45.0f];
            break;
        case 8: // Down 45
            [self.reflectionImageContainer setXRotation:45.0f];
            break;
        case 9: // Down Right
             [self.reflectionImageContainer setXRotation:25.0f andYRotation:-45.0f];
            break;
        default:
            break;
    }
}

@end
