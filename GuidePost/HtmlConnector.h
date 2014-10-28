//
//  HtmlConnector.h
//  GuidePost
//
//  Created by abc on 10/28/14.
//  Copyright (c) 2014 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HCSuccessBlock)(NSData *data);
typedef void (^HCFailureBlock)(NSError *error);

@interface HtmlConnector : NSObject
{
    dispatch_queue_t backgroundQueue;
}

- (void) getContentsOfURLFromString:(NSString *) urlString withSuccessBlock:(HCSuccessBlock) successBlock withFailureBlock:(HCFailureBlock) failureBlock;

- (void) getImageFromURL:(NSString *) urlString withSuccessBlock:(HCSuccessBlock) successBlock withFailureBlock:(HCFailureBlock) failureBlock;

@end
