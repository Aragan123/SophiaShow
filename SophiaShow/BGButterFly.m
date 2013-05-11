//
//  BGButterFly.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/08.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGButterFly.h"
#import <QuartzCore/QuartzCore.h>
#import "JMWhenTapped.h"

@implementation BGButterFly
@synthesize images, moveTo, butterflyType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.moveTo = CGPointZero;
        self.butterflyType = 0;
        self.images = [[NSMutableArray alloc] initWithCapacity:4];
        
        for (int i=0; i<3; i++) {
            NSString *imageName = [NSString stringWithFormat:@"butterfly%i.png", i];
            [self.images addObject:[UIImage imageNamed:imageName] ];
        }

        
        for (int i=2; i>=0; i--) {
            NSString *imageName = [NSString stringWithFormat:@"butterfly%i.png", i];
            [self.images addObject:[UIImage imageNamed:imageName] ];
        }
        
        self.image = [self.images objectAtIndex:0];
        
        [self whenTapped:^{
            [self animateFlying];
        }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)animateFlying {
    self.animationImages = self.images;
    self.animationDuration = 1.0;
    self.animationRepeatCount=1;
    [self startAnimating];
}

- (void) animateMoving {    
    CABasicAnimation* anim2 = [CABasicAnimation animationWithKeyPath:@"position"];
//    [anim2 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    anim2.duration = 2.0f;
    anim2.toValue = [NSValue valueWithCGPoint: self.moveTo];
    
    [self.layer addAnimation:anim2 forKey:nil];
}

- (void) animateFlyingAndMoving{
    self.animationImages = self.images;
    self.animationDuration = 1.1;
    self.animationRepeatCount=3;

    [UIView animateWithDuration:1.0f
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.center = self.moveTo;
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
    
    [self startAnimating];
}

- (void) dealloc{
    [images release];
    
    [super dealloc];
}

@end
