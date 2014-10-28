//
//  Validator.h
//  GuidePost
//
//  Created by abc on 10/28/14.
//  Copyright (c) 2014 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^VSuccessBlock)(void);
typedef void (^VFailureBlock)(void);

@interface Validator : NSObject
{
    dispatch_queue_t backgroundQueue;
}

- (void)validateUrl:(NSString*)url withSuccessBlock:(VSuccessBlock)successBlock withFailureBlock:(VFailureBlock) failBlock;

@end
