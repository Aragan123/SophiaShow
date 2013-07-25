//
//  UIImage+BGAdditional.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/06/21.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "UIImage+BGAdditional.h"
#import <CoreImage/CoreImage.h>

@implementation UIImage (BGAdditional)


- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)] autorelease];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

-(UIImage*)imageCropByFrame:(CGRect)frame
{
    //    // Find the scalefactors  UIImageView's widht and height / UIImage width and height
    //    CGFloat widthScale = self.bounds.size.width / self.size.width;
    //    CGFloat heightScale = self.bounds.size.height / self.size.height;
    //
    //    // Calculate the right crop rectangle
    //    frame.origin.x = frame.origin.x * (1 / widthScale);
    //    frame.origin.y = frame.origin.y * (1 / heightScale);
    //    frame.size.width = frame.size.width * (1 / widthScale);
    //    frame.size.height = frame.size.height * (1 / heightScale);
    
    // Create a new UIImage
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, frame);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return croppedImage;
}

- (UIImage *)imageBlendedWithImage:(UIImage *)overlayImage blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha {
    
    UIGraphicsBeginImageContext(self.size);
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:rect];
    
    [overlayImage drawAtPoint:CGPointMake(0, 0) blendMode:blendMode alpha:alpha];
    
    UIImage *blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return blendedImage;
}

// jeff defined
// this is used in gallery view to create thumbnails
// it has better width/Height ratio of resizing
- (UIImage *)resizeImageToSize: (CGSize)targetSize
{
    UIImage *newImage = nil;
    
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // make image center aligned
        if (widthFactor < heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor > heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [self drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil)
        NSLog(@"Error: could not scale image");
    
    return newImage ;
}

// it doesn't care of width/height resizing ratio, faster and better for square image
- (UIImage*) imageScaledToSize: (CGSize) newSize{
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect: CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// rotate first if not portrait
- (UIImage*) resizeImageFromSize: (CGSize)fromSize toSize:(CGSize)toSize orientation:(BOOL)isPortrait{
//    UIImage *result;
    if (!isPortrait) {
        // langscape, need to rotate 90degree
        NSLog(@"rotate filter image by 90 degree");
        self = [self imageRotatedByDegrees:90.0f];
    }//else result = self;
    
    if (fromSize.width != toSize.width || fromSize.height != toSize.height) { //need resize
        self = [self imageScaledToSize:toSize];
    }
    
    return self;
}

- (UIImage*) imageWithBrightness:(float)b andContrast:(float)c{
    CIContext *ctx = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:self.CGImage];

    CIFilter *cif = [CIFilter filterWithName:@"CIColorControls"];
    [cif setValue:image forKey:kCIInputImageKey];
    [cif setValue:[NSNumber numberWithFloat:b] forKey:@"inputBrightness"];
    [cif setValue:[NSNumber numberWithFloat:c] forKey:@"inputContrast"];
    image = cif.outputImage;
    CGImageRef cgImage = [ctx createCGImage:image fromRect:[image extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    ctx = nil;
    
    return newImage;
}

@end
