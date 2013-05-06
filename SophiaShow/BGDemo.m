//
//  BGDemo.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/05/04.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGDemo.h"

@implementation BGDemo

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

        self.arrayView.itemSize = CGSizeMake(200, 200);
    
}


#pragma mark -
#pragma mark ATArrayViewDelegate methods

- (NSInteger)numberOfItemsInArrayView:(ATArrayView *)arrayView {
    return 9;
}

- (UIView *)viewForItemInArrayView:(ATArrayView *)arrayView atIndex:(NSInteger)index {
    UIView *itemView = (UIView *) [arrayView dequeueReusableItem];
    if (itemView == nil) {
        itemView = [[[UIView alloc] init] autorelease];

    }
    itemView.backgroundColor = [UIColor yellowColor];
    return itemView;
}

@end
