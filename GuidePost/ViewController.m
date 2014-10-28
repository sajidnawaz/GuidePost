//
//  ViewController.m
//  GuidePost
//
//  Created by abc on 10/22/14.
//  Copyright (c) 2014 abc. All rights reserved.
//

#import "ViewController.h"
#import "TFHpple.h"
#import "Camera.h"
#import "ResizableV.h"
#import "Validator.h"
#import "HtmlConnector.h"

@interface ViewController ()
{
    Validator *validator;
    HtmlConnector *htmlConnector;

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    validator = [[Validator alloc] init];
    htmlConnector = [[HtmlConnector alloc] init];

    
#warning tbd
    self.urlTextField.text = @"http://localhost/test.html";
//    [self.loadButton setEnabled:NO];
    [self.urlTextField setDelegate:self];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.resizableView collapse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)validateUrlTextField:(NSString*)url {
    
    [validator validateUrl:url withSuccessBlock:(VSuccessBlock)^{
        [self.loadButton setEnabled:YES];
    } withFailureBlock:(VFailureBlock)^{
        [self.loadButton setEnabled:NO];
    }];

}

- (NSString*)retrieveHtmlContentForXPath:(NSString*)xPathQuery alternateXPath:(NSString*)alternativeXPathQuery withDoc:(TFHpple*)doc {
    NSString * title = @"";
    NSArray *elementsTitle  = [doc searchWithXPathQuery:xPathQuery];
    if (elementsTitle && elementsTitle.count>0) {
        TFHppleElement *element = [elementsTitle objectAtIndex:0];
        title = [element.firstChild content];
    } else if (alternativeXPathQuery.length > 0){
        elementsTitle  = [doc searchWithXPathQuery:alternativeXPathQuery];
        if (elementsTitle && elementsTitle.count>0) {
            TFHppleElement *element = [elementsTitle objectAtIndex:0];
            title = [element.firstChild content];
        }
    }
    return title;
}

-(void)clearContents {
    [self.titleTextField setText:@""];
    [self.descriptionTextView setText:@""];
    [self.imageButton setBackgroundImage:nil forState:UIControlStateNormal];
}

- (IBAction)loadUrl:(id)sender {
    
    [self.loadButton setEnabled:NO];
    [self.spinner startAnimating];
    
    [self clearContents];
    [self.resizableView collapse];

    [htmlConnector getContentsOfURLFromString:[self.urlTextField text]
                             withSuccessBlock:(HCSuccessBlock)^(NSData *data) {
                                 [self.spinner stopAnimating];
                                 [self.loadButton setEnabled:YES];
                                 
                                 TFHpple *doc = [TFHpple hppleWithHTMLData:data encoding:@"utf-8"];
                                 
                                 NSString *title = [self retrieveHtmlContentForXPath:@"//meta[@property='og:title']/@content" alternateXPath:@"//title" withDoc:doc];
                                 NSString *imageUrl = [self retrieveHtmlContentForXPath:@"//meta[@property='og:image']/@content" alternateXPath:@"" withDoc:doc];
                                 NSString *description = [self retrieveHtmlContentForXPath:@"//meta[@property='og:description']/@content" alternateXPath:@"" withDoc:doc];
                                 
                                 NSLog(@"Title: %@, Image: %@, Description: %@", title, imageUrl, description);
                                 
                                 [self.titleTextField setText:title];
                                 [self.descriptionTextView setText:description];
                                 [self.resizableView expand];
                                 
                                 [htmlConnector getImageFromURL:imageUrl
                                                 withSuccessBlock:(HCSuccessBlock)^(NSData *data) {
                                                     UIImage *img = [[UIImage alloc] initWithData:data];
                                                     if(img)
                                                         [self.imageButton setBackgroundImage:img forState:UIControlStateNormal];
                                                 } withFailureBlock:(HCFailureBlock)^(NSError * error) {
                                                 }];
                                 
                             } withFailureBlock:(HCFailureBlock)^(NSError * error) {
                                 [self.spinner stopAnimating];
                                 [self.loadButton setEnabled:NO];
                                 
                             }];
}

- (IBAction)pickPhoto:(id)sender {
    if ([Camera isPhotoLibraryAvailable]){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }

}

- (IBAction)test:(id)sender {
    [self.resizableView toggle];
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
    
    if(self.loadButton.enabled)
        [self loadUrl:nil];
    
    return NO;
    
}

#pragma mark --UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"Picker returned successfully.");
    NSLog(@"%@",info);
    
    NSString * mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(__bridge NSString *)kUTTypeImage]){
        UIImage *img = nil;
        if ([picker allowsEditing]){
            img = info[UIImagePickerControllerEditedImage];
        }else{
            img = info[UIImagePickerControllerOriginalImage];
        }
        
        [self.imageButton setBackgroundImage:img forState:UIControlStateNormal];

    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"Picker was cancelled");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
