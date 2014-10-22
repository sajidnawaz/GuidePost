//
//  ViewController.m
//  GuidePost
//
//  Created by abc on 10/22/14.
//  Copyright (c) 2014 abc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.loadButton setEnabled:NO];
    [self.urlTextField setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

typedef void (^VSuccessBlock)(void);
typedef void (^VFailureBlock)(void);

typedef void (^DCSuccessBlock)(NSString * returnData);
typedef void (^DCFailureBlock)(NSError  * error);

- (void)validateUrl:(NSString*)url withSuccessBlock:(VSuccessBlock)successBlock withFailureBlock:(VFailureBlock) failBlock{
    
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.guidepost.validate", NULL);

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

- (void) getContentsOfURLFromString:(NSString *) urlString
                   withSuccessBlock:(DCSuccessBlock) successBlock
                   withFailureBlock:(DCFailureBlock) failureBlock
{
    
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.guidepost.dataconnection", NULL);
    
    dispatch_async(backgroundQueue, ^{
        NSError * error = nil;
        NSURL * url = [NSURL URLWithString:urlString];
        NSString * results = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        
        // execute this block on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                failureBlock(error);
            }
            else {
                successBlock(results);
            }
        });
        
    });

}

- (void)validateUrlTextField:(NSString*)url {
    
    [self validateUrl:url withSuccessBlock:(VSuccessBlock)^{
        [self.loadButton setEnabled:YES];
    } withFailureBlock:(VFailureBlock)^{
        [self.loadButton setEnabled:NO];
    }];

}

- (IBAction)loadUrl:(id)sender {
    
    [self.loadButton setEnabled:NO];
    [self.spinner startAnimating];

    [self getContentsOfURLFromString:[self.urlTextField text]
                             withSuccessBlock:(DCSuccessBlock)^(NSString * resultString) {
                                 [self.textView setText:resultString];
                                 [self.spinner stopAnimating];
                                 [self.loadButton setEnabled:YES];
                                 
                             } withFailureBlock:(DCFailureBlock)^(NSError * error) {
                                 [self.textView setText:[error description]];
                                 [self.spinner stopAnimating];
                                 [self.loadButton setEnabled:NO];
                                 
                             }];
}

#pragma mark - UITextFieldDelegate

- (void) textFieldDidEndEditing:(UITextField *)textField {
    
    NSString * url = [self.urlTextField text];
    [self validateUrlTextField:url];
    
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * url = [self.urlTextField text];
    [self validateUrlTextField:url];
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return NO;
    
}


@end
