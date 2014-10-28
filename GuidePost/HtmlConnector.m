//
//  HtmlConnector.m
//  GuidePost
//
//  Created by abc on 10/28/14.
//  Copyright (c) 2014 abc. All rights reserved.
//

#import "HtmlConnector.h"

@implementation HtmlConnector

- (id) init
{
    if (self = [super init]) {
        backgroundQueue = dispatch_queue_create("com.guidepost.dataconnection", NULL);
    }
    return self;
}

- (void) getContentsOfURLFromString:(NSString *) urlString
                   withSuccessBlock:(HCSuccessBlock) successBlock
                   withFailureBlock:(HCFailureBlock) failureBlock {
    
    dispatch_async(backgroundQueue, ^{
        NSError * error = nil;
        NSURL * url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:
                        &error];
        
        // execute this block on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                failureBlock(error);
            } else {
                successBlock(data);
            }
        });
        
    });
    
}

- (void) getImageFromURL:(NSString *) urlString
        withSuccessBlock:(HCSuccessBlock) successBlock
        withFailureBlock:(HCFailureBlock) failureBlock {
    
    dispatch_async(backgroundQueue, ^{
        NSError * error = nil;
        NSURL * url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:
                        &error];
        
        // execute this block on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                failureBlock(error);
            } else {
                successBlock(data);
            }
        });
        
    });
    
}

@end
