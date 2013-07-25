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

#define kForeSpecialLayerKey @"FORESPECIALS"
#define kBackSpecialLayerKey @"BACKSPECIALS"

#endif

typedef struct{
    int type;
    UIImage *image;
    UIColor *color;
    float alpha;
    int blendMode;
    float brightness;
    float contrast;
} BGFilterData;

typedef struct{
    UIImage *image;
    float alpha;
    int layer;
    CGRect posLandscape;
    CGRect posPortrait;
} BGSpecialData;


@interface BGGlobalData : NSObject{
    NSArray *galleryBooks;
    NSArray *onlineGalleryBooks;
    int currentGalleryIndex;
    NSDictionary *filterResourceIcons;
    NSDictionary *filterResources;
    
    // for filter view only
    BOOL isPortrait; // default is YES
}

@property (nonatomic, retain) NSArray *galleryBooks;
@property (nonatomic, retain) NSArray *onlineGalleryBooks;
@property (nonatomic, retain) NSDictionary *filterResourceIcons;
@property (nonatomic, retain) NSDictionary *filterResources;
@property (nonatomic, assign) BOOL isPortrait;
@property (nonatomic, assign) int currentGalleryIndex;


+ (BGGlobalData *) sharedData;
-(void) loadSettingsDataFile;
-(void) writeToSettingsDataFile;
-(NSString *) settingsDataFilePath;

- (NSArray*) getCurrentGalleryImageURIs;
- (NSString*) getCurrentGalleryTitle;

-(NSString*) getFilterKeyStringByKeyIndex: (int) keyIndex;
-(UIImage*) getFilterResourceByIndex: (int) index andKeyIndex:(int)keyIndex;
- (BGFilterData) getFilterDataByIndex: (int) index;
- (NSDictionary*) getSpecialDataByIndex: (int) index;

@end
