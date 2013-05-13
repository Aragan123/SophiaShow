//
//  UIView+BGReflection.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/11.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "UIView+BGReflection.h"

@implementation UIView (BGReflection)

- (void)setYRotation:(CGFloat)degrees anchorPoint:(CGPoint)point perspectiveCoeficient:(CGFloat)m34
{
	CATransform3D transfrom = CATransform3DIdentity;
	transfrom.m34 = 1.0 / m34;
    CGFloat radiants = degrees / 360.0 * 2 * M_PI;
	transfrom = CATransform3DRotate(transfrom, radiants, 0.0f, 1.0f, 0.0f);
	CALayer *layer = self.layer;
	layer.anchorPoint = point;
	layer.transform = transfrom;
}

- (void)setYRotation:(CGFloat)degrees
{
    [self setYRotation:degrees anchorPoint:CGPointMake(0.5, 0.5) perspectiveCoeficient:800];
}

- (void)setXRotation:(CGFloat)degrees anchorPoint:(CGPoint)point perspectiveCoeficient:(CGFloat)m34
{
	CATransform3D transfrom = CATransform3DIdentity;
	transfrom.m34 = 1.0 / m34;
    CGFloat radiants = degrees / 360.0 * 2 * M_PI;
	transfrom = CATransform3DRotate(transfrom, radiants, 1.0f, 0.0f, 0.0f);
	CALayer *layer = self.layer;
	layer.anchorPoint = point;
	layer.transform = transfrom;
}

- (void)setXRotation:(CGFloat)degrees
{
    [self setXRotation:degrees anchorPoint:CGPointMake(0.5, 0.5) perspectiveCoeficient:800];
}

- (void)setXRotation:(CGFloat)degreeX andYRotation:(CGFloat)degreeY anchorPoint:(CGPoint)point perspectiveCoeficient:(CGFloat)m34
{
	CATransform3D transfrom = CATransform3DIdentity;
	transfrom.m34 = 1.0 / m34;
    CGFloat radiantX = degreeX / 360.0 * 2 * M_PI;
    CGFloat radiantY = degreeY / 360.0 * 2 * M_PI;
    
	transfrom = CATransform3DRotate(transfrom, radiantX, 1.0f, 0.0f, 0.0f);
    transfrom = CATransform3DRotate(transfrom, radiantY, 0.0f, 1.0f, 0.0f);
    
	CALayer *layer = self.layer;
	layer.anchorPoint = point;
	layer.transform = transfrom;

}

- (void)setXRotation:(CGFloat)degreeX andYRotation: (CGFloat)degreeY
{
    [self setXRotation:degreeX andYRotation:degreeY anchorPoint:CGPointMake(0.5, 0.5) perspectiveCoeficient:800];
}

- (DSReflectionLayer *)addReflectionToSuperLayer
{
	DSReflectionLayer *layer = [[DSReflectionLayer alloc] initWithLayer:self.layer];
	CALayer *superLayer = [self.layer superlayer];
	[superLayer insertSublayer:layer below:self.layer];
	return layer;
}

- (void)clearReflecitonLayer
{
	CALayer *superLayer = [self.layer superlayer];
	NSArray *superLayerChilds = [superLayer sublayers];
	for (DSReflectionLayer *childLayer in superLayerChilds)
	{
		if ([childLayer isMemberOfClass:[DSReflectionLayer class]] && childLayer.reflectedLayer == self.layer)
		{
            [childLayer removeFromSuperlayer];
            return;
		}
	}
}

@end
