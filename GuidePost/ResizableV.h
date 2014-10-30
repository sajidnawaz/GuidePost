//
//  ResizableV.h
//  GuidePost
//
//  Created by abc on 10/26/14.
//  Copyright (c) 2014 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResizableV : UIView
{
    
}

- (void) collapse;
- (void) expand;
- (void) toggle;

@property (nonatomic, assign) CGRect expandedFrame;
@property (nonatomic, assign) CGRect collapsedFrame;

- (void)updateFrames:(CGRect)frame;

@end
