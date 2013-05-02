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
    
	[super release];
}

@end
