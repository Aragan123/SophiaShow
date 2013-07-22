//
//  BGHomeViewController.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/07/16.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPageSwitcherDelegate.h"

#ifndef kTagHomeButton

#define kTagHomeButton      88
#define kTagHomeParticle1   89
#define kTagHomeParticle2   90
#define kTagHomeParticle3   91

#define kTagHomeMenuGallery 92
#define kTagHomeMenuAbout   93
#define kTagHomeMenuFunc    94

#define kTagAboutBook      95
#define kTagAboutTextEn     96
#define kTagAboutTextCn     97

#define kTagGalleryBeauty   87
#define kTagGalleryFasion   86
#define kTagGalleryPersonal 85
#define kTagGalleryPortrait 84

#endif


@interface BGHomeViewController : UIViewController {
    id<BGPageSwitcherDelegate> delegate;
    int scene;
}

@property (nonatomic, assign) id<BGPageSwitcherDelegate> delegate;
@property (nonatomic, retain) UITapGestureRecognizer *singleTap;
@property (nonatomic, retain) NSArray *arrayHome;
@property (nonatomic, retain) NSArray *arrayGallery;


- (id)initFromScene:(int)num;
@end
