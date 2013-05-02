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
    #define kPageOnlineGalleryHome 3
    #define kPageOnlineGallery 4
    #define kPageAbout 5
    #define kPageUI 6
#endif

enum enumPage {
	pageMain =0,
	pageGalleryHome,
	pageGallery,
    pageOnlineGalleryHome,
    pageOnlineGallery,
    pageAbout,
    pageUI,
};

@protocol BGPageSwitcherDelegate <NSObject>

-(void) switchViewTo: (int)toPage fromView:(int)fromPage;

@end
