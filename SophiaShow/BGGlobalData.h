//
//  BGGlobalData.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/03/23.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef kGlobalDataFileName
#define kGlobalDataFileName @"BGGlobalVariants"
#endif

@interface BGGlobalData : NSObject{
    
}

+ (BGGlobalData *) sharedData;
-(void) loadSettingsDataFile;
-(void) writeToSettingsDataFile;
-(NSString *) settingsDataFilePath;

@end
