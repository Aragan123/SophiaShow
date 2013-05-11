//
//  UIView+BGReflection.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/11.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSReflectionLayer.h"

@interface UIView (BGReflection)

- (void)setYRotation:(CGFloat)degrees;
- (void)setXRotation:(CGFloat)degrees;

// Add a reflection in the super layer. 
- (DSReflectionLayer *)addReflectionToSuperLayer;

// Clears any reflection layer of the super layer linked with the receiver.
- (void)clearReflecitonLayer;

@end
