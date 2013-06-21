//
//  BGGlobalData.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/03/23.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef kGlobalDataFileName
#define kGlobalDataFileName @"SettingData"

#define kMenuBgPattern 0
#define kMenuPhotoFrame 1
#define kMenuPhotoFilter 2
#define kMenuSpecial 3

#endif

typedef struct{
    int type;
    UIImage *image;
    UIColor *color;
    float alpha;
    int blendMode;
} BGFilterData;

typedef struct{
    UIImage *image;
    float alpha;
    CGRect posLandscape;
    CGRect posPortrait;
} BGSpecialData;


@interface BGGlobalData : NSObject{
    NSArray *galleryBooks;
    NSArray *onlineGalleryBooks;
    NSArray *galleryImages;
    NSDictionary *filterResourceIcons;
    NSDictionary *filterResources;
}

@property (nonatomic, retain) NSArray *galleryBooks;
@property (nonatomic, retain) NSArray *onlineGalleryBooks;
@property (nonatomic, retain) NSArray *galleryImages;
@property (nonatomic, retain) NSDictionary *filterResourceIcons;
@property (nonatomic, retain) NSDictionary *filterResources;

+ (BGGlobalData *) sharedData;
-(void) loadSettingsDataFile;
-(void) writeToSettingsDataFile;
-(NSString *) settingsDataFilePath;

-(NSString*) getFilterKeyStringByKeyIndex: (int) keyIndex;
-(UIImage*) getFilterResourceByIndex: (int) index andKeyIndex:(int)keyIndex;

@end
