//
//  BGGalleryTableViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/02.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGGalleryTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import "JMWhenTapped.h"

@interface BGGalleryTableViewController ()

@end

@implementation BGGalleryTableViewController
@synthesize delegate, isOnlineData, dataSource;

//- (id)init{
//    return [self initWithDataSource:nil isOnlineData:NO];
//}
//
//- (id) initWithDataSource: (NSArray*) ds isOnlineData: (BOOL)online{
//    self = [super init];
//    if (self) {
//        // Custom initialization
//        self.dataSource = ds;
//        self.isOnlineData = online;
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor clearColor];
    self.arrayView.itemSize = CGSizeMake(200, 200);
//    [self.arrayView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload{
    dataSource=nil;
    
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    [dataSource release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Actions and Private methods
- (NSString*) getGalleryImageURI: (NSDictionary*)galleryBook {
    NSString *uri = [galleryBook objectForKey:@"GalleryURI"];
    if (!isOnlineData) {
        // is offline data
        return [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@/index.png", uri];
    }else{
        // is online data
        return [NSString stringWithFormat:@"%@/index.png", uri];
    }
}

#pragma mark -
#pragma mark ATArrayViewDelegate methods
- (NSInteger)numberOfItemsInArrayView:(ATArrayView *)arrayView {
//    return [self.dataSource count];
    return 2;
}

- (UIView *)viewForItemInArrayView:(ATArrayView *)arrayView atIndex:(NSInteger)index {
    UIView *itemView = (UIView *) [arrayView dequeueReusableItem];
    if (itemView == nil) {
        itemView = [[[UIView alloc] init] autorelease];
        itemView.backgroundColor = [UIColor yellowColor];
    }
//    else{
//        UIView *removeView = nil;
//        removeView = [itemView viewWithTag:kRemoveViewTag];
//        if (removeView) {
//            [removeView removeFromSuperview];
//        }
//    }
    
    // add tap guesture to call delegate method
    [itemView whenTapped:^{
        if (nil != delegate) {
            [delegate itemCellSelected:index];
        }
    }];
    
//    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.arrayView.itemSize.width, self.arrayView.itemSize.height)] autorelease];
//    imageView.tag = kRemoveViewTag;
//    NSString *imageURI = [self getGalleryImageURI:[self.dataSource objectAtIndex:index]];
//    NSLog(@"loading gallery imagURI: %@", imageURI);
//    
//    if (!isOnlineData){
//        // local gallery
//        imageView.image = [UIImage imageWithContentsOfFile:imageURI];
//    }else{
//        // online gallery
//        [imageView setImageWithURL:[NSURL URLWithString:imageURI] placeholderImage:[UIImage imageNamed:@"loading.jpg"]];
//    }
//    
//    [itemView addSubview:imageView];
    
    return itemView;
}

@end
