//
//  HKNewsFetcher.h
//  Hackr
//
//  Created by Matteo Sandrin on 10/02/15.
//  Copyright (c) 2015 Matteo Sandrin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>


@interface HKNewsFetcher : NSObject <NSURLConnectionDelegate>

{

    id target;
    int newsCount;
}

+(id) sharedFetcher;
-(void) fetchNewsWithTarget:(id)t selector:(SEL)s count:(SEL)c;

@property (nonatomic,strong) NSMutableArray *news;
@property (nonatomic,strong) NSArray *storedNews;

@end
