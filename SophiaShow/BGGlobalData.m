//
//  BGGlobalData.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/03/23.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGGlobalData.h"

static BGGlobalData *instance = nil;

@implementation BGGlobalData
@synthesize galleryImages, galleryBooks, onlineGalleryBooks, filterResourceIcons, filterResources, isPortrait;

#pragma mark -
#pragma mark Data File Read & Write
- (void) loadSettingsDataFile {
	NSString *filePath = [self settingsDataFilePath];
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
#ifdef DEBUG
		NSLog(@"Get Settings Data File");
#endif
		//get data dictionary and set values
		NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:filePath];
//		self.pregDay = [settings objectForKey:@"DateOfPregnancy"];
//		self.birthDay = [settings objectForKey:@"DateOfBirth"];
//		self.cardDay = [settings objectForKey:@"DateOfCard"];
//		self.hasPregdaySet = [[settings objectForKey:@"HasPregdaySet"] boolValue];
//		self.hasBirthdaySet = [[settings objectForKey:@"HasBirthdaySet"] boolValue];
//		self.hasCarddaySet = [[settings objectForKey:@"HasCarddaySet"] boolValue];
		self.galleryBooks = [settings objectForKey:@"GalleryBooks"];
        self.filterResourceIcons = [settings objectForKey:@"FilterResourceIcons"];
        self.filterResources = [settings objectForKey:@"FilterResources"];
        
		[settings release];
	}
}

- (void) writeToSettingsDataFile {
	NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
	// set values
//	[settings setValue:self.pregDay forKey:@"DateOfPregnancy"];
//	[settings setValue:self.birthDay forKey:@"DateOfBirth"];
//	[settings setValue:self.cardDay forKey:@"DateOfCard"];
//	[settings setValue:[NSNumber numberWithBool:self.hasPregdaySet] forKey:@"HasPregdaySet"];
//	[settings setValue:[NSNumber numberWithBool:self.hasBirthdaySet] forKey:@"HasBirthdaySet"];
//	[settings setValue:[NSNumber numberWithBool:self.hasCarddaySet] forKey:@"HasCarddaySet"];
	[settings setValue:self.galleryBooks forKey:@"GalleryBooks"];
    
	// write to file
	[settings writeToFile:[self settingsDataFilePath] atomically:YES];
	[settings release];
}


- (NSString *) settingsDataFilePath {
	return [[NSBundle mainBundle] pathForResource:kGlobalDataFileName ofType:@"plist"];
}



#pragma mark -
#pragma mark Class Definition
- (id) init {
	self = [super init];
	if (self) {
		[self loadSettingsDataFile];
        
        isPortrait = YES; // default value
	}
	return self;
}

+ (BGGlobalData *) sharedData{
    @synchronized (self) {
		if (instance == nil) {
			instance = [[BGGlobalData alloc] init];
		}
	}
	return instance;
}

+ (id)allocWithZone:(NSZone *)zone{
	@synchronized (self) {
		if (instance == nil) {
			instance = [super allocWithZone:zone];
			return instance;
		}
	}
	return nil; // on subsequent allocation attempts, return nil;
}

- (id) copyWithZone:(NSZone *)zone{
	return self;
}

- (id) retain{
	return self;
}

- (NSUInteger)retainCount{
	return UINT_MAX; //denotes an object that cannot be released
}

- (oneway void) release{
	instance = nil;
	[galleryBooks release];
    [onlineGalleryBooks release];
    [galleryImages release];
    [filterResourceIcons release];
    [filterResources release];
    
	[super release];
}

#pragma mark --
#pragma mark Utilities
-(NSString*) getFilterKeyStringByKeyIndex: (int) keyIndex{
    NSString *key = @"";
    switch (keyIndex) {
        case kMenuBgPattern:
            key = @"BackgroundPattern"; break;
        case kMenuPhotoFrame:
            key = @"PhotoFrame"; break;
        case kMenuPhotoFilter:
            key = @"PhotoFilter"; break;
        case kMenuSpecial:
            key = @"Specials"; break;
            
        default:
            break;
    }

    return key;
}

- (NSString*) getFilterDataStringByIndex: (int) index andKeyIndex:(int) keyIndex{
    NSString *key = [self getFilterKeyStringByKeyIndex:keyIndex];
    NSArray *arr = [self.filterResources objectForKey:key];
    NSString *resStr = [arr objectAtIndex:index];

    return resStr;
}

-(UIImage*) getFilterResourceByIndex: (int) index andKeyIndex:(int)keyIndex{
    NSString *resStr = [self getFilterDataStringByIndex:index andKeyIndex:keyIndex];
    
    NSString *resUri = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:resStr];
    UIImage *img = [UIImage imageWithContentsOfFile:resUri];
    
    return img;
}

- (BGFilterData) getFilterDataByIndex: (int) index{
    NSString *resStr =  [self getFilterDataStringByIndex:index andKeyIndex:kMenuPhotoFilter];
    
    NSArray *resArr = [resStr componentsSeparatedByString:@"|"];
    BGFilterData filterData;
    filterData.type = [resArr[0] intValue];
    filterData.alpha = [resArr[2] floatValue];
    filterData.blendMode = [resArr[3] intValue];
    
    if (filterData.type == 0) {
        // this is file
        NSString *resUri = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:resArr[1]];
        filterData.image = [UIImage imageWithContentsOfFile:resUri];
        filterData.color = nil;
    }else{
        // this is a color
        NSArray *colorArray = [resArr[1] componentsSeparatedByString:@","];
        filterData.color = [UIColor colorWithRed:[colorArray[0] intValue]
                                           green:[colorArray[1] intValue]
                                            blue:[colorArray[2] intValue]
                                           alpha:filterData.alpha];
        filterData.image = nil;
    }

    return filterData;
}

- (NSDictionary*) getSpecialDataByIndex: (int) index{
    NSString *resStr =  [self getFilterDataStringByIndex:index andKeyIndex:kMenuSpecial];
    NSArray *resArr = [resStr componentsSeparatedByString:@"&"];
    
    NSMutableArray *foreDataArr = [NSMutableArray arrayWithCapacity:(resArr.count/2)];
    NSMutableArray *backDataArr = [NSMutableArray arrayWithCapacity:(resArr.count/2)];
    
    for (NSString *dataString in resArr){
        BGSpecialData specialData = [self getSingleSpecialDataByIndex:dataString];
        NSValue *myValue = [NSValue value:&specialData withObjCType:@encode(BGSpecialData)]; // write struct to array as NSValue
        
        if (specialData.layer == 0) { // back layer
            [backDataArr addObject:myValue];
        }else{
            [foreDataArr addObject:myValue];
        }
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[backDataArr, foreDataArr] forKeys:@[kBackSpecialLayerKey, kForeSpecialLayerKey]];
    return dict;

}

- (BGSpecialData) getSingleSpecialDataByIndex: (NSString*) dataString{
    NSArray *resArr = [dataString componentsSeparatedByString:@"|"];
    BGSpecialData data;
    NSString *resUri = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:resArr[0]];
    data.image = [UIImage imageWithContentsOfFile:resUri];
    data.alpha = [resArr[1] floatValue];
    data.layer = [resArr[2] intValue];
    data.posPortrait = CGRectFromString(resArr[3]);
    data.posLandscape = CGRectFromString(resArr[4]);
    
    return data;
}

@end
