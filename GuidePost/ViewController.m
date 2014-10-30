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

    [self.imageButton setTitle:@"Loading..." forState:UIControlStateDisabled];
    
    self.urlTextField.text = @"http://www.yahoo.com";
//    [self.loadButton setEnabled:NO];
    [self.urlTextField setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // different orientations have different sizes so need to uodate frames
    [self.resizableView updateFrames:self.resizableView.frame];
    [self performSelector:@selector(collapse) withObject:nil afterDelay:0.1];
    [self.view setNeedsLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    [self.resizableView updateFrames:self.resizableView.frame];
//    [self.view setNeedsLayout];
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

-(void)populateUI:(NSData*)data {
    TFHpple *doc = [TFHpple hppleWithHTMLData:data encoding:@"utf-8"];
    
    NSString *title = [self retrieveHtmlContentForXPath:@"//meta[@property='og:title']/@content" alternateXPath:@"//title" withDoc:doc];
    NSString *imageUrl = [self retrieveHtmlContentForXPath:@"//meta[@property='og:image']/@content" alternateXPath:@"" withDoc:doc];
    NSString *description = [self retrieveHtmlContentForXPath:@"//meta[@property='og:description']/@content" alternateXPath:@"" withDoc:doc];
    
    NSLog(@"Title: %@, Image: %@, Description: %@", title, imageUrl, description);
    
    [self.titleTextField setText:title];
    [self.descriptionTextView setText:description];
    
    [self.imageButton setEnabled:NO];
    [htmlConnector getImageFromURL:imageUrl
                  withSuccessBlock:(HCSuccessBlock)^(NSData *data) {
                      
                      [self.imageButton setEnabled:YES];
                      UIImage *img = [[UIImage alloc] initWithData:data];
                      if(img)
                          [self.imageButton setBackgroundImage:img forState:UIControlStateNormal];
                  } withFailureBlock:(HCFailureBlock)^(NSError * error) {
                      [self.imageButton setEnabled:YES];
                  }];
}

-(void)expand {
    [self.resizableView expand];
}

-(void)collapse {
    [self.resizableView collapse];
}

- (IBAction)loadUrl:(id)sender {
    
    [self.loadButton setEnabled:NO];
    [self.spinner startAnimating];
    
    [self clearContents];

    [htmlConnector getContentsOfURLFromString:[self.urlTextField text]
                             withSuccessBlock:(HCSuccessBlock)^(NSData *data) {
                                 [self populateUI:data];
                                 [self performSelector:@selector(expand) withObject:nil afterDelay:0.1];
                                 
                                 [self.spinner stopAnimating];
                                 [self.loadButton setEnabled:YES];
                                 
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

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    if(textField.tag == 10)
        [self performSelector:@selector(collapse) withObject:nil afterDelay:0.1];
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    
    if(textField.tag == 10) {
        NSString * url = [self.urlTextField text];
        [self validateUrlTextField:url];
    }
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField.tag == 10) {
        NSString * url = [self.urlTextField text];
        [self validateUrlTextField:url];
    }
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    if(textField.tag == 10) {
        if(self.loadButton.enabled)
            [self loadUrl:nil];
    }
    
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
