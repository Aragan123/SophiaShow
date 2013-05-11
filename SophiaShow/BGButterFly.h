//
//  BGButterFly.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/08.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGButterFly : UIImageView{
    NSMutableArray *images;
    CGPoint moveTo;
    int butterflyType;
    
}

@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, assign) CGPoint moveTo;
@property (nonatomic, assign) int butterflyType;

- (void)animateMoving;
- (void)animateFlying;
- (void)animateFlyingAndMoving;
@end
