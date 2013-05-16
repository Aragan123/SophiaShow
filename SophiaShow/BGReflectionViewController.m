//
//  BGReflectionViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/10.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGReflectionViewController.h"
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>
#import "JMWhenTapped.h"
#import "DSReflectionLayer.h"
#import "UIView+BGReflection.h"
#import "SVProgressHUD.h"
#import "AHAlertView.h"
#import "NSObject+Blocks.h"

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
    // set alert view style
    [AHAlertView applyCustomAlertAppearance];
    
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
    [_savedImage release];
    
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
    [_reflectionScrollContainer release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPopover:nil];
    [self setReflectionLayer:nil];
    [self setReflectionImageView:nil];
    [self setReflectionScrollView:nil];
    [self setScrollImageView:nil];
    [self setSavedImage:nil];
    
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
    [self setReflectionScrollContainer:nil];
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
    self.reflectionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 450.0, 400.0)];
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
    [self.reflectionScrollContainer addSubview:self.reflectionScrollView];
    
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
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                newImage=YES;
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = NO;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
                [imagePicker release];
            }else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"You don't have camera!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
            break;
        case 1://本地相簿
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                newImage=NO;
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.delegate = self;
                [imagePicker setAllowsEditing:NO];
//                imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
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
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSLog(@"found an image");
        [self.scrollImageView setImage:image];
        [self.scrollImageView setFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height)];        
        
        self.reflectionScrollView.contentMode = UIViewContentModeScaleAspectFit;
        [self.reflectionScrollView setContentSize:image.size];
        [self.reflectionScrollView setMinimumZoomScale:MIN((self.reflectionScrollView.frame.size.width / self.scrollImageView.frame.size.width), (self.reflectionScrollView.frame.size.height / self.scrollImageView.frame.size.height)) ];
        [self.reflectionScrollView setZoomScale:[self.reflectionScrollView minimumZoomScale]];
        self.scrollImageView.center = CGPointMake(self.reflectionScrollView.frame.size.width*0.5, self.reflectionScrollView.frame.size.height*0.5);

    }
    
    if (newImage) {
        // from camera
        NSLog(@"dismiss picker view controller");
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        // from photo library
        [self.popover dismissPopoverAnimated:YES];
        [self.popover release];
    }

    
    [self enableControl:self.btnOK]; // enable OK button
    [self enableControl:self.btnCancel]; // enable Cancel button
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (newImage) {
        // from camera
        NSLog(@"dismiss picker view controller");
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        // from photo library
        [self.popover dismissPopoverAnimated:YES];
        [self.popover release];
    }}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
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
    // dispay HUD at least x second.
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];

    [self performBlock:^{
        if (self.reflectionImageView == nil) {
            self.reflectionImageView = [[UIImageView alloc] initWithFrame:self.reflectionScrollContainer.frame];
        }
//        [self.reflectionImageView setImage:[self finishCropping]]; // set image
        [self.reflectionImageView setImage:[self screenshot:self.reflectionScrollContainer]];
        
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
        
        // dismiss HUD
        [SVProgressHUD dismiss];
    }
    afterDelay:0.5f];

}

- (UIImage*)finishCropping {
	float zoomScale = 1.0 / [self.reflectionScrollView zoomScale];
	
	CGRect rect;
	rect.origin.x = [self.reflectionScrollView contentOffset].x * zoomScale;
	rect.origin.y = [self.reflectionScrollView contentOffset].y * zoomScale;
	rect.size.width = [self.reflectionScrollView frame].size.width * zoomScale;
	rect.size.height = [self.reflectionScrollView frame].size.height * zoomScale;
	
	CGImageRef cr = CGImageCreateWithImageInRect([[self.scrollImageView image] CGImage], rect);
	UIImage *cropped = [UIImage imageWithCGImage:cr];
	CGImageRelease(cr);
    
    return cropped;
}

- (IBAction)clickSaveAndShare:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self performBlock:^{
        // save to local photo album and display modal view to share to Weibo (iOS 6 above)
//        self.savedImage = [self screenshot:self.reflectionScrollContainer];
        self.savedImage = [self glToUIImage:self.reflectionImageContainer];
        UIImageWriteToSavedPhotosAlbum(self.savedImage, nil, nil, nil); // save to photo album
        // show share buttons
        AHAlertView *alert = [[AHAlertView alloc] initWithTitle:NSLocalizedString(@"Already add it to your photo album", nil) message:NSLocalizedString(@"You can share it to SinaWeibo", nil)];
        [alert setDismissalStyle:AHAlertViewDismissalStyleZoomDown];
        [alert setCancelButtonTitle:NSLocalizedString(@"Not Share", nil) block:nil];
        [alert addButtonWithTitle:NSLocalizedString(@"Share to SinaWeibo", nil) block:^{
            [alert dismiss];
            [self shareToWeibo];
        }];
        
        [SVProgressHUD dismiss]; // dismiss HUD first
        [alert show];
        [alert release];
        
    } afterDelay:0.5f];

}

-(UIImage *) glToUIImage: (UIView*) view {
    int width = view.frame.size.width;
    int height = view.frame.size.height;
    NSInteger myDataLength = width * height * 4;
    
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    for(int y = 0; y <height; y++)
    {
        for(int x = 0; x <width * 4; x++)
        {
            buffer2[(height -1 - y) * width * 4 + x] = buffer[y * 4 * width + x];
        }
    }
    
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    // then make the uiimage from that
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    return myImage;
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
            [self.reflectionImageContainer setXRotation:-35.0f andYRotation:45.0f];
            break;
        case 2: // Up 45
            [self.reflectionImageContainer setXRotation:-45.0f];
            break;
        case 3: // Up Right
            [self.reflectionImageContainer setXRotation:-35.0f andYRotation:-45.0f];
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
             [self.reflectionImageContainer setXRotation:35.0f andYRotation:45.0f];
            break;
        case 8: // Down 45
            [self.reflectionImageContainer setXRotation:45.0f];
            break;
        case 9: // Down Right
             [self.reflectionImageContainer setXRotation:35.0f andYRotation:-45.0f];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Private Methods
// used to get screenshot
- (UIImage*)screenshot: (UIView*) view{
//    UIGraphicsBeginImageContext(view.bounds.size);
    /* in retina screen
     */
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(view.bounds.size);
    
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // hack, helps w/ our colors when blurring
    //    NSData *imageData = UIImageJPEGRepresentation(image, 1); // convert to jpeg
    NSData *imageData = UIImagePNGRepresentation(image); // convert to png
    image = [UIImage imageWithData:imageData];
    
    return image;
}

- (void)shareToWeibo{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo])
    {
        SLComposeViewController *socialVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        // add handler
        SLComposeViewControllerCompletionHandler socialHandler = ^(SLComposeViewControllerResult result) {
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = NSLocalizedString(@"Sharing Cancelled", nil);
                    break;
                case SLComposeViewControllerResultDone:
                    output = NSLocalizedString(@"Sharing Sucessful", nil);
                    break;
                default:
                    break;
            }
            
            [socialVC dismissViewControllerAnimated:YES completion:^(void){
                AHAlertView *alert = [[AHAlertView alloc] initWithTitle:output message:nil];
                [alert setDismissalStyle:AHAlertViewDismissalStyleZoomDown];
                [alert setCancelButtonTitle:NSLocalizedString(@"OK Button", nil) block:^{
                    [self.view endEditing:YES];
                }];
                [alert show];
                [alert release];
            }];
        };
        
        socialVC.completionHandler = socialHandler;
        [socialVC setInitialText:@"#Sophia的App#"];
        [socialVC addImage:self.savedImage];
        //        [socialVC addURL:[NSURL URLWithString:@"http://www.brutegame.com/"]];
        
        // finally display social view controller
        [self presentViewController:socialVC animated:YES completion:nil];
    }else{
        // if < iOS 6.0 and sharing is not available
        AHAlertView *alert = [[AHAlertView alloc] initWithTitle:NSLocalizedString(@"无法使用新浪微博分享功能，请升级到iOS 6.0或以上版本", nil) message:nil];
        [alert setDismissalStyle:AHAlertViewDismissalStyleZoomDown];
        [alert setCancelButtonTitle:NSLocalizedString(@"OK", nil) block:nil];
        [alert show];
        [alert release];
    }
    
}


@end
