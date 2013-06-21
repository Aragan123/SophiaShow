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

@interface BGImageFilterViewController ()

@end

@implementation BGImageFilterViewController
//@synthesize delegate, carousel=_carousel, iCarousel_ds=_iCarousel_ds, filterAreaViewController= _filterAreaViewController;
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
    
    selectedMenu=10;
    self.sliderParameter.hidden = YES;
    self.btnChoosePhoto.hidden = NO;
    self.btnCancelAll.hidden = YES;
    
    // contruct HM SideMenu
    // item 1
    UIView *itemBackPat = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 48)] autorelease];
    UIButton *btnBackPat = [self createButtonWithFrame:CGRectMake(0, 0, 44, 48) Target:self Selector:@selector(clickMenuButton:) Image:@"btn_function_bokeh_a" ImagePressed:@"btn_function_bokeh_c"];
    btnBackPat.tag=kMenuBgPattern;
    [itemBackPat addSubview:btnBackPat];
    // item 2
    UIView *itemFrame = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 48)] autorelease];
    UIButton *btnFrame = [self createButtonWithFrame:CGRectMake(0, 0, 44, 48) Target:self Selector:@selector(clickMenuButton:) Image:@"btn_function_border_a" ImagePressed:@"btn_function_border_c"];
    btnFrame.tag=kMenuPhotoFrame;
    [itemFrame addSubview:btnFrame];
    // item 3
    UIView *itemFilter = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 48)] autorelease];
    UIButton *btnFilter = [self createButtonWithFrame:CGRectMake(0, 0, 44, 48) Target:self Selector:@selector(clickMenuButton:) Image:@"btn_function_color_a" ImagePressed:@"btn_function_color_c"];
    btnFilter.tag=kMenuPhotoFilter;
    [itemFilter addSubview:btnFilter];
    // item 4
    UIView *itemSpecial = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 48)] autorelease];
    UIButton *btnSpecial = [self createButtonWithFrame:CGRectMake(0, 0, 44, 48) Target:self Selector:@selector(clickMenuButton:) Image:@"btn_function_stylize_a" ImagePressed:@"btn_function_stylize_c"];
    btnSpecial.tag=kMenuSpecial;
    [itemSpecial addSubview:btnSpecial];
    
    // item 5
    UIView *itemSave = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 48)] autorelease];
    UIButton *btnSave = [self createButtonWithFrame:CGRectMake(0, 0, 44, 48) Target:self Selector:@selector(saveImageToPhotoAlbum:) Image:@"icon_save_photo" ImagePressed:@"icon_save_photo"];
//    btnSave.tag=4;
    [itemSave addSubview:btnSave];
    // item 6
    UIView *itemReturn = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 48)] autorelease];
    UIButton *btnReturn = [self createButtonWithFrame:CGRectMake(0, 0, 44, 48) Target:self Selector:@selector(clickReturnButton:) Image:@"btn_home_b" ImagePressed:@"btn_home_b"];
//    btnReturn.tag=5;
    [itemReturn addSubview:btnReturn];

    // placeholder
    UIView *itemPlaceholder = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 50)] autorelease];
    itemPlaceholder.backgroundColor = [UIColor clearColor];
    
    HMSideMenu *sideMenu = [[[HMSideMenu alloc] initWithItems:@[itemBackPat, itemFrame, itemFilter, itemSpecial, itemPlaceholder, itemSave, itemReturn]] autorelease];
    [sideMenu setItemSpacing:5.0f];
    [self.view addSubview:sideMenu];
    [self.view performBlock:^{
        [sideMenu open];
    } afterDelay:1.0f];
    
    
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
    
    [self setBtnChoosePhoto:nil];
    [self setSliderParameter:nil];
    [self setBtnCancelAll:nil];
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    [_carousel release];
    [_iCarousel_ds release];
    [_filterAreaViewController release];
    [_popover release];
    
    [_btnChoosePhoto release];
    [_sliderParameter release];
    [_btnCancelAll release];
    [super dealloc];
}



#pragma mark --
#pragma mark IBOutlet Actions

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
    if (nil != delegate) {
        [delegate switchViewTo:kPageMain fromView:kPageUI];
    }

}

// when image saving button in side menu is pressed
- (IBAction)saveImageToPhotoAlbum:(id)sender {
    // show alert before save
    //            UIImage *savedImage = [self screenshot:self.bgView];
    //            UIImageWriteToSavedPhotosAlbum (savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message...
        NSLog(@"Image save with error");
        
    }
    else  // No errors
    {
        // Show message image successfully saved
        NSLog(@"Image Saved successfully!!!");
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
    NSLog(@"hide cancel all button");
    if (self.filterAreaViewController != nil) {
        [self.filterAreaViewController.view removeFromSuperview];
        self.filterAreaViewController = nil;
    }
    
    if (self.carousel!=nil && self.carousel.superview != nil) {
        [self hideMoreOptionBar];
    }

    self.btnChoosePhoto.hidden=NO;
    self.btnCancelAll.hidden = YES;
    self.sliderParameter.hidden=YES;
    
    

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
    [UIView animateWithDuration:0.4f animations:^{
        self.carousel.layer.position = CGPointMake (self.view.frame.size.width - self.carousel.frame.size.width*0.5 - 60.0f, self.view.frame.size.height*0.5);
    }];
}

- (void) hideMoreOptionBar{
    [UIView animateWithDuration:0.3f animations:^{
        self.carousel.layer.position = CGPointMake (self.view.frame.size.width + self.carousel.frame.size.width*0.5, self.view.frame.size.height*0.5);
    } completion:^(BOOL finished) {
        // remove from supperview
        [self.carousel removeFromSuperview];
    }];
}

- (void) hideThenDisplayMoreOptionBar{
    [UIView animateWithDuration:0.3f animations:^{
        self.carousel.layer.position = CGPointMake (self.view.frame.size.width +self.carousel.frame.size.width*0.5, self.view.frame.size.height*0.5);
    } completion:^(BOOL finished) {
        [self.carousel reloadData];
        self.carousel.currentItemIndex = 2;
        [self displayMoreOptionBar];
    }];
}




#pragma mark --
#pragma mark iCarousel delegate and its DataSrouce delegate methods
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.iCarousel_ds count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil){
        view = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110.0f, 110.0f)] autorelease];
        view.contentMode = UIViewContentModeCenter;
        [view setBackgroundColor:[UIColor clearColor]];
    }else{
        UIView *removeView = nil;
        removeView = [view viewWithTag:kRemoveViewTag];
        if (removeView) {
            [removeView removeFromSuperview];
        }
    }
    
    // add images
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5,5, 100, 100)] autorelease];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.tag = kRemoveViewTag;
    NSString *imageURI = [self.iCarousel_ds objectAtIndex:index];
    imageView.image = [UIImage imageNamed:imageURI]; //get images
    
    [view addSubview:imageView];
        
    return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"select filter index: %i", index);
    
    if (selectedMenu != kMenuSpecial) {
        // there is a special case
        if (selectedMenu == kMenuPhotoFilter && index == 0) {
            // need to remove filter
            [self.filterAreaViewController updatePhotoFilter:nil];
            self.sliderParameter.hidden = YES;
        }
        NSLog(@"################");
        
        UIImage *res = [[BGGlobalData sharedData] getFilterResourceByIndex:index andKeyIndex:selectedMenu];
        switch (selectedMenu) {
            case kMenuBgPattern:
                [self.filterAreaViewController updateBackgroundPattern:res];
                break;
            case kMenuPhotoFrame:
                [self.filterAreaViewController updatePhotoFrame:res];
                break;
            case kMenuPhotoFilter:
                [self.filterAreaViewController updatePhotoFilter:res];
                // show slider
                self.sliderParameter.hidden = NO;
                self.sliderParameter.maximumValue = 0.6f;
                self.sliderParameter.value = 0.6f;
                break;
                
            default:
                break;
        }
    }else{
        // TODO: for special filters, need special function to run it for each individual
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
            self.btnCancelAll.hidden = NO;
            
            if (self.filterAreaViewController == nil) {
                self.filterAreaViewController = [[BGFilterAreaViewController alloc] init];
            }
            
            [self.filterAreaViewController setupViewsWithSourceImage:image];
            [self.view addSubview:self.filterAreaViewController.view];
            
            [SVProgressHUD dismiss];
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
