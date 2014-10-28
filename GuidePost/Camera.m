//
//  Camera.m
//  GuidePost
//
//  Created by abc on 10/22/14.
//  Copyright (c) 2014 abc. All rights reserved.
//

#import "Camera.h"

@implementation Camera

+(BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+(BOOL)cameraSupportsMedia:(NSString *)paramMediaType
                sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        NSLog(@"Media type is empty");
        return  NO;
    }
    
    NSArray * availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString * mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]) {
            result = YES;
            *stop = YES;
        }
    }];
    
    return result;
}

+(BOOL) doesCameraSupportTakingPhotos{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

+(BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

+(BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage
                          sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}


@end
