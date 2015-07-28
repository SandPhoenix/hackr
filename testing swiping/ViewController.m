//
//  ViewController.m
//  testing swiping
//
//  Created by Richard Kim on 5/21/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//
//  @cwRichardKim for updates and requests

#import "ViewController.h"
#import "DraggableViewBackground.h"


@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    DraggableViewBackground *draggableBackground = [[DraggableViewBackground alloc]initWithFrame:self.view.frame];
    [self.view insertSubview:draggableBackground belowSubview:self.settingsButton];
    NSLog(@"viewCONTROLLER");
    [[HKNewsFetcher sharedFetcher] fetchNewsWithTarget:draggableBackground selector:nil count:@selector(insertCardWithData:)];
}


-(void) updateView{
    NSMutableArray *array = [[HKNewsFetcher sharedFetcher] news];
    NSLog(@"%@",array);
}


@end
