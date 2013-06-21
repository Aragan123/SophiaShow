//
//  BGFilterAreaViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/06/21.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGFilterAreaViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+BGAdditional.h"
#import "UIImage+Resize.h"
#import "BGGlobalData.h"

@interface BGFilterAreaViewController ()

@end

@implementation BGFilterAreaViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_photoView release];
    [_scrollView release];
    [_frameView release];
    [_filterLayer release];
    [_specialLayer release];
    
    [_originalImage release];
    [_cropedImage release];
    [_filterImage release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPhotoView:nil];
    [self setScrollView:nil];
    [self setFrameView:nil];
    [self setFilterLayer:nil];
    [self setSpecialLayer:nil];
    
    [self setOriginalImage:nil];
    [self setCropedImage:nil];
    [self setFilterImage:nil];
    [super viewDidUnload];
}


// setup views when first time open
- (void) setupViewsWithSourceImage: (UIImage*) srcImage{
    NSLog(@"set up Filter Area subviews");
    self.originalImage = srcImage;
    self.view.frame = [self calculateFilterAreaRect:srcImage.size];

    // default color pattern
    UIColor *bgPattern = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pat009.jpg"]]; // default pattern
    self.view.backgroundColor = bgPattern;
    // default frame view
    self.frameView = [[UIImageView alloc] initWithFrame:[self calculateFrameViewRect:self.view.frame]];
    NSString *defaultFrameURI = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/Filters/009.png"];
    UIImage *defaultFrame = [UIImage imageWithContentsOfFile:defaultFrameURI];
    self.frameView.image = [self drawPhotoFrame:defaultFrame withOffsize:13.0f];
    // shadowing
    self.frameView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.frameView.layer.shadowOffset = CGSizeMake(4, 4);
    self.frameView.layer.shadowOpacity = 1;
    self.frameView.layer.shadowRadius = 4.0;
    [self.view addSubview:self.frameView];
    
    // default photo scroll views
    self.scrollView = [[UIScrollView alloc] initWithFrame:[self calculatePhotoViewRect:self.view.frame]];
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    [self.scrollView setDelegate:self];
    [self.scrollView setBounces:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setContentMode:UIViewContentModeScaleAspectFit];
    [self.scrollView setContentSize:srcImage.size];
    [self.scrollView setMinimumZoomScale:MIN((self.scrollView.frame.size.width / srcImage.size.width), (self.scrollView.frame.size.height / srcImage.size.height)) ];
    [self.scrollView setZoomScale:[self.scrollView minimumZoomScale]];
    [self.scrollView setMaximumZoomScale:[self calculateScrollerMaxZoom:self.scrollView.frame.size andPhotoSize:srcImage.size]];
    [self.scrollView.layer setCornerRadius:4.0f];
    
    // default photo view
//    self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    self.photoView = [[UIImageView alloc] initWithImage:srcImage];
    self.photoView.backgroundColor = [UIColor clearColor];
    self.photoView.frame = CGRectMake(0.0, 0.0, srcImage.size.width, srcImage.size.height);
    self.photoView.center = CGPointMake(self.scrollView.frame.size.width*0.5, self.scrollView.frame.size.height*0.5);
    [self.scrollView addSubview:self.photoView];
    [self.view addSubview:self.scrollView];
    

    // default filter layer to scroll view
    self.filterLayer = [CALayer layer];
    [self.filterLayer setBackgroundColor:[UIColor clearColor].CGColor];
    [self.filterLayer setFrame:CGRectMake(0.0f, 0.0f, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    [self.frameView.layer addSublayer:self.filterLayer];
    
    // default special layer
    self.specialLayer = [CALayer layer];
    [self.specialLayer setBackgroundColor:[UIColor clearColor].CGColor];
    [self.specialLayer setFrame:self.view.frame];
    [self.view.layer addSublayer:self.specialLayer];
    

    
}

#pragma mark --
#pragma mark Public Methods
- (void) updateBackgroundPattern: (UIImage*) image{
    UIColor *bgColor = [UIColor colorWithPatternImage:image];
    self.view.backgroundColor = bgColor;
}

- (void) updatePhotoFrame: (UIImage*) image{
    self.frameView.image = [self drawPhotoFrame:image withOffsize:13.0f];
}

- (void) updatePhotoFilter: (UIImage*) image{
    NSLog(@"update photo filter is called");
    self.filterImage = image;
    
    if (image == nil) {
        // remove filter layer
        NSLog(@"remove photo filter");
//        self.filterLayer.contents = nil;
//        self.filterLayer.opacity = 0.0f;
        
    }else{
        // add filter image
//        self.filterLayer.contents = (id)[image CIImage];
//        self.filterLayer.opacity = 0.5f;
        if (self.cropedImage == nil) {
            self.cropedImage = [self cropFromScrollView];
        }
        UIImage *result = [self.cropedImage imageBlendedWithImage:image blendMode:kCGBlendModeNormal alpha:0.5f];
        self.photoView.image = result;
    }
}

- (void) updateFilterOpacity: (float) value{
    UIImage *result = [self.cropedImage imageBlendedWithImage:self.filterImage blendMode:kCGBlendModeNormal alpha:value];
    self.photoView.image = result;
}

#pragma mark --
#pragma mark Utility and Private Methods

- (CGRect) calculateFilterAreaRect: (CGSize) imageSize{
    // TODO: real calculation is required
    
    return CGRectMake(50, 60, 824, 618);
}

- (CGRect) calculateFrameViewRect: (CGRect) filterAreaRect{
    return CGRectMake(35, 35, 754, 548);
}

- (CGRect) calculatePhotoViewRect: (CGRect) filterAreaRect{
    return CGRectMake(70, 70, 684, 478);
}

- (float) calculateScrollerMaxZoom: (CGSize) scrollerSize andPhotoSize:(CGSize) photoSize{
    
    return 2.0f;
}

- (UIImage *) cropFromScrollView {
    CGRect visibleRect;
    float scale = 1.0f/self.scrollView.zoomScale;
    visibleRect.origin.x = self.scrollView.contentOffset.x * scale;
    visibleRect.origin.y = self.scrollView.contentOffset.y * scale;
    visibleRect.size.width = self.scrollView.bounds.size.width * scale;
    visibleRect.size.height = self.scrollView.bounds.size.height * scale;
    
    CGImageRef cr = CGImageCreateWithImageInRect(self.originalImage.CGImage, visibleRect);
    UIImage* cropped = [UIImage imageWithCGImage:cr];
    CGImageRelease(cr);
    
    return cropped;
}

#pragma mark --
#pragma mark Drawing
- (UIImage *) drawPhotoFrame: (UIImage*) frameSource withOffsize:(float) offsize{
    CGSize srcSize = CGSizeMake(50.0f, 50.0f);
    //    float offsize = 14.0f;
    CGSize viewSize = self.frameView.frame.size;
    int widthFactor = (viewSize.width-srcSize.width*2) / offsize;
    int heightFactor = (viewSize.height-srcSize.height*2) / offsize;
    CGSize frameSize = CGSizeMake(offsize *widthFactor+srcSize.width*2, offsize *heightFactor+srcSize.height*2);
    
    
    UIGraphicsBeginImageContext(frameSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    
    // prepare source images
    UIImage *frameTopRight = [frameSource imageRotatedByDegrees:90.0f];
    UIImage *frameBottomRight = [frameSource imageRotatedByDegrees:180.0f];
    UIImage *frameBottomLeft = [frameSource imageRotatedByDegrees:-90.0f];
    // cliped images
    UIImage *vElement = [frameSource imageCropByFrame:CGRectMake(srcSize.width-offsize, 0.0f, offsize, srcSize.height)];
    UIImage *hElement = [frameSource imageCropByFrame:CGRectMake(0.0f, srcSize.height-offsize, srcSize.width, offsize)];
    //    CGImageRef vElement = CGImageCreateWithImageInRect(frameSource.CGImage, CGRectMake(srcSize.width-10.0f, 0.0f, 10.0f, srcSize.height));
    //    CGImageRef hElement = CGImageCreateWithImageInRect(frameSource.CGImage, CGRectMake(0.0f, srcSize.height-10.0f, 10.0f, srcSize.height));
    
    UIImage *vElement_180 = [vElement imageRotatedByDegrees:180.0f];
    UIImage *hElement_180 = [hElement imageRotatedByDegrees:180.0f];
    
    
    // drawing central gray area
    CGRect centreArea = CGRectMake(0+srcSize.width, 0+srcSize.height, frameSize.width - srcSize.width*2, frameSize.height - srcSize.height*2);
    CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
    //    CGContextSetBlendMode(ctx, kCGBlendModeSourceAtop);
    CGContextFillRect(ctx, centreArea);
    
    // draw four corner image
    CGContextDrawImage(ctx, CGRectMake(0.0f, 0.0f, srcSize.width, srcSize.height), frameBottomLeft.CGImage);
    CGContextDrawImage(ctx, CGRectMake(frameSize.width-srcSize.width, 0.0f, srcSize.width, srcSize.height), frameBottomRight.CGImage);
    CGContextDrawImage(ctx, CGRectMake(frameSize.width-srcSize.width, frameSize.height-srcSize.height, srcSize.width, srcSize.height), frameTopRight.CGImage);
    CGContextDrawImage(ctx, CGRectMake(0.0f, frameSize.height-srcSize.height, srcSize.width, srcSize.height), frameSource.CGImage);
    
    // draw top bar tile
    CGContextClipToRect(ctx, CGRectMake(srcSize.width, 0.0f, frameSize.width-srcSize.width*2, srcSize.height));
    CGContextDrawTiledImage(ctx, CGRectMake(srcSize.width, 0.0f, vElement.size.width, vElement.size.height), vElement_180.CGImage);
    CGContextRestoreGState(ctx);
    CGContextSaveGState(ctx);
    
    
    CGContextClipToRect(ctx, CGRectMake(srcSize.width, frameSize.height - srcSize.height, frameSize.width-srcSize.width*2, srcSize.height));
    CGContextDrawTiledImage(ctx, CGRectMake(srcSize.width,  frameSize.height - srcSize.height, vElement.size.width, vElement.size.height), vElement.CGImage);
    CGContextRestoreGState(ctx);
    CGContextSaveGState(ctx);
    
    
    CGContextClipToRect(ctx, CGRectMake(0.0f, srcSize.height, srcSize.width, frameSize.height - srcSize.height*2));
    CGContextDrawTiledImage(ctx, CGRectMake(0.0f, srcSize.height, hElement.size.width, hElement.size.height), hElement.CGImage);
    CGContextRestoreGState(ctx);
    CGContextSaveGState(ctx);
    
    CGContextClipToRect(ctx, CGRectMake(frameSize.width-srcSize.width, srcSize.height, srcSize.width, frameSize.height - srcSize.height*2));
    CGContextDrawTiledImage(ctx, CGRectMake(frameSize.width-srcSize.width, srcSize.height, hElement.size.width, hElement.size.height), hElement_180.CGImage);
    CGContextRestoreGState(ctx);
    
    // generate result frame image and release memory
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    //    CGImageRelease(vElement);
    //    CGImageRelease(hElement);
    UIGraphicsEndImageContext();
    //        CGContextRelease(ctx);
    
    return result;
}

#pragma mark -
#pragma mark UIScrollView Delegate methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.photoView;
}

@end
