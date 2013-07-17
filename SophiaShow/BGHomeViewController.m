//
//  BGHomeViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/07/16.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGHomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BGUIView.h"

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
    
//    self.view.layer.contents = (id)(bgImage.CGImage);
//    self.view.layer.backgroundColor = [[UIColor clearColor] CGColor];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:self.view.frame];
    iv.image = bgImage;
    [self.view addSubview:iv];
    [iv release];
    
    // animation buttons
    if (scene == kPageGallery) {
        // from gallery view, need init with gallery home
        NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithInt:kTagGalleryBeauty],
                        [NSNumber numberWithInt:kTagGalleryFasion],
                        [NSNumber numberWithInt:kTagGalleryPersonal],
                        [NSNumber numberWithInt:kTagGalleryPortrait],
                        nil];
        [self showBgViews:arr withInterval:0.1f];
    }else {
        // from UI function page, need to init with home menu buttons
        NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithInt:kTagHomeParticle1],
                        [NSNumber numberWithInt:kTagHomeParticle2],
                        [NSNumber numberWithInt:kTagHomeParticle3],
                        nil];
        [self showBgViews:arr withInterval:0.2f];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload{
    
    
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    
    [super dealloc];
}


#pragma mark --
#pragma mark Page Transitions
- (void) dismissBgViews:(NSArray*) viewArray{
    for (NSNumber *tag in viewArray){
        BGUIView *view = [self imageViewWithTag:[tag integerValue]];
        [UIView animateWithDuration:0.5f delay:0.2f options:UIViewAnimationOptionCurveEaseIn animations:^{
            view.center = view.fromLocation;
        } completion:^(BOOL complete){
            [view removeFromSuperview]; // finally remove from superview
        }];
    }
}

- (void) showBgViews:(NSArray*) viewArray withInterval:(float) interval{
    float delay = 0.2f;
    for (int i=0; i<viewArray.count; i++){
        NSNumber *tag = [viewArray objectAtIndex:i];
        BGUIView *view = [self imageViewWithTag:[tag integerValue]];
        view.center = view.fromLocation;
        
        // start moving animation
        [UIView animateWithDuration:0.75f delay:(delay+i*interval) options:UIViewAnimationOptionCurveEaseIn animations:^{
            view.center = view.toLocation;
        } completion:nil];
    }
}



#pragma mark --
#pragma mark Utilities
- (BGUIView*) imageViewWithTag:(NSInteger) tag{
    BGUIView *view = (BGUIView*)[self.view viewWithTag:tag];
    
    if (!view) {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuButtonPressed:)];

        switch (tag) {
            case kTagHomeParticle1:{
                view = [self bgViewWithImageFile:@"particle_home1" ofType:@"png"];
                view.fromLocation = ccp(884.0f, .0f);
                view.toLocation = ccp(100.0f, 200.0f);
            }
                break;
            case kTagHomeParticle2:{
                view = [self bgViewWithImageFile:@"particle_home2" ofType:@"png"];
                view.fromLocation = ccp(0.0f, 0.0f);
                view.toLocation = ccp(150.0f, 300.0f);
            } break;
            case kTagHomeParticle3:{
                view = [self bgViewWithImageFile:@"particle_home3" ofType:@"png"];
                view.fromLocation = ccp(0.0f, 0.0f);
                view.toLocation = ccp(500.0f, 500.0f);
                [view addGestureRecognizer:singleTap];
            } break;
                
            default:
                break;
        }
        // add to subview array
        view.tag = tag;
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
- (IBAction)menuButtonPressed:(id)sender{
    int tag = [(UIView*)sender tag];
    
    switch (tag) {
        case kTagHomeParticle3:
            
            break;
            
        default:
            break;
    }
}


@end

