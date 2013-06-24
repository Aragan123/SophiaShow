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
    [_resultFilterView release];
    [_specialForeLayer release];
    [_specialBackLayer release];
    
    [_originalImage release];
    [_cropedImage release];
    [self.filterData.image release];
    [_specialArray release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPhotoView:nil];
    [self setScrollView:nil];
    [self setFrameView:nil];
    [self setResultFilterView:nil];
    [self setSpecialForeLayer:nil];
    [self setSpecialBackLayer:nil];
    
    [self setOriginalImage:nil];
    [self setCropedImage:nil];
    [self setSpecialArray:nil];
    [super viewDidUnload];
}


// setup views when first time open
- (void) setupViewsWithSourceImage: (UIImage*) srcImage{
    NSLog(@"set up Filter Area subviews");
    self.originalImage = srcImage;
    self.view.frame = [self calculateFilterAreaRect:srcImage.size];
    CGSize areaSize = self.view.frame.size;

    // default color pattern
    UIColor *bgPattern = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pat009.jpg"]]; // default pattern
    self.view.backgroundColor = bgPattern;
    // default back special layer - UIImageView
    self.specialBackLayer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, areaSize.width, areaSize.height)];
    [self.specialBackLayer setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.specialBackLayer];

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
    [self.scrollView setContentMode:UIViewContentModeCenter];
    [self.view addSubview:self.scrollView];
    
    CGFloat imageWidth = CGImageGetWidth(srcImage.CGImage);
    CGFloat imageHeight = CGImageGetHeight(srcImage.CGImage);
    NSLog(@"Source image Size: w=%f, h=%f", imageWidth, imageHeight);
    // default photo view
    self.photoView = [[UIImageView alloc] initWithImage:srcImage];
    self.photoView.backgroundColor = [UIColor clearColor];
//    self.photoView.frame = CGRectMake(0.0, 0.0, imageWidth, imageHeight);
//    self.photoView.center = CGPointMake(self.scrollView.frame.size.width*0.5, self.scrollView.frame.size.height*0.5);
    
    [self.scrollView setContentSize:CGSizeMake(imageWidth, imageHeight)];
    [self.scrollView setMinimumZoomScale:MIN((self.scrollView.frame.size.width / imageWidth), (self.scrollView.frame.size.height / imageHeight)) ];
    [self.scrollView setZoomScale:[self.scrollView minimumZoomScale]];
    [self.scrollView setMaximumZoomScale:[self calculateScrollerMaxZoom:self.scrollView.frame.size andPhotoSize:CGSizeMake(imageWidth, imageHeight)]];
    [self.scrollView.layer setCornerRadius:4.0f];
    [self.scrollView addSubview:self.photoView]; // add views

    
    // default result image view
    self.resultFilterView = [[UIImageView alloc] initWithFrame:self.scrollView.frame];
    [self.resultFilterView setBackgroundColor:[UIColor clearColor]];
    [self.resultFilterView setContentMode:UIViewContentModeCenter];
    [self.view addSubview:self.resultFilterView];
    
    // default special layer UIImageView
    self.specialForeLayer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, areaSize.width, areaSize.height)];
    [self.specialForeLayer setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.specialForeLayer];
    

    
}

#pragma mark -
#pragma mark Public Methods
- (void) updateBackgroundPattern: (UIImage*) image{
    UIColor *bgColor = [UIColor colorWithPatternImage:image];
    self.view.backgroundColor = bgColor;
}

- (void) updatePhotoFrame: (UIImage*) image{
    self.frameView.image = [self drawPhotoFrame:image withOffsize:13.0f];
}

- (void) updatePhotoFilter: (BGFilterData) data{
    NSLog(@"update photo filter is called");
    self.filterData = data;
    [self.filterData.image retain];
    
    if (data.image == nil) {
        // remove filter layer
        // TODO: remove result image view and add back scroll view to display original photo image
        NSLog(@"remove photo filter");
        if (self.cropedImage == nil) {
            return; // do nothing, this happends when 1st filter button is clicked but not filtered yet
        }else{
            self.cropedImage = nil; // set it to nil
            [self.resultFilterView removeFromSuperview];
            self.resultFilterView = nil;
            [self.view insertSubview:self.scrollView aboveSubview:self.frameView];
        }
        
    }else{
        // add filter image
        if (self.cropedImage == nil) { // first time
            self.cropedImage = [self screenshot:self.scrollView];
            [self.scrollView removeFromSuperview]; // remove scroll view
            
            if (self.resultFilterView == nil) {
                self.resultFilterView = [[UIImageView alloc] initWithFrame:self.scrollView.frame];
                [self.resultFilterView setBackgroundColor:[UIColor clearColor]];
//                [self.resultFilterView setContentMode:UIViewContentModeCenter];
                [self.resultFilterView.layer setCornerRadius:4.0f];
            }
            [self.view insertSubview:self.resultFilterView aboveSubview:self.frameView];

        }
        // TODO: remove scroll view and insert new UIImageView to display result image
        UIImage *resizedImage = [data.image resizedImageToSize:self.cropedImage.size];
        data.image = resizedImage;
        UIImage *result = [self.cropedImage imageBlendedWithImage:resizedImage blendMode:data.blendMode alpha:data.alpha];
        self.resultFilterView.image = result;
    }
}

// Slider change to update filter opacity
- (void) updateFilterOpacity: (float) value{
    UIImage *result = [self.cropedImage imageBlendedWithImage:self.filterData.image blendMode:self.filterData.blendMode alpha:value];
    self.photoView.image = result;
}

// specials is chosen
- (void) updatePhotoSpecials: (NSDictionary*) dataDict{
//    self.specialArray = dataArr;
    
    if (dataDict == nil) {
        // actions to remove all specials
        self.specialForeLayer.image = nil;
        self.specialBackLayer.image = nil;
    }else{
        NSArray *dataForeArr = [dataDict objectForKey:kForeSpecialLayerKey];
        NSArray *dataBackArr = [dataDict objectForKey:kBackSpecialLayerKey];
        
        UIImage *imageFore = [self drawPhotoSpecialWithData: (NSArray*) dataForeArr];
        UIImage *imageBack = [self drawPhotoSpecialWithData: (NSArray*) dataBackArr];
        
        self.specialForeLayer.image = imageFore;
        self.specialBackLayer.image = imageBack;
        
    }
    
}

#pragma mark -
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

- (UIImage*) screenshot{
    return [self screenshot: self.view];
}

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

#pragma mark -
#pragma mark Drawing
// draw photo frames
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

// draw special effects
- (UIImage*) drawPhotoSpecialWithData: (NSArray*) dataArr{
    if (dataArr == nil || dataArr.count == 0) {
        return nil;
    }
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(ctx, 0.0, self.view.frame.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
    
    for (NSValue *value in dataArr) {
        BGSpecialData data;
        [value getValue:&data]; // convert value to expected struct data
        
        CGContextDrawImage(ctx, data.posLandscape, [data.image CGImage]);
        
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}


#pragma mark -
#pragma mark UIScrollView Delegate methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.photoView;
}

@end
