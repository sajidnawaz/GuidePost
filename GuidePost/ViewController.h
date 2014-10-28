//
//  ViewController.h
//  GuidePost
//
//  Created by abc on 10/22/14.
//  Copyright (c) 2014 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class ResizableV;

@interface ViewController : UIViewController<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
}

@property (nonatomic, strong) IBOutlet UITextField *urlTextField;
@property (nonatomic, strong) IBOutlet UITextField *titleTextField;
@property (nonatomic, strong) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) IBOutlet UIButton *loadButton;
@property (nonatomic, strong) IBOutlet UIButton *imageButton;
@property (nonatomic, strong) IBOutlet ResizableV *resizableView;

- (IBAction)loadUrl:(id)sender;
- (IBAction)test:(id)sender;
- (IBAction)pickPhoto:(id)sender;

@end

