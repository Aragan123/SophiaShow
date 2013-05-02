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
#endif

@interface BGGlobalData : NSObject{
    NSArray *galleryBooks;
    NSArray *onlineGalleryBooks;
}

@property (nonatomic, retain) NSArray *galleryBooks;
@property (nonatomic, retain) NSArray *onlineGalleryBooks;

+ (BGGlobalData *) sharedData;
-(void) loadSettingsDataFile;
-(void) writeToSettingsDataFile;
-(NSString *) settingsDataFilePath;

@end
