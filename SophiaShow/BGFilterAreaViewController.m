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
#import "UIScrollView+Screenshot.h"
#import "UIView+Screenshot.h"
#import "UIScreen+SSToolkitAdditions.h"

#import "UIImage+Filter.h"

@interface BGFilterAreaViewController ()

@end

@implementation BGFilterAreaViewController

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
    
    isPortrait = [[BGGlobalData sharedData] isPortrait];
    self.view.frame = [self calculateFilterAreaRect:srcImage.size];
    CGSize areaSize = self.view.frame.size;
    CGPoint areaCentre = CGPointMake(areaSize.width*0.5, areaSize.height*0.5);

    // default color pattern
    UIImage *data = [[BGGlobalData sharedData] getFilterResourceByIndex:5 andKeyIndex:kMenuBgPattern];
    [self updateBackgroundPattern:data];
    
    // default back special layer - UIImageView
    self.specialBackLayer = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, areaSize.width, areaSize.height)] autorelease];
    [self.specialBackLayer setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.specialBackLayer];
    
    // default photo scroll views
    self.scrollView = [[[UIScrollView alloc] initWithFrame:[self calculatePhotoViewRect:self.view.frame]] autorelease];
    self.scrollView.center = areaCentre;
    [self.scrollView setBackgroundColor:[UIColor colorWithRed:255.0/255 green:253.0/255 blue:250.0f/255 alpha:0.5f]];
    [self.scrollView setDelegate:self];
    [self.scrollView setBounces:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:self.scrollView];
    
    CGFloat imageWidth = CGImageGetWidth(srcImage.CGImage);
    CGFloat imageHeight = CGImageGetHeight(srcImage.CGImage);
    NSLog(@"Source image Size: w=%f, h=%f", imageWidth, imageHeight);
    // default photo view
    self.photoView = [[[UIImageView alloc] initWithImage:srcImage] autorelease];
    self.photoView.backgroundColor = [UIColor clearColor];
//    self.scrollView.tileContainerView = self.photoView;
    [self.scrollView addSubview:self.photoView]; // add views
    [self.scrollView setContentSize:CGSizeMake(imageWidth, imageHeight)];
    [self.scrollView setMinimumZoomScale:MIN((self.scrollView.frame.size.width / imageWidth), (self.scrollView.frame.size.height / imageHeight)) ];
    [self.scrollView setMaximumZoomScale:[self calculateScrollerMaxZoom:self.scrollView.frame.size andPhotoSize:CGSizeMake(imageWidth, imageHeight)]];
    [self.scrollView setZoomScale:[self.scrollView minimumZoomScale]];
    
    // default result image view
    self.resultFilterView = [[[UIImageView alloc] initWithFrame:self.scrollView.frame] autorelease];
    [self.resultFilterView setBackgroundColor:[UIColor clearColor]];
    [self.resultFilterView setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:self.resultFilterView];
    
    // default frame view = no default one, just put empty image view
    self.frameView = [[[UIImageView alloc] initWithFrame:[self calculateFrameViewRect:self.view.frame]] autorelease];
    self.frameView.center = areaCentre;
    [self.view addSubview:self.frameView];
    
    // default special layer UIImageView
    self.specialForeLayer = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, areaSize.width, areaSize.height)] autorelease];
    [self.specialForeLayer setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.specialForeLayer];
}

- (void) clearContents{
    NSArray *contents = [self.view subviews];
    for (UIView *view in contents){
        [view removeFromSuperview];
        view = nil;
    }
}

#pragma mark -
#pragma mark Public Methods
- (void) updateBackgroundPattern: (UIImage*) image{
    UIColor *bgColor = [UIColor colorWithPatternImage:image];
    self.view.backgroundColor = bgColor;
}

- (void) updatePhotoFrame: (BGPhotoFrameData) data{
    CGPoint posCentre = CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.5);
    CGRect scrollFrame = CGRectZero;
    
    // check if has any filter effects, if so, remove it and replace with scrollview and original image
    if (self.cropedImage != nil) {
        self.cropedImage = nil; // set it to nil
        [self.resultFilterView removeFromSuperview];
        self.resultFilterView = nil;
        [self.view insertSubview:self.scrollView belowSubview:self.frameView];
    }
    
    // handle selections
    if (data.image == nil) {
        // first index is clicked to remove all frames
        scrollFrame= [self calculatePhotoViewRect:self.view.frame];
        self.frameView.image = nil;  // remove frame image

    }else{
        // rest index button is clcked to actually ADD a frame image
        if (isPortrait) scrollFrame.size = data.size;
        else {scrollFrame.size.width = data.size.height; scrollFrame.size.height= data.size.width;}
        
        // set frame image
        if (isPortrait) {
            self.frameView.image = data.image;
        }else{
            UIImage *rotation = [data.image imageRotatedByDegrees:-90.0f];
            self.frameView.image = rotation;
        }
        
//        self.frameView.image = [self drawPhotoFrame:data.image withOffsize:data.offsize]; 

    }
    
    // reset scroll view frame;
    self.scrollView.frame = scrollFrame;
    self.scrollView.center = posCentre; // in centre
    // refresh minimal scale
    CGFloat imageWidth = CGImageGetWidth(self.originalImage.CGImage);
    CGFloat imageHeight = CGImageGetHeight(self.originalImage.CGImage);
    [self.scrollView setMinimumZoomScale:MIN((self.scrollView.frame.size.width / imageWidth), (self.scrollView.frame.size.height / imageHeight)) ];
    if (self.scrollView.zoomScale < self.scrollView.minimumZoomScale) {
        self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    }
    // reset result filter view frame = scroll view frame
    self.resultFilterView.frame = self.scrollView.frame;
}

- (void) updatePhotoFilter: (BGFilterData) data{
    NSLog(@"update photo filter is called");
    self.filterData = data;
    [self.filterData.image retain];
    
    if (data.image == nil) {
        // remove filter layer
        NSLog(@"remove photo filter");
        if (self.cropedImage == nil) {
            return; // do nothing, this happends when 1st filter button is clicked but not filtered yet
        }else{
            self.cropedImage = nil; // set it to nil
            [self.resultFilterView removeFromSuperview];
            self.resultFilterView = nil;
            [self.view insertSubview:self.scrollView belowSubview:self.frameView];
        }
        
    }else{
        // add filter image
        if (self.cropedImage == nil) { // first time
            self.cropedImage = [self.scrollView imageByRenderingCurrentVisibleRect]; // get cropped image
            [self.scrollView removeFromSuperview]; // remove scroll view
            
            if (self.resultFilterView == nil) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.scrollView.frame];
                [imageView setBackgroundColor:[UIColor clearColor]];
                self.resultFilterView.contentMode = UIViewContentModeScaleAspectFill;
                self.resultFilterView = imageView;
                [imageView release];
            }
            [self.view insertSubview:self.resultFilterView belowSubview:self.frameView];

        }
        
        // resize filter image and blend it to cropped image
//        UIImage *resizedImage = [data.image imageScaledToSize:self.cropedImage.size];
        UIImage *resizedImage = [data.image resizeImageFromSize:data.image.size toSize:self.cropedImage.size orientation:isPortrait];
        UIImage *filterImage = self.cropedImage;

        if (data.type == 1) { // add Differences Blending Mode of blue image with alpha 0.22
            NSLog(@"Add Blue Filter");
            NSString *blueImagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/Filters/filter_type1.jpg"];
            UIImage *blueImage = [UIImage imageWithContentsOfFile:blueImagePath];
            UIImage *resizedBlueImage = [blueImage resizeImageFromSize:blueImage.size toSize:self.cropedImage.size orientation:isPortrait];
            filterImage = [filterImage imageBlendedWithImage:resizedBlueImage blendMode:kCGBlendModeDifference alpha:0.22f];
            
//            self.resultFilterView.image = resizedBlueImage;
        }
        
        // Finally add blending
        UIImage *result = [filterImage imageBlendedWithImage:resizedImage blendMode:(CGBlendMode)data.blendMode alpha:data.alpha];
        
        // then add contrast and brightness to result image
        NSLog(@"update photo filer brightness=%f, contrast=%f", data.brightness, data.contrast);
        if (data.brightness != 0.0f) { // change brightness
            result = [result brightness:data.brightness];
        }
        if (data.contrast != 0.0f) { // change contrast
            result = [result contrast:data.contrast];
        }
        
        self.resultFilterView.image = result;

    }
}

// Slider change to update filter opacity
- (void) updateFilterOpacity: (float) value{
    UIImage *resizedImage = [self.filterData.image imageScaledToSize:self.cropedImage.size];
    UIImage *result = [self.cropedImage imageBlendedWithImage:resizedImage blendMode:(CGBlendMode)self.filterData.blendMode alpha:value];
    self.resultFilterView.image = result;
}

// specials is chosen
- (void) updatePhotoSpecials: (NSDictionary*) dataDict{    
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

// take screenshot of self - UIView category
- (UIImage*) screenshot{
    return [self.view screenshot];
}

#pragma mark -
#pragma mark Utility and Private Methods

- (CGRect) calculateFilterAreaRect: (CGSize) imageSize{
    CGRect rect = CGRectZero;
    if (isPortrait)
        rect = CGRectMake(50, 8, 800, 750);
    else rect = CGRectMake(50, 8, 800, 750);

    return rect;
}

- (CGRect) calculateFrameViewRect: (CGRect) filterAreaRect{
    CGRect rect = CGRectZero;
    if (isPortrait) {
        rect = CGRectMake(50, 30, 550, 690);
    }else
        rect = CGRectMake(35, 35, 690, 550);
    return rect;
}

- (CGRect) calculatePhotoViewRect: (CGRect) filterAreaRect{
    CGRect rect = CGRectZero;
    if (isPortrait) {
        rect = CGRectMake(85, 60, 471, 628);
    }else
        rect =  CGRectMake(98, 73, 628, 471);
    
    return rect;
}

- (float) calculateScrollerMaxZoom: (CGSize) scrollerSize andPhotoSize:(CGSize) photoSize{
    if ([[UIScreen mainScreen] isRetinaDisplay]) {
        return 1.5f;
    }else{
        return 2.0f;
    }
}

#pragma mark -
#pragma mark Drawing
// draw photo frames
- (UIImage *) drawPhotoFrame: (UIImage*) frameSource withOffsize:(float) offsize{
    CGSize srcSize = CGSizeMake(50.0f, 50.0f);
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
    UIGraphicsEndImageContext();
    
    return result;
}

// draw special effects
- (UIImage*) drawPhotoSpecialWithData: (NSArray*) dataArr{
    if (dataArr == nil || dataArr.count == 0) {
        return nil;
    }
    
    CGSize areaSize = self.view.frame.size;
    UIGraphicsBeginImageContext(areaSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(ctx, 0.0, self.view.frame.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
        
    for (NSValue *value in dataArr) {
        BGSpecialData data;
        [value getValue:&data]; // convert value to expected struct data
        if (isPortrait) {
            CGContextDrawImage(ctx, data.posPortrait, [data.image CGImage]);
        }else{
            CGContextDrawImage(ctx, data.posLandscape, [data.image CGImage]);
        }
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

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
        (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
        (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

//-(void)scrollViewDidZoom:(UIScrollView *)pScrollView {
//    UIView *imageView = [pScrollView.subviews objectAtIndex:0];
//
//    CGRect innerFrame = imageView.frame;
//    CGRect scrollerBounds = pScrollView.bounds;
//    
//    if ( ( innerFrame.size.width < scrollerBounds.size.width ) || ( innerFrame.size.height < scrollerBounds.size.height ) )
//    {
//        CGFloat tempx = imageView.center.x - ( scrollerBounds.size.width / 2 );
//        CGFloat tempy = imageView.center.y - ( scrollerBounds.size.height / 2 );
//        CGPoint myScrollViewOffset = CGPointMake( tempx, tempy);
//        
//        pScrollView.contentOffset = myScrollViewOffset;
//        
//    }
//    
//    UIEdgeInsets anEdgeInset = { 0, 0, 0, 0};
//    if ( scrollerBounds.size.width > innerFrame.size.width )
//    {
//        anEdgeInset.left = (scrollerBounds.size.width - innerFrame.size.width) / 2;
//        anEdgeInset.right = -anEdgeInset.left;  // I don't know why this needs to be negative, but that's what works
//    }
//    if ( scrollerBounds.size.height > innerFrame.size.height )
//    {
//        anEdgeInset.top = (scrollerBounds.size.height - innerFrame.size.height) / 2;
//        anEdgeInset.bottom = -anEdgeInset.top;  // I don't know why this needs to be negative, but that's what works
//    }
//    pScrollView.contentInset = anEdgeInset;
//}

@end
