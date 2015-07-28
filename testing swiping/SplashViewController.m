//
//  SplashViewController.m
//  testing swiping
//
//  Created by Matteo Sandrin on 12/02/15.
//  Copyright (c) 2015 Richard Kim. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 0)];
    overlayView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:overlayView];
    winSize = self.view.bounds.size;
    NSLog(@"I'm actually splashing!");
    [self goToApp];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) goToApp{
    [self performSegueWithIdentifier:@"introSegue" sender:self];
}

-(void) updateBar:(NSNumber*)value{
    
    
    float time = 2*[value floatValue]/30.0f;
    float pos = winSize.height*[value floatValue]/30.0f*2;
    NSLog(@"update:%d %f",[value intValue],pos);
    // 2:x=max:value
    [UIView animateWithDuration:0.02 animations:^{
        overlayView.bounds = CGRectMake(0, winSize.height-pos, winSize.width, pos);
    }];
//    [self.dataProgressBar setProgress:[value intValue]/100.0f animated:true];
//    [self.dataProgressBar setHidden:false];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
