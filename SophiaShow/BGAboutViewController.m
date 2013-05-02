//
//  BGAboutViewController.m
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/03/22.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGAboutViewController.h"

@interface BGAboutViewController ()

@end

@implementation BGAboutViewController
@synthesize delegate, pages, scroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // init scroll view
    self.scroll.pagingEnabled = YES;
    self.scroll.backgroundColor = [UIColor whiteColor];
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.showsVerticalScrollIndicator = NO;
    self.scroll.contentMode = UIViewContentModeCenter;
    self.scroll.delegate = self;
    
    CGSize scrollViewSize = self.scroll.frame.size;
    CGSize scrollContentSize = CGSizeMake(scrollViewSize.width * 2, scrollViewSize.height);
    [self.scroll setContentSize:scrollContentSize];
    
    // init two views and add them to scroll view
    UIView *v1 = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollViewSize.width, scrollViewSize.height)] autorelease];
    v1.backgroundColor = [UIColor redColor];
    v1.contentMode = UIViewContentModeCenter;
    [self.scroll addSubview:v1];
    
    UIView *v2 = [[[UIView alloc] initWithFrame:CGRectMake(scrollViewSize.width, 0, scrollViewSize.width, scrollViewSize.height)] autorelease];
    v2.backgroundColor = [UIColor yellowColor];
    v2.contentMode = UIViewContentModeCenter;
    [self.scroll addSubview:v2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload{
    self.scroll=nil;
    self.pages=nil;
}

- (void) dealloc{
    delegate=nil;
    [scroll release];
    [pages release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = fabs(scrollView.contentOffset.x) /scrollView.frame.size.width;
    
    self.pages.currentPage = index;
    
}


@end
