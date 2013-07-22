//
//  BGHomeViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/07/16.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGHomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BGGlobalData.h"
#import "BGUIView.h"
#import "JMWhenTapped.h"
#import "UIScreen+SSToolkitAdditions.h"

@interface BGHomeViewController ()

@end

@implementation BGHomeViewController
@synthesize delegate;

- (id)initFromScene:(int)num
{
    self = [super init];
    if (self) {
        // Custom initialization
        scene = num;
        self.arrayHome =[NSArray arrayWithObjects:[NSNumber numberWithInt:kTagHomeMenuAbout],
                        [NSNumber numberWithInt:kTagHomeMenuFunc],
                        [NSNumber numberWithInt:kTagHomeMenuGallery],
                        nil];
        self.arrayGallery = [NSArray arrayWithObjects:[NSNumber numberWithInt:kTagGalleryBeauty],
                        [NSNumber numberWithInt:kTagGalleryFasion],
                        [NSNumber numberWithInt:kTagGalleryPersonal],
                        [NSNumber numberWithInt:kTagGalleryPortrait],
                        [NSNumber numberWithInt:kTagHomeButton],
                        nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // add background image
    NSString *bgPath = [[NSBundle mainBundle] pathForResource:@"background_home" ofType:@"jpg"];
    UIImage *bgImage = [UIImage imageWithContentsOfFile:bgPath];
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuButtonPressed:)];
    [self.singleTap setNumberOfTapsRequired:1];
    
//    self.view.layer.contents = (id)(bgImage.CGImage);
//    self.view.layer.backgroundColor = [[UIColor clearColor] CGColor];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] currentBounds]];
    iv.image = bgImage;
    [self.view addSubview:iv];
    [iv release];
    
    // animation buttons
    if (scene == kPageGallery) {
        // from gallery view, need init with gallery home
        [self showBgViews:self.arrayGallery delay:0.1f withInterval:0.1f];
    }else {
        // Fist open or From UI function page, need to init with home menu buttons
        [self showBgViews:self.arrayHome delay:0.1f withInterval:0.2f];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload{
    [self setSingleTap:nil];
    [self setArrayGallery:nil];
    [self setArrayHome:nil];
    
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    [_singleTap release];
    [_arrayGallery release];
    [_arrayHome release];
    
    [super dealloc];
}


#pragma mark --
#pragma mark Page Transitions
- (void) dismissBgViews:(NSArray*) viewArray{
    for (NSNumber *tag in viewArray){
        BGUIView *view = [self imageViewWithTag:[tag integerValue]];
        [UIView animateWithDuration:0.5f delay:0.1f options:UIViewAnimationOptionCurveEaseIn animations:^{
            view.center = view.fromLocation;
        } completion:^(BOOL complete){
            [view removeFromSuperview]; // finally remove from superview
        }];
    }
}

- (void) showBgViews:(NSArray*) viewArray delay:(float) delay withInterval:(float) interval{
    for (int i=0; i<viewArray.count; i++){
        NSNumber *tag = [viewArray objectAtIndex:i];
        BGUIView *view = [self imageViewWithTag:[tag integerValue]];
        view.center = view.fromLocation;
        [self.view addSubview:view]; // add to homeview
        
        // start moving animation
        [UIView animateWithDuration:0.75f delay:(delay+i*interval) options:UIViewAnimationOptionCurveEaseIn animations:^{
            view.center = view.toLocation;
        } completion:nil];
    }
}

- (void) transitionFromHomeToGallery{
    NSLog(@"transition from home to gallery");
    [self dismissBgViews:self.arrayHome];
    [self showBgViews:self.arrayGallery delay:0.5f withInterval:0.2f];
}

- (void) transitionFromGalleryToHome{
    NSLog(@"transition from gallery back to home");
    [self dismissBgViews:self.arrayGallery];
    [self showBgViews:self.arrayHome delay:0.5f withInterval:0.2f];
}

- (void) transitionFromHomeToAbout{
    //TODO:
    [self dismissBgViews:self.arrayHome];
//    [self showBgViews:nil delay:0.5f withInterval:0.2f];
}

- (void) transitionFromAboutToHome{
    //TODO:
//    [self dismissBgViews:nil];
//    [self showBgViews:self.arrayHome delay:0.5f withInterval:0.2f];
}

- (void) transitionFromHomeToFilter{
    if (delegate != nil) {
		[delegate switchViewTo:kPageUI fromView:kPageMain];
	}
}

- (void) transitionFromGalleryToDetail: (int) tag{
    if (delegate != nil) {
        int gIndex = 0;
        switch (tag) {
            case kTagGalleryBeauty:
                gIndex = 0; break;
            case kTagGalleryFasion:
                gIndex = 1; break;
            case kTagGalleryPersonal:
                gIndex = 2; break;
            case kTagGalleryPortrait:
                gIndex = 3; break;
            default:
                break;
        }
        
        [[BGGlobalData sharedData] setCurrentGalleryIndex:gIndex];
		[delegate switchViewTo:kPageGallery fromView:kPageMain];
	}
}



#pragma mark --
#pragma mark Utilities
- (BGUIView*) imageViewWithTag:(NSInteger) tag{
    BGUIView *view = (BGUIView*)[self.view viewWithTag:tag];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuButtonPressed:)];
//    [tap setNumberOfTapsRequired:1];
    
    
    
    if (!view) {
        switch (tag) {
//            case kTagHomeParticle2:{
//                view = [self bgViewWithImageFile:@"particle_home2" ofType:@"png"];
//                view.fromLocation = ccp(884.0f, 0.0f);
//                view.toLocation = ccp(884.0f, 180.0f);
//                view.transform =  CGAffineTransformMakeRotation(DegreesToRadians(180.0f));
//                //                [view addGestureRecognizer:self.singleTap];
//            } break;

           /* Home Page
            */
            case kTagHomeParticle1:{
                view = [self bgViewWithImageFile:@"particle1" ofType:@"png"];
                view.fromLocation = ccp(0.0f, 0.0f);
                view.toLocation = ccp(885.0f, 114.0f);
            } break;
            case kTagHomeButton:{
                view = [self bgViewWithImageFile:@"menubtn_home" ofType:@"png"];
                view.fromLocation = ccp(0.0f, 0.0f);
                view.toLocation = ccp(959.0f, 704.0f);
            } break;
            case kTagHomeMenuAbout:{
                view = [self bgViewWithImageFile:@"homemenu_about" ofType:@"png"];
                view.fromLocation = ccp(0.0f, 0.0f);
                view.toLocation = ccp(181.0f, 639.0f);
            } break;
            case kTagHomeMenuGallery:{
                view = [self bgViewWithImageFile:@"homemenu_gallery" ofType:@"png"];
                view.fromLocation = ccp(0.0f, 0.0f);
                view.toLocation = ccp(724.0f, 523.0f);
                view.transform =  CGAffineTransformMakeRotation(DegreesToRadians(10.0f));
            } break;
            case kTagHomeMenuFunc:{
                view = [self bgViewWithImageFile:@"homemenu_filter" ofType:@"png"];
                view.fromLocation = ccp(0.0f, 0.0f);
                view.toLocation = ccp(407.0f, 257.0f);
                view.transform =  CGAffineTransformMakeRotation(DegreesToRadians(-16.0f));
            } break;
            /* Gallery Page
             */
            case kTagGalleryBeauty:{
                view = [self bgViewWithImageFile:@"gallerymenu_beauty" ofType:@"png"];
                view.fromLocation = ccp(0.0f, 0.0f);
                view.toLocation = ccp(230.0f, 557.0f);
                view.transform =  CGAffineTransformMakeRotation(DegreesToRadians(-16.0f));
            } break;
            case kTagGalleryFasion:{
                view = [self bgViewWithImageFile:@"gallerymenu_fasion" ofType:@"png"];
                view.fromLocation = ccp(0.0f, 0.0f);
                view.toLocation = ccp(435.0f, 268.0f);
                view.transform =  CGAffineTransformMakeRotation(DegreesToRadians(-17.0f));
            } break;
            case kTagGalleryPersonal:{
                view = [self bgViewWithImageFile:@"gallerymenu_personal" ofType:@"png"];
                view.fromLocation = ccp(0.0f, 0.0f);
                view.toLocation = ccp(884.0f, 199.0f);
                view.transform =  CGAffineTransformMakeRotation(DegreesToRadians(6.0f));
            } break;
            case kTagGalleryPortrait:{
                view = [self bgViewWithImageFile:@"gallerymenu_portrait" ofType:@"png"];
                view.fromLocation = ccp(0.0f, 0.0f);
                view.toLocation = ccp(618.0f, 534.0f);
                view.transform =  CGAffineTransformMakeRotation(DegreesToRadians(2.0f));
            } break;
               
                
            default:
                break;
        }
        // add to subview array
        view.tag = tag;
//        
//        [tap release];

        
    }
    
    [view whenTapped:^{
        [self menuPressed:tag];
    }];
//    [view addGestureRecognizer:self.singleTap];
    
    if (view.superview == nil) {
        [self.view addSubview:view];
    }
    
    return view;
}


- (UIImageView*) viewWithImageFile: (NSString*)filename ofType:(NSString*)type{
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:type];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    UIImageView *imageView =[[[UIImageView alloc] initWithImage:image] autorelease];
    NSLog(@"image Size: %f, %f", imageView.frame.size.width, imageView.frame.size.height);
    
    return imageView;
}

- (BGUIView*) bgViewWithImageFile: (NSString*)filename ofType:(NSString*)type{
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:type];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    BGUIView *bgView =[[[BGUIView alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height+5.0f, image.size.width, image.size.height)] autorelease];
    bgView.layer.contents = (id)(image.CGImage);
    
    return bgView;
}

#pragma mark -
#pragma mark Action Methods
- (void)menuButtonPressed:(UITapGestureRecognizer*)sender{
    int tag = [sender.view tag];
    NSLog(@"pressed menu button tag: %i", tag);
    
    [self menuPressed:tag];
    
}

- (void) menuPressed:(int)tag{
    NSLog(@"pressed menu tag: %i", tag);
    switch (tag) {
        case kTagHomeButton:
            [self transitionFromGalleryToHome];
            break;
        case kTagHomeMenuGallery:{
            NSLog(@"lalllala");
            [self transitionFromHomeToGallery];
        }
            break;
        case kTagHomeMenuFunc:
            [self transitionFromHomeToFilter]; break;
        case kTagHomeMenuAbout:
            [self transitionFromHomeToAbout]; break;
        case kTagGalleryBeauty:
        case kTagGalleryFasion:
        case kTagGalleryPersonal:
        case kTagGalleryPortrait:
            [self transitionFromGalleryToDetail: tag]; break;
            
        default:
            break;
    }
}

@end

