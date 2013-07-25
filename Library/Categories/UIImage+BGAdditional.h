//
//  UIImage+BGAdditional.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/06/21.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BGAdditional)

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
-(UIImage*)imageCropByFrame:(CGRect)frame;

- (UIImage *)imageBlendedWithImage:(UIImage *)overlayImage blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;


// jeff defined
- (UIImage *)resizeImageToSize: (CGSize)targetSize;
- (UIImage*) imageScaledToSize: (CGSize) newSize;
- (UIImage*) resizeImageFromSize: (CGSize)fromSize toSize:(CGSize)toSize orientation:(BOOL)isPortrait;
- (UIImage*) imageWithBrightness:(float)b andContrast:(float)c;
@end
