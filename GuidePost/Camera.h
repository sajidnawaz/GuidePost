//
//  Camera.h
//  GuidePost
//
//  Created by abc on 10/22/14.
//  Copyright (c) 2014 abc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

@interface Camera : NSObject

+(BOOL) isCameraAvailable;
+(BOOL) doesCameraSupportTakingPhotos;
+(BOOL) isPhotoLibraryAvailable;
+(BOOL) canUserPickPhotosFromPhotoLibrary;

@end
