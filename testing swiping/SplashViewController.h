//
//  SplashViewController.h
//  testing swiping
//
//  Created by Matteo Sandrin on 12/02/15.
//  Copyright (c) 2015 Richard Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HKNewsFetcher.h"

@interface SplashViewController : UIViewController

{
    UIView *overlayView;
    CGSize winSize;
}

@property (weak, nonatomic) IBOutlet UIProgressView *dataProgressBar;

@end
