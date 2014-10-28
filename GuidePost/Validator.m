//
//  Validator.m
//  GuidePost
//
//  Created by abc on 10/28/14.
//  Copyright (c) 2014 abc. All rights reserved.
//

#import "Validator.h"

@implementation Validator

- (id) init
{
    if (self = [super init]) {
        backgroundQueue = dispatch_queue_create("com.guidepost.validate", NULL);
    }
    return self;
}

- (void)validateUrl:(NSString*)url withSuccessBlock:(VSuccessBlock)successBlock withFailureBlock:(VFailureBlock) failBlock{
    
    dispatch_async(backgroundQueue, ^{
        NSString *urlRegEx =
        @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
        NSPredicate *urlPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
        BOOL result = [urlPred evaluateWithObject:url];
        
        
        // execute this block on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
                successBlock();
            else
                failBlock();
        });
        
        
    });
}
    
@end
