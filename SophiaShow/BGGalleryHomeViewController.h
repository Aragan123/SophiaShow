//
//  BGGalleryHomeViewController.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/02.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGGalleryHomeViewController : UIViewController{
    BOOL isOnlineData;
    NSArray *dataSource;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isOnlineData:(BOOL) online;

@end
