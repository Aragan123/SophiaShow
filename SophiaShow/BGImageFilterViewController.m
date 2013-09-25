//
//  BGImageFilterViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/06/15.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGImageFilterViewController.h"
#import "BGFilterAreaViewController.h"
#import "HMSideMenu.h"
#import "SVProgressHUD.h"
#import "AHAlertView.h"
#import "NSObject+Blocks.h"
#import "BGGlobalData.h"
#import <Social/Social.h>
#import "MobClick.h"

@interface BGImageFilterViewController ()

@end

@implementation BGImageFilterViewController
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
    
    // setup initial values and arrange slider position
    [self setupInitialValues];
//    [self setupFilterSlider]; // drop it
    
    // setup side menu
    [self setupSideMenuBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload{
    [self setCarousel:nil];
    [self setICarousel_ds:nil];
    [self setFilterAreaViewController:nil];
    [self setPopover:nil];
    [self setSideMenu:nil];
    
    [self setBtnChoosePhoto:nil];
    [self setSliderParameter:nil];
    [self setBtnRotateFrame:nil];
    [self setMainBackPhoto:nil];
    [self setMainChooseBtn:nil];
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    [_carousel release];
    [_iCarousel_ds release];
    [_filterAreaViewController release];
    [_popover release];
    [_sideMenu release];
    
    [_btnChoosePhoto release];
    [_sliderParameter release];
    [_btnRotateFrame release];
    [_mainBackPhoto release];
    [_mainChooseBtn release];
    [super dealloc];
}

#pragma mark -
#pragma mark Arrange Views
- (void) setupInitialValues{
    selectedMenu=10;
    self.btnChoosePhoto.hidden = NO;
    self.btnRotateFrame.hidden = YES;
    isEdited = NO;
    newImage = NO;
    SelectionData data = {0,0,0,0};
    selectionData = data;
}

- (void) setupFilterSlider{
    // UISlider position
    self.sliderParameter = [[[UISlider alloc] init] autorelease];
    self.sliderParameter.frame = CGRectMake(200, 726, 480, 23);
    self.sliderParameter.maximumValue = 1.0f;
    self.sliderParameter.minimumValue = 0.0f;
    self.sliderParameter.continuous = NO;
    [self.sliderParameter addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    
    if ([[BGGlobalData sharedData] isPortrait]) {
        CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
        self.sliderParameter.transform = trans;
        self.sliderParameter.center = CGPointMake(80, self.sliderParameter.frame.size.height*0.5 + 100);
    }
    self.sliderParameter.hidden = YES;
    [self.view addSubview:self.sliderParameter];
}

- (void) setupSideMenuBar{
    // contruct HM SideMenu
    CGRect frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    // item 1
    UIView *itemBackPat = [[[UIView alloc] initWithFrame:frame] autorelease];
    UIButton *btnBackPat = [self createButtonWithFrame:frame Target:self Selector:@selector(showMoreOptionsBar:) pngImage:@"btn_menu1"];
    btnBackPat.tag=kMenuBgPattern;
    [itemBackPat addSubview:btnBackPat];
    // item 2
    UIView *itemFrame = [[[UIView alloc] initWithFrame:frame] autorelease];
    UIButton *btnFrame = [self createButtonWithFrame:frame Target:self Selector:@selector(showMoreOptionsBar:) pngImage:@"btn_menu2"];
    btnFrame.tag=kMenuPhotoFrame;
    [itemFrame addSubview:btnFrame];
    // item 3
    UIView *itemFilter = [[[UIView alloc] initWithFrame:frame] autorelease];
    UIButton *btnFilter = [self createButtonWithFrame:frame Target:self Selector:@selector(showMoreOptionsBar:) pngImage:@"btn_menu3"];
    btnFilter.tag=kMenuPhotoFilter;
    [itemFilter addSubview:btnFilter];
    // item 4
    UIView *itemSpecial = [[[UIView alloc] initWithFrame:frame] autorelease];
    UIButton *btnSpecial = [self createButtonWithFrame:frame Target:self Selector:@selector(showMoreOptionsBar:) pngImage:@"btn_menu4"];
    btnSpecial.tag=kMenuSpecial;
    [itemSpecial addSubview:btnSpecial];
    
    // item 5
    UIView *itemSave = [[[UIView alloc] initWithFrame:frame] autorelease];
    UIButton *btnSave = [self createButtonWithFrame:frame Target:self Selector:@selector(saveImageToPhotoAlbum:) pngImage:@"btn_save"];
    [itemSave addSubview:btnSave];
    // item 6
    UIView *itemCancelAll = [[[UIView alloc] initWithFrame:frame] autorelease];
    UIButton *btnCancelAll = [self createButtonWithFrame:frame Target:self Selector:@selector(clickCancelAll:) pngImage:@"btn_cancelAll"];
    [itemCancelAll addSubview:btnCancelAll];
    
    // placeholder
    UIView *itemPlaceholder = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 40.0f)] autorelease];
    itemPlaceholder.backgroundColor = [UIColor clearColor];
    
    HMSideMenu *menus = [[HMSideMenu alloc] initWithItems:@[itemBackPat, itemFrame, itemSpecial, itemFilter, itemPlaceholder, itemSave, itemCancelAll]];
    [menus setItemSpacing:5.0f];
    self.sideMenu = menus;
    [self.view addSubview:self.sideMenu];
    [menus release];
}

- (void) setupFilterArea: (UIImage*)image{
    if (self.filterAreaViewController == nil) {
        BGFilterAreaViewController *controller = [[BGFilterAreaViewController alloc] init];
        self.filterAreaViewController = controller;
        [controller release];
    }
    
    [self.filterAreaViewController setupViewsWithSourceImage:image];
    [self.view addSubview:self.filterAreaViewController.view];
}

#pragma mark -
#pragma mark IBOutlet Actions
// when landscape or portrait button is pressed
- (IBAction) selectFilterAreaOrientation :(UIButton*)sender{
    [self hideMoreOptionBar];
    BOOL check = [[BGGlobalData sharedData] isPortrait];
    
    NSString *title = @"改成横版相框";
    if (!check) {
        title = @"改成竖版相框";
    }
    
    AHAlertView *alert = [[[AHAlertView alloc] initWithTitle:title message:@"注意：此操作将撤销所有对照片的操作！"] autorelease];
    [alert setDismissalStyle:AHAlertViewDismissalStyleFade];
    [alert setCancelButtonTitle:NSLocalizedString(@"取消", nil) block:nil];
    [alert addButtonWithTitle:NSLocalizedString(@"继续", nil) block:^{
        // display HUD for half second
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [self performBlock:^{
            // reset oritentation
            [[BGGlobalData sharedData] setIsPortrait:!check];
            
            // setp 1: set up  values and slider again
//            [self.sliderParameter removeFromSuperview]; self.sliderParameter = nil;
            [self setupInitialValues];
//            [self setupFilterSlider];
            self.btnRotateFrame.hidden=NO; // need to show this button
            // step 2: re-arrange Filter Area
            UIImage *image = self.filterAreaViewController.originalImage;
            
            // clean filter area view controller
            [self.filterAreaViewController.view removeFromSuperview];
            self.filterAreaViewController = nil;
            // reasign
            [self setupFilterArea:image];
            [SVProgressHUD dismiss]; // dismiss HUD
        } afterDelay:0.5f];

    }];
    [alert show];
}

// when side menu button is pressed
- (IBAction) showMoreOptionsBar: (UIButton*) sender{
    int tag = sender.tag; // get tag
    if (selectedMenu == tag) return;
    
    // get correct data source first
    selectedMenu = tag;
    NSDictionary *res = [[BGGlobalData sharedData] filterResourceIcons];
    NSString* key = [[BGGlobalData sharedData] getFilterKeyStringByKeyIndex:tag];
    self.iCarousel_ds = [res objectForKey:key];

    // construct carousel
    if (self.carousel == nil) {
        // first time to run
        self.carousel = [[iCarousel alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, 110, self.view.frame.size.height)];
        self.carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.carousel.type = iCarouselTypeLinear;
        self.carousel.bounces= NO;
        self.carousel.vertical = YES;
        self.carousel.centerItemWhenSelected = NO;
        self.carousel.backgroundColor = [UIColor clearColor];
        self.carousel.delegate = self;
        self.carousel.dataSource = self;
        self.carousel.currentItemIndex = 2;
        self.carousel.scrollToItemBoundary = NO;
        [self.view addSubview:self.carousel];
        [self displayMoreOptionBar];
    } else if (self.carousel.superview != nil) {
        // is currently displayed, so firstly hide it
        [self hideThenDisplayMoreOptionBar];
    } else {
        // is currently hiding
        [self.carousel reloadData];
        self.carousel.currentItemIndex = 2;
        [self.view addSubview:self.carousel];
        [self displayMoreOptionBar];
    }
    
}

// act when return button in side menu is pressed
- (IBAction)clickReturnButton:(id)sender{
    if (nil != delegate && isEdited) {
        AHAlertView *alert = [[[AHAlertView alloc] initWithTitle:@"确定要返回主页面？" message:@"此操作将撤销所有对照片的操作"] autorelease];
        [alert setDismissalStyle:AHAlertViewDismissalStyleFade];
        [alert setCancelButtonTitle:NSLocalizedString(@"取消", nil) block:nil];
        [alert addButtonWithTitle:NSLocalizedString(@"确定", nil) block:^{
            [alert dismiss]; // dismiss alert view
            [MobClick endEvent:@"FilterDuration"]; //Umeng end event
            [delegate switchViewTo:kPageMain fromView:kPageUI];
        }];
        [alert show];
    }else if (nil != delegate) {
        [MobClick endEvent:@"FilterDuration"]; // Umeng end event
        [delegate switchViewTo:kPageMain fromView:kPageUI];
    }

}

// when image saving button in side menu is pressed
- (IBAction)saveImageToPhotoAlbum:(id)sender {
    // show alert before save
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [self performBlock:^{
        UIImage *savedImage = [self.filterAreaViewController screenshot];
        UIImageWriteToSavedPhotosAlbum (savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    } afterDelay:0.5f];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message...
        NSLog(@"Image save with error");
        AHAlertView *alert = [[[AHAlertView alloc] initWithTitle:@"保存时发生错误" message:@"照片没有保存到你的相册，请稍后再试或重启本程序"] autorelease];
        [alert setDismissalStyle:AHAlertViewDismissalStyleFade];
        [alert setCancelButtonTitle:NSLocalizedString(@"我知道了", nil) block:nil];
        [SVProgressHUD dismiss];
        [alert show];
    }
    else  // No errors
    {
        // Show message image successfully saved
        NSLog(@"Image Saved successfully!!!");
        isEdited=NO;
        AHAlertView *alert = [[[AHAlertView alloc] initWithTitle:@"保存成功" message:@"照片已经保存到你的相册"] autorelease];
        [alert setDismissalStyle:AHAlertViewDismissalStyleFade];
        [alert addButtonWithTitle:NSLocalizedString(@"分享到新浪微博", nil) block:^{
            [alert dismiss]; // dismiss alert first
            [self shareToWeibo:image]; // share to weibo
        }];
        [alert setCancelButtonTitle:NSLocalizedString(@"返  回", nil) block:nil];
        [SVProgressHUD dismiss];
        [alert show];
    }
}

// act when select photo button is pressed
- (IBAction)clickChoosePhoto:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        // display an action sheet 
        UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"请选择文件来源"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"本地相簿",@"照相机",nil];
        [actionSheet showInView:self.view];
        [actionSheet release];
    }else{
        // if no camera, then select from photo album directly
        [self selectImageFromPhotoAlbum];
    }

}

// act when cancel all actions
- (IBAction)clickCancelAll:(UIButton*)sender {
    if (!isEdited) {
        // if not edited, do cancel all actions right away
        [self cancelAllActions];
        self.mainChooseBtn.hidden=NO;
        self.mainBackPhoto.hidden=NO;
    }else{
        // otherwise, need to show a warning alert to user to input 
        AHAlertView *alert = [[[AHAlertView alloc] initWithTitle:@"确定要取消对照片的所有操作？" message:nil] autorelease];
        [alert setDismissalStyle:AHAlertViewDismissalStyleFade];
        [alert setCancelButtonTitle:NSLocalizedString(@"返回", nil) block:nil];
        [alert addButtonWithTitle:NSLocalizedString(@"确定", nil) block:^{        
            [self cancelAllActions];
            self.mainChooseBtn.hidden=NO;
            self.mainBackPhoto.hidden=NO;
            [alert dismiss]; // dismiss alert view
        }];
        [alert show];
    }
}

// invoked by IBAction cancel All button is clicked. 
- (void) cancelAllActions{
    NSLog(@"hide cancel all button");
    if (self.filterAreaViewController != nil) {
        [self.filterAreaViewController.view removeFromSuperview];
        self.filterAreaViewController = nil;
    }
    // hide more option bar
    [self hideMoreOptionBar];
    // hide side menu bar
    [self.sideMenu close];
    
    self.btnChoosePhoto.hidden=NO;
    self.btnRotateFrame.hidden=YES;
//    self.sliderParameter.hidden=YES; // drop it
    isEdited=NO;

}

// act when slider value changed (visible for filter use only)
- (IBAction)sliderValueChange:(UISlider *)sender {
    [self.filterAreaViewController updateFilterOpacity:sender.value];
}


#pragma mark -
#pragma mark Utility and Private Methods
- (UIButton*) createButtonWithFrame: (CGRect) frame Target:(id)target Selector:(SEL)selector pngImage:(NSString *)imageName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void) displayMoreOptionBar{
    if (self.carousel !=nil) {
        [UIView animateWithDuration:0.4f animations:^{
            self.carousel.layer.position = CGPointMake (self.view.frame.size.width - self.carousel.frame.size.width*0.5 - 60.0f, self.view.frame.size.height*0.5);
        }];
    }
}

- (void) hideMoreOptionBar{
    if (self.carousel!=nil && self.carousel.superview != nil) {
        [UIView animateWithDuration:0.3f animations:^{
            self.carousel.layer.position = CGPointMake (self.view.frame.size.width + self.carousel.frame.size.width*0.5, self.view.frame.size.height*0.5);
        } completion:^(BOOL finished) {
            // remove from supperview
            [self.carousel removeFromSuperview];
            selectedMenu=10;
        }];
    }
}

- (void) hideThenDisplayMoreOptionBar{
    if (self.carousel!=nil && self.carousel.superview != nil) {
        [UIView animateWithDuration:0.3f animations:^{
            self.carousel.layer.position = CGPointMake (self.view.frame.size.width +self.carousel.frame.size.width*0.5, self.view.frame.size.height*0.5);
        } completion:^(BOOL finished) {
            [self.carousel reloadData];
            self.carousel.currentItemIndex = 2;
            [self displayMoreOptionBar];
        }];
    }
}

// share to Sina Weibo
- (void)shareToWeibo: (UIImage*) savedImage{
    [SVProgressHUD show]; // display HUD
    
    [self performBlock:^{
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]){
            // > iOS 6, sharing is available
            SLComposeViewController *socialVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
            // add handler
            SLComposeViewControllerCompletionHandler socialHandler = ^(SLComposeViewControllerResult result) {
                NSString *output;
                BOOL cancelled = NO;
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        output = NSLocalizedString(@"分享过程被终止", nil);
                        cancelled = YES;
                        break;
                    case SLComposeViewControllerResultDone:
                        output = NSLocalizedString(@"已经成功分享到新浪微博", nil);
                        break;
                    default:
                        break;
                }
                
                [socialVC dismissViewControllerAnimated:YES completion:^(void){
                    if (!cancelled) {
                        AHAlertView *alert = [[AHAlertView alloc] initWithTitle:output message:nil];
                        [alert setDismissalStyle:AHAlertViewDismissalStyleZoomDown];
                        [alert setCancelButtonTitle:NSLocalizedString(@"确  定", nil) block:^{
                            [self.view endEditing:YES];
                        }];
                        [alert show];
                        [alert release];
                    }
                }];
            };
            
            socialVC.completionHandler = socialHandler;
            [socialVC setInitialText:@"#Yeephoto#"];
            [socialVC addImage:savedImage];
            [socialVC addURL:[NSURL URLWithString:@"http://www.yeephoto.com/"]];
            
            // finally display social view controller
            [SVProgressHUD dismiss];
            [self presentViewController:socialVC animated:YES completion:nil];
        
        }else{
            // < iOS 6, sharing is not available
            [SVProgressHUD dismiss];
            AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"无法分享" message:@"请升级您的设备系统到iOS 6.0或以上版本"];
            [alert setDismissalStyle:AHAlertViewDismissalStyleFade];
            [alert setCancelButtonTitle:NSLocalizedString(@"返  回", nil) block:nil];
            [alert show];
            [alert release];
        }
    } afterDelay:0.2f];

}

#pragma mark -
#pragma mark iCarousel delegate and its DataSrouce delegate methods
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return ([self.iCarousel_ds count] + 1); // +1 because first one is the button to close more option bar
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil){
        view = [[[UIImageView alloc] init] autorelease];
        view.frame = CGRectMake(0.0f, 0.0f, 110.0f, 110.0f);
        view.contentMode = UIViewContentModeCenter;
        [view setBackgroundColor:[UIColor clearColor]];
        // add image view
        UIImageView *imageView = [[[UIImageView alloc] init] autorelease];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.tag = kRemoveViewTag;
        [view addSubview:imageView];
    }
    
    UIImageView *imageView = (UIImageView*)[view viewWithTag:kRemoveViewTag];
    // add items
    if (index == 0) {
        // first one is alwasy close button
        imageView.frame = CGRectMake(50.0f, 50.0f, 60.0f, 60.0f);
        imageView.image = [UIImage imageNamed:@"optionbar_close.png"];
        
    }else{
        // add options' images
        imageView.frame = CGRectMake(10.0f,10.0f, 90.0f, 90.0f);
        NSString *imageURI = [self.iCarousel_ds objectAtIndex:(index-1)];
        imageView.image = [UIImage imageNamed:imageURI]; //get images
    }

    return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"select filter index: %i", index);
    
    if (index == 0) {// close option menu bar
        [self hideMoreOptionBar];
        return;
    }else{
        index--;
        isEdited=YES;
    }
    
    if (selectedMenu == kMenuSpecial) {
        selectionData.special = index;
        
        if (index == 0) { // this is option to remove all specials
            [self.filterAreaViewController updatePhotoSpecials:nil];
            if (selectionData.background == 0) { // need to remove line_pattern
                [self.filterAreaViewController updateBackgroundPattern:nil patternLine:NO];
            }
        }else{
            // display HUD
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
            [self performBlock:^{
                NSDictionary *dataArr = [[BGGlobalData sharedData] getSpecialDataByIndex:index];
                [self.filterAreaViewController updatePhotoSpecials:dataArr]; // update/display special effects
                if (selectionData.background==0) {
                    // need to change to line pattern image
                    [self.filterAreaViewController updateBackgroundPattern:nil patternLine:YES];
                }
                [SVProgressHUD dismiss]; // dismiss HUD
            } afterDelay:0.5f];
        }
    }
    else if (selectedMenu == kMenuPhotoFilter){
        selectionData.filter = index;
        
        // for Photo filters
        if (index == 0) { // this is option to remove filters
            BGFilterData data = {0, nil, nil, 0.0f, 1};
            [self.filterAreaViewController updatePhotoFilter:data];
//            self.sliderParameter.hidden = YES;
        }else{
            // display HUD
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
            [self performBlock:^{
                // update filter
                BGFilterData data = [[BGGlobalData sharedData] getFilterDataByIndex:index];
                [self.filterAreaViewController updatePhotoFilter:data];
                // show slider
//                self.sliderParameter.hidden = NO;
//                self.sliderParameter.maximumValue = data.alpha;
//                self.sliderParameter.value = data.alpha;
                [SVProgressHUD dismiss]; // dismiss HUD
            } afterDelay:0.5f];
        }
    }
    else if (selectedMenu == kMenuPhotoFrame){
        selectionData.frame = index;
        
        if (index==0) {
            BGPhotoFrameData data = {nil,0.0f,CGSizeZero};
            [self.filterAreaViewController updatePhotoFrame:data];
        }else{
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
            [self performBlock:^{
                BGPhotoFrameData data = [[BGGlobalData sharedData] getPhotoFrameByIndex:index];
                [self.filterAreaViewController updatePhotoFrame:data];
                
                [SVProgressHUD dismiss]; // dismiss HUD
            } afterDelay:0.4f];
        }
    } else{
        // kMenuBgPattern: for Background Patterns
        selectionData.background = index;
        
        if (index==0) {
            if (selectionData.special == 0) {
                // if no special selected, then update with nil
                [self.filterAreaViewController updateBackgroundPattern:nil patternLine:NO];
            }else{
                // otherwise, update with line_pattern image
                [self.filterAreaViewController updateBackgroundPattern:nil patternLine:YES];
            }
        }else{
            UIImage *data = [[BGGlobalData sharedData] getFilterResourceByIndex:index andKeyIndex:selectedMenu];
            [self.filterAreaViewController updateBackgroundPattern:data patternLine:NO];
        }
    }
    
//    [self.carousel reloadData];
}

#pragma mark -
#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"buttonIndex = [%d]",buttonIndex);
    switch (buttonIndex) {
        case 0: // local photo album
            [self selectImageFromPhotoAlbum];
            break;
        case 1:// camera selected
            [self selectImageFromCamera];
            break;
        default:
            break;
    }
}

// Utility to select image from photo album
- (void) selectImageFromPhotoAlbum{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        newImage = NO;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [self performBlock:^{
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            [imagePicker setAllowsEditing:NO];
            //                imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
            self.popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            [self.popover presentPopoverFromRect:CGRectMake(0, 0, 400, 500) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            [imagePicker release];
            [SVProgressHUD dismiss]; // dismiss HUD
        } afterDelay:0.3f];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"错误：无法正常进入你的照片集!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

// Utility to select image from camera
- (void) selectImageFromCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIDevice *currentDevice = [UIDevice currentDevice];
        while ([currentDevice isGeneratingDeviceOrientationNotifications])
            [currentDevice endGeneratingDeviceOrientationNotifications];

        newImage=YES;
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
        [imagePicker release];
        while ([currentDevice isGeneratingDeviceOrientationNotifications])
            [currentDevice endGeneratingDeviceOrientationNotifications];
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"你的设备无法使用摄像头!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}


#pragma mark -
#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (newImage) {
        // from camera
        [self dismissViewControllerAnimated:YES completion:nil];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    }else{
        // dismiss photo library
        [self.popover dismissPopoverAnimated:YES];
        [self.popover release];
    }
    
    // display HUD
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    [self performBlock:^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        NSLog(@"selected image type: %@", mediaType);
        
        if ([mediaType isEqualToString:@"public.image"]){
            // hide
            self.mainBackPhoto.hidden=YES;
            self.mainChooseBtn.hidden=YES;
            
            UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            
            self.btnChoosePhoto.hidden = YES;
            self.btnRotateFrame.hidden = NO;
            isEdited=YES;
            // add filter area view controller
            [self setupFilterArea:image];

            // dismiss HUD
            [SVProgressHUD dismiss];
            
            // show side menubar
            [self.view performBlock:^{
                [self.sideMenu open];
            } afterDelay:0.5f];
                        
        }else{
            [SVProgressHUD dismiss];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择系统可以识别的图片!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    } afterDelay:0.5f];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (newImage) {
        // from camera
        [self dismissViewControllerAnimated:YES completion:nil];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }else{
        // from photo library
        [self.popover dismissPopoverAnimated:YES];
        [self.popover release];
    }
}


@end
