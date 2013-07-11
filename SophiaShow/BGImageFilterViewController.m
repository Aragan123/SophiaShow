//
//  BGImageFilterViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/06/15.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGImageFilterViewController.h"
#import "HMSideMenu.h"
#import "SVProgressHUD.h"
#import "AHAlertView.h"
#import "NSObject+Blocks.h"
#import "BGGlobalData.h"
#import "JMWhenTapped.h"

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
    [self setupFilterSlider];
    
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
    [super dealloc];
}

#pragma mark -
#pragma mark Arrange Views
- (void) setupInitialValues{
    selectedMenu=10;
    self.btnChoosePhoto.hidden = NO;
    self.btnRotateFrame.hidden = YES;
    isEdited = NO;
}

- (void) setupFilterSlider{
    // UISlider position
    self.sliderParameter = [[UISlider alloc] init];
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
    UIButton *btnBackPat = [self createButtonWithFrame:frame Target:self Selector:@selector(clickMenuButton:) Image:@"btn_menu1" ImagePressed:@"btn_menu1"];
    btnBackPat.tag=kMenuBgPattern;
    [itemBackPat addSubview:btnBackPat];
    // item 2
    UIView *itemFrame = [[[UIView alloc] initWithFrame:frame] autorelease];
    UIButton *btnFrame = [self createButtonWithFrame:frame Target:self Selector:@selector(clickMenuButton:) Image:@"btn_menu2" ImagePressed:@"btn_menu2"];
    btnFrame.tag=kMenuPhotoFrame;
    [itemFrame addSubview:btnFrame];
    // item 3
    UIView *itemFilter = [[[UIView alloc] initWithFrame:frame] autorelease];
    UIButton *btnFilter = [self createButtonWithFrame:frame Target:self Selector:@selector(clickMenuButton:) Image:@"btn_menu3" ImagePressed:@"btn_menu3"];
    btnFilter.tag=kMenuPhotoFilter;
    [itemFilter addSubview:btnFilter];
    // item 4
    UIView *itemSpecial = [[[UIView alloc] initWithFrame:frame] autorelease];
    UIButton *btnSpecial = [self createButtonWithFrame:frame Target:self Selector:@selector(clickMenuButton:) Image:@"btn_menu4" ImagePressed:@"btn_menu4"];
    btnSpecial.tag=kMenuSpecial;
    [itemSpecial addSubview:btnSpecial];
    
    // item 5
    UIView *itemSave = [[[UIView alloc] initWithFrame:frame] autorelease];
    UIButton *btnSave = [self createButtonWithFrame:frame Target:self Selector:@selector(saveImageToPhotoAlbum:) Image:@"btn_save" ImagePressed:@"btn_save"];
    [itemSave addSubview:btnSave];
    // item 6
    UIView *itemCancelAll = [[[UIView alloc] initWithFrame:frame] autorelease];
    UIButton *btnCancelAll = [self createButtonWithFrame:frame Target:self Selector:@selector(clickCancelAll:) Image:@"btn_cancelAll" ImagePressed:@"btn_cancelAll"];
    [itemCancelAll addSubview:btnCancelAll];
    
    // placeholder
    UIView *itemPlaceholder = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 40.0f)] autorelease];
    itemPlaceholder.backgroundColor = [UIColor clearColor];
    
    self.sideMenu = [[[HMSideMenu alloc] initWithItems:@[itemBackPat, itemFrame, itemFilter, itemSpecial, itemPlaceholder, itemSave, itemCancelAll]] autorelease];
    [self.sideMenu setItemSpacing:5.0f];
    [self.view addSubview:self.sideMenu];
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
    
    AHAlertView *alert = [[[AHAlertView alloc] initWithTitle:title message:@"注意：此操作将撤销照片所有未保存的操作！"] autorelease];
    [alert setDismissalStyle:AHAlertViewDismissalStyleFade];
    [alert setCancelButtonTitle:NSLocalizedString(@"取消", nil) block:nil];
    [alert addButtonWithTitle:NSLocalizedString(@"继续", nil) block:^{
        // display HUD for half second
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [self performBlock:^{
            // reset oritentation
            [[BGGlobalData sharedData] setIsPortrait:!check];
            
            // setp 1: set up  values and slider again
            [self.sliderParameter removeFromSuperview]; self.sliderParameter = nil;
            [self setupInitialValues];
            [self setupFilterSlider];
            self.btnRotateFrame.hidden=NO; // need to show this button
            // step 2: re-arrange Filter Area
            UIImage *image = self.filterAreaViewController.originalImage;
            //    [self.filterAreaViewController clearContents];
            //        [self.filterAreaViewController setupViewsWithSourceImage:image];
            
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
- (IBAction) clickMenuButton:(UIButton*)sender{
    int tag = sender.tag;
    NSLog(@"Menu button is clicked at tag=%i", tag);
    
    switch (tag) {
        case 0:
        case 1:
        case 2:
        case 3:
            [self showMoreOptionsBar:tag];
            break;
        default:
            break;
    }
    
}

// act when return button in side menu is pressed
- (IBAction)clickReturnButton:(id)sender{
    if (nil != delegate && isEdited) {
        AHAlertView *alert = [[[AHAlertView alloc] initWithTitle:@"确定要返回主页面？" message:@"此操作将撤销照片所有未保存的操作"] autorelease];
        [alert setDismissalStyle:AHAlertViewDismissalStyleFade];
        [alert setCancelButtonTitle:NSLocalizedString(@"取消", nil) block:nil];
        [alert addButtonWithTitle:NSLocalizedString(@"确定", nil) block:^{
            [alert dismiss]; // dismiss alert view
            [delegate switchViewTo:kPageMain fromView:kPageUI];
        }];
        [alert show];
    }else if (nil != delegate) {
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
        [alert setCancelButtonTitle:NSLocalizedString(@"我知道了", nil) block:nil];
        [SVProgressHUD dismiss];
        [alert show];
    }
}

// act when select photo button is pressed
- (IBAction)clickChoosePhoto:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [imagePicker setAllowsEditing:NO];
        //                imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
        self.popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [self.popover presentPopoverFromRect:CGRectMake(0, 0, 400, 500) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [imagePicker release];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"错误：无法正常进入你的照片集!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

// act when cancel all actions
- (IBAction)clickCancelAll:(UIButton*)sender {
    if (!isEdited) {
        // if not edited, do cancel all actions right away
        [self cancelAllActions];
    }else{
        // otherwise, need to show a warning alert to user to input 
        AHAlertView *alert = [[[AHAlertView alloc] initWithTitle:@"确定要取消对照片的所有操作？" message:nil] autorelease];
        [alert setDismissalStyle:AHAlertViewDismissalStyleFade];
        [alert setCancelButtonTitle:NSLocalizedString(@"返回", nil) block:nil];
        [alert addButtonWithTitle:NSLocalizedString(@"确定", nil) block:^{        
            [self cancelAllActions];
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
    self.sliderParameter.hidden=YES;
    isEdited=NO;

}

// act when slider value changed (visible for filter use only)
- (IBAction)sliderValueChange:(UISlider *)sender {
    [self.filterAreaViewController updateFilterOpacity:sender.value];
}


#pragma mark -
#pragma mark Utility and Private Methods
- (UIButton*) createButtonWithFrame: (CGRect) frame Target:(id)target Selector:(SEL)selector Image:(NSString *)image ImagePressed:(NSString *)imagePressed
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    UIImage *newImage = [UIImage imageNamed: image];
    [button setBackgroundImage:newImage forState:UIControlStateNormal];
    UIImage *newPressedImage = [UIImage imageNamed: imagePressed];
    [button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}


- (void) showMoreOptionsBar: (int) tag{
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
    }else{
        UIView *removeView = nil;
        removeView = [view viewWithTag:kRemoveViewTag];
        if (removeView) {
            [removeView removeFromSuperview];
        }
    }
    
    // add items
    UIImageView *imageView = [[[UIImageView alloc] init] autorelease];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.tag = kRemoveViewTag;
    
    if (index == 0) {
        // first one is alwasy close button
        imageView.frame = CGRectMake(50.0f, 50.0f, 60.0f, 60.0f);
        imageView.image = [UIImage imageNamed:@"btn_closeOptionBar.png"];
        
    }else{
        // add options' images
        imageView.frame = CGRectMake(5.0f,5.0f, 100.0f, 100.0f);
        NSString *imageURI = [self.iCarousel_ds objectAtIndex:(index-1)];
        imageView.image = [UIImage imageNamed:imageURI]; //get images
    }

    [view addSubview:imageView];
        
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
        if (index == 0) { // this is option to remove all specials
            [self.filterAreaViewController updatePhotoSpecials:nil];
        }else{
            // display HUD
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
            [self performBlock:^{
                NSDictionary *dataArr = [[BGGlobalData sharedData] getSpecialDataByIndex:index];
                [self.filterAreaViewController updatePhotoSpecials:dataArr]; // update/display special effects
                [SVProgressHUD dismiss]; // dismiss HUD
            } afterDelay:0.5f];
        }
    }
    else if (selectedMenu == kMenuPhotoFilter){
        // for Photo filters
        if (index == 0) { // this is option to remove filters
            BGFilterData data = {0, nil, nil, 0.0f, 1};
            [self.filterAreaViewController updatePhotoFilter:data];
            self.sliderParameter.hidden = YES;
        }else{
            // display HUD
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
            [self performBlock:^{
                // update filter
                BGFilterData data = [[BGGlobalData sharedData] getFilterDataByIndex:index];
                [self.filterAreaViewController updatePhotoFilter:data];
                // show slider
                self.sliderParameter.hidden = NO;
                self.sliderParameter.maximumValue = data.alpha;
                self.sliderParameter.value = data.alpha;
                [SVProgressHUD dismiss]; // dismiss HUD
            } afterDelay:0.5f];
        }
    }
    else{
        // for Photo Frames and Background Patterns
        UIImage *data = [[BGGlobalData sharedData] getFilterResourceByIndex:index andKeyIndex:selectedMenu];
        switch (selectedMenu) {
            case kMenuBgPattern:{
                [self.filterAreaViewController updateBackgroundPattern:data];
                break;}
            case kMenuPhotoFrame:{
                [self.filterAreaViewController updatePhotoFrame:data];
                break;}
            default:
                break;
        }
    }
}

#pragma mark -
#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // dismiss photo library
    [self.popover dismissPopoverAnimated:YES];
    [self.popover release];

    // display HUD
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    [self performBlock:^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        NSLog(@"selected image type: %@", mediaType);
        
        if ([mediaType isEqualToString:@"public.image"]){
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
        // from photo library
    [self.popover dismissPopoverAnimated:YES];
    [self.popover release];
}


@end
