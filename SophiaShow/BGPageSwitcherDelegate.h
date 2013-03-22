//
//  BGPageSwitcherDelegate.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/03/22.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef kPageMain
    #define kPageMain 0
    #define kPageGalleryHome 1
    #define kPageGallery 2
#define kPageAbout 3
#define kPageUI 4
#endif

enum enumPage {
	pageMain =0,
	pageGalleryHome,
	pageGallery,
    pageAbout,
    pageUI,
};

@protocol BGPageSwitcherDelegate <NSObject>

-(void) switchViewTo: (int)toPage fromView:(int)fromPage;

@end
