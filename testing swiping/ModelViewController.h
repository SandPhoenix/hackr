//
//  ModelViewController.h
//  testing swiping
//
//  Created by Matteo Sandrin on 04/05/15.
//  Copyright (c) 2015 Richard Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "KeychainItemWrapper.h"

@interface ModelViewController : UIViewController
- (IBAction)closeModal:(id)sender;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;

@end
