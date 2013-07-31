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

@interface BGHomeViewController ()

@end

@implementation BGHomeViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil fromScene:(int)sceneNum {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        scene = sceneNum;
        isCn = YES;
        self.arrayHome =[NSArray arrayWithObjects:[NSNumber numberWithInt:kTagHomeMenuAbout],
                        [NSNumber numberWithInt:kTagHomeMenuFunc],
                        [NSNumber numberWithInt:kTagHomeMenuGallery],
                        nil];
        self.arrayGallery = [NSArray arrayWithObjects:[NSNumber numberWithInt:kTagGalleryFasion],
                        [NSNumber numberWithInt:kTagGalleryPersonal],
                        [NSNumber numberWithInt:kTagGalleryBeauty],
                        [NSNumber numberWithInt:kTagGalleryPortrait],
                        [NSNumber numberWithInt:kTagHomeButton],
                        nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
//    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuButtonPressed:)];
//    [self.singleTap setNumberOfTapsRequired:1];
        
    // animation buttons
    if (scene == kPageGallery) {
        // from gallery view, need init with gallery home
        [self showBgViews:self.arrayGallery delay:0.1f withInterval:0.06f];
    }else {
        // Fist open or From UI function page, need to init with home menu buttons
        [self showBgViews:self.arrayHome delay:0.1f withInterval:0.06f];
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
    for (NSNumber *tagNumber in viewArray){
        int tag = [tagNumber integerValue];
        BGUIView *view = [self bgViewWithTag:tag];
        [UIView animateWithDuration:0.2f delay:0.1f options:UIViewAnimationOptionCurveEaseIn animations:^{
            view.center = view.fromLocation;
        } completion:^(BOOL complete){
            if (tag == kTagHomeMenuAbout || tag == kTagHomeMenuFunc || tag == kTagHomeMenuGallery) {
                return ;
            }
            [view removeFromSuperview]; // finally remove from superview
        }];
    }
}

- (void) showBgViews:(NSArray*) viewArray delay:(float) delay withInterval:(float) interval{
    for (int i=0; i<viewArray.count; i++){
        NSNumber *tag = [viewArray objectAtIndex:i];
        BGUIView *view = [self bgViewWithTag:[tag integerValue]];
        view.center = view.fromLocation;
        [self.view addSubview:view]; // add to homeview
        
        // start moving animation
        [UIView animateWithDuration:0.5f delay:(delay+i*interval) options:UIViewAnimationOptionCurveEaseIn animations:^{
            view.center = view.toLocation;
        } completion:nil];
    }
}

- (void) transitionFromHomeToGallery{
    NSLog(@"transition from home to gallery");
    [self dismissBgViews:self.arrayHome];
    [self showBgViews:self.arrayGallery delay:0.2f withInterval:0.1f];
}

- (void) transitionFromGalleryToHome{
    NSLog(@"transition from gallery back to home");
    [self dismissBgViews:self.arrayGallery];
    [self showBgViews:self.arrayHome delay:0.2f withInterval:0.1f];
}

- (void) transitionFromHomeToAbout{
    //TODO:
    [self dismissBgViews:self.arrayHome];
    [self showBgViews:[NSArray arrayWithObjects:
                       [NSNumber numberWithInt:kTagAboutBook],
                       [NSNumber numberWithInt:kTagHomeButton1], nil] delay:0.2f withInterval:0.1f];
}

- (void) transitionFromAboutToHome{
    //TODO:
    [self dismissBgViews:[NSArray arrayWithObjects:
                          [NSNumber numberWithInt:kTagAboutBook],
                          [NSNumber numberWithInt:kTagHomeButton1], nil] ];
    [self showBgViews:self.arrayHome delay:0.2f withInterval:0.1f];
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
- (BGUIView*) bgViewWithTag:(NSInteger) tag{
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
            case kTagHomeButton:
            case kTagHomeButton1:
            {
                view = [self bgViewWithImageFile:@"menubtn_home" ofType:@"png"];
                view.fromLocation = ccp(self.view.frame.size.width, self.view.frame.size.height+44.0f);
                view.toLocation = ccp(959.0f, 704.0f);
            } break;
//            case kTagHomeButton1:{
//                view = [self bgViewWithImageFile:@"menubtn_home" ofType:@"png"];
//                view.fromLocation = ccp(self.view.frame.size.width, 0.0f);
//                view.toLocation = ccp(959.0f, 704.0f);
//            } break;

            case kTagHomeMenuAbout:{
                view = [self bgViewWithImageFile:@"homemenu_about" ofType:@"png"];
                view.fromLocation = ccp(0.0f, self.view.frame.size.height+60.0f);
                view.toLocation = ccp(190.0f, 640.0f);
            } break;
            case kTagHomeMenuGallery:{
                view = [self bgViewWithImageFile:@"homemenu_gallery" ofType:@"png"];
                view.fromLocation = ccp(self.view.frame.size.width+180.0f, self.view.frame.size.height*0.5f);
                view.toLocation = ccp(740.0f, 520.0f);
                view.transform =  CGAffineTransformMakeRotation(DegreesToRadians(10.0f));
            } break;
            case kTagHomeMenuFunc:{
                view = [self bgViewWithImageFile:@"homemenu_filter" ofType:@"png"];
                view.fromLocation = ccp(self.view.frame.size.width-100.0f, -100.0f);
                view.toLocation = ccp(390.0f, 260.0f);
                view.transform =  CGAffineTransformMakeRotation(DegreesToRadians(-16.0f));
            } break;
            /* Gallery Page
             */
            case kTagGalleryBeauty:{
                view = [self bgViewWithImageFile:@"gallerymenu_beauty" ofType:@"png"];
                view.fromLocation = ccp(self.view.frame.size.width+200.0f, 199.0f);
                view.toLocation = ccp(840.0f, 200.0f);
                view.transform =  CGAffineTransformMakeRotation(DegreesToRadians(6.0f));
            } break;
            case kTagGalleryFasion:{
                view = [self bgViewWithImageFile:@"gallerymenu_fasion" ofType:@"png"];                
                view.fromLocation = ccp(-200.0f, 557.0f);
                view.toLocation = ccp(230.0f, 560.0f);
                view.transform =  CGAffineTransformMakeRotation(DegreesToRadians(-16.0f));
            } break;
            case kTagGalleryPersonal:{
                view = [self bgViewWithImageFile:@"gallerymenu_personal" ofType:@"png"];
                view.fromLocation = ccp(-200.0f, 268.0f);
                view.toLocation = ccp(435.0f, 270.0f);
                view.transform =  CGAffineTransformMakeRotation(DegreesToRadians(-17.0f));
            } break;
            case kTagGalleryPortrait:{
                view = [self bgViewWithImageFile:@"gallerymenu_portrait" ofType:@"png"];
                view.fromLocation = ccp(self.view.frame.size.width+200.0f, 534.0f);
                view.toLocation = ccp(620.0f, 530.0f);
                view.transform =  CGAffineTransformMakeRotation(DegreesToRadians(2.0f));
            } break;
               
            /* About Page
             */
            case kTagAboutBook:{
                BGUIView *bgView = [[[BGUIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 890.0f, 580.0f)] autorelease];
                bgView.fromLocation = ccp(-450.0f, 415.0f);
                bgView.toLocation = ccp(530.0f, 415.0f);
                // add book image
                NSString *path = [[NSBundle mainBundle] pathForResource:@"about_book" ofType:@"png"];
                UIImage * image = [UIImage imageWithContentsOfFile:path];
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, image.size.width, image.size.height)];
                iv.image = image;
                [bgView addSubview:iv];
                [iv release];
                // add CN text
                NSString *textpath = [[NSBundle mainBundle] pathForResource:@"about_text_cn" ofType:@"png"];
                UIImage *textimage = [UIImage imageWithContentsOfFile:textpath];
                UIImageView *textiv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, textimage.size.width, textimage.size.height)];
                textiv.image = textimage;
                textiv.tag = kTagAboutText;
                [bgView addSubview:textiv];
                [textiv release];
                
                // add language button
                NSString *langpath = [[NSBundle mainBundle] pathForResource:@"about_en" ofType:@"png"];
                UIImage * langimage = [UIImage imageWithContentsOfFile:langpath];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(754.0f, 170.0f, langimage.size.width, langimage.size.height);
                [btn setBackgroundImage:langimage forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
                [bgView addSubview:btn];
                // assign to view
                view = bgView;
//                [bgView release];

            }
            default:
                break;
        }
        // add to subview array
        view.tag = tag;
    }
    
    if (tag !=kTagAboutBook) {
        [view whenTapped:^{
            [self menuPressed:tag];
        }];

    }
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
        case kTagHomeButton1:
            [self transitionFromAboutToHome];
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

// used by about page toggle EN and CN
- (void) toggleButton: (UIButton *) button{
    isCn = !isCn;
    NSString *imageName = @"about_text_cn";
    NSString *btnImageName = @"about_cn";
    
    // switch button
    if (!isCn){
        imageName = @"about_text_en";
        NSLog(@"change to EN");
    }else{
        btnImageName = @"about_en";
        NSLog(@"change to CN");
    }
    
    // switch button
    NSString *btnpath = [[NSBundle mainBundle] pathForResource:btnImageName ofType:@"png"];
    UIImage *btnimage = [UIImage imageWithContentsOfFile:btnpath];
    [button setBackgroundImage:btnimage forState:UIControlStateNormal];

    
    // switch text 
    BGUIView *bookview = [self bgViewWithTag:kTagAboutBook];
    UIImageView *iv = (UIImageView*)[bookview viewWithTag:kTagAboutText];
    NSString *textpath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    UIImage *textimage = [UIImage imageWithContentsOfFile:textpath];
    [UIView animateWithDuration:1.5f animations:^{
        iv.alpha = 0.0f;
        iv.image = textimage;
        iv.alpha = 1.0f;
    }];

}

@end

