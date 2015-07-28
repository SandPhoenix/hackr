//
//  HKNewsFetcher.m
//  Hackr
//
//  Created by Matteo Sandrin on 10/02/15.
//  Copyright (c) 2015 Matteo Sandrin. All rights reserved.
//
//@"https://hacker-news.firebaseio.com/v0/topstories.json"

#import "HKNewsFetcher.h"
HKNewsFetcher *fetcher;

@implementation HKNewsFetcher


+(id) sharedFetcher{
    if (fetcher == nil) {
        fetcher = [[HKNewsFetcher alloc] init];
    }
    
    return fetcher;
}

-(void) fetchNewsWithTarget:(id)t selector:(SEL)s count:(SEL)c{
    self.storedNews = [[NSUserDefaults standardUserDefaults] arrayForKey:@"clubmaster"];
    if (self.storedNews == nil) {
        self.storedNews = [NSMutableArray array];
        [[NSUserDefaults standardUserDefaults] setObject:self.storedNews forKey:@"clubmaster"];
    }
    
    
    self.news = [NSMutableArray array];
    AFHTTPRequestOperationManager *m = [AFHTTPRequestOperationManager manager];
    [m GET:@"https://hacker-news.firebaseio.com/v0/topstories.json"
parameters:nil
   success:^(AFHTTPRequestOperation *operation,id responseObject){
       
       NSArray *res = [(NSMutableArray*)responseObject subarrayWithRange:NSMakeRange(0, 100)];
//       NSLog(@"%@",res);
       for (NSNumber *n in res) {
           if ([self isValid:n]){
               [m GET:[NSString stringWithFormat:@"https://hacker-news.firebaseio.com/v0/item/%@.json",n]
           parameters:nil
              success:^(AFHTTPRequestOperation *operation,id responseObject){
                  NSDictionary *n = (NSDictionary*)responseObject;
//                  NSLog(@"%@ %d",n,newsCount);

                  [self.news addObject:n];
                  [t performSelector:c withObject:n];
                  newsCount += 1;
              }
              failure:^(AFHTTPRequestOperation *operation,NSError *error){
                  NSLog(@"%@",error);
              }];
           }
       }
   }
   failure:^(AFHTTPRequestOperation *operation,NSError *error){
       NSLog(@"Failed to retrieve list");
   }];
}

-(BOOL) isValid:(NSNumber*)num{
    self.storedNews = [[NSUserDefaults standardUserDefaults] arrayForKey:@"clubmaster"];
    for (NSNumber *stored_num in self.storedNews){
        if ([num integerValue] == [stored_num integerValue]) {
            return false;
        }
    }
    return true;
}


@end
