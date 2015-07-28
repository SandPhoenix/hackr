//
//  ModelViewController.m
//  testing swiping
//
//  Created by Matteo Sandrin on 04/05/15.
//  Copyright (c) 2015 Richard Kim. All rights reserved.
//

#import "ModelViewController.h"

@implementation ModelViewController

- (IBAction)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)login:(id)sender {
    NSString *user = self.userTextField.text;
    NSString *pass = self.passTextField.text;
    NSLog(@"%@",user);
    NSLog(@"%@",pass);
    int code = [self authenticate:user pass:pass];
    UIAlertView *alert;
    if (code == 200) {
        alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Login successful" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        self.userTextField.text = @"";
        self.passTextField.text = @"";
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"pass_keychain" accessGroup:nil];
        [keychainItem setObject:pass forKey:(id)CFBridgingRelease(kSecValueData)];
        [keychainItem setObject:user forKey:(id)CFBridgingRelease(kSecAttrAccount)];
        NSLog(@"saved %@",[keychainItem objectForKey:(id)CFBridgingRelease(kSecAttrAccount)]);
    }else if ( code == 403 ){
        alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Invalid Username or Password" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    }else{
        alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Network error. Try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    }
    [alert show];
    
    
}

-(int) authenticate:(NSString*)user pass:(NSString*)pass{

//    NSDictionary *params = @{@"username":user,@"password":pass};
//    AFHTTPRequestOperationManager *m = [AFHTTPRequestOperationManager manager];
    NSError *error;
    int code = [[NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.instapaper.com/api/authenticate?username=%@&password=%@",user,pass]] encoding:NSUTF8StringEncoding error:&error] intValue];
    NSLog(@"%d",code);
    if (error) {
        NSLog(@"%ld",(long)error.code);
    }
//    [m POST:@"https://www.instapaper.com/api/authenticate" parameters:params success:^(AFHTTPRequestOperation *operation,id responseObject){
//        code = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"code %@",code);
//    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
//        code = @"500";
//    }];
    
    return code;
}

@end
