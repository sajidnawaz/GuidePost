//
//  ResizableV.m
//  GuidePost
//
//  Created by abc on 10/26/14.
//  Copyright (c) 2014 abc. All rights reserved.
//

#import "ResizableV.h"

@implementation ResizableV

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialiseFrames:frame];
    }
    return self;
}

//initialising from XIB/Storyboard
- (void)awakeFromNib {
    [self initialiseFrames:self.frame];
}

- (void)initialiseFrames:(CGRect)frame {
    self.expandedFrame = frame;
    frame.size.height = 0;
    self.collapsedFrame = frame;
    [self setFrame:self.collapsedFrame];
}

- (CGRect)lowerFrame:(CGRect)frame withTag:(NSInteger)tag
{
    CGFloat height = CGRectGetHeight(self.expandedFrame);
    frame.origin.y += height;
    if (tag == 70) frame.size.height -= height;
    return frame;
}

- (CGRect)raiseFrame:(CGRect)frame withTag:(NSInteger)tag {
    CGFloat height = CGRectGetHeight(self.expandedFrame);
    frame.origin.y -= height;
    if (tag == 70) frame.size.height += height;
    return frame;
}

- (void) toggle {
    if (CGRectEqualToRect(self.frame, self.collapsedFrame))
        [self expand];
    else
        [self collapse];
}

- (void) collapse
{
    if (CGRectEqualToRect(self.frame, self.collapsedFrame)) return;
    [UIView animateWithDuration:0.5 animations:^{
        for (UIView* view in self.superview.subviews) {
            if (CGRectGetMinY(view.frame) > CGRectGetMaxY(self.frame))
                view.frame = [self raiseFrame:view.frame withTag: view.tag];
        }
        
        for (UIView* view in self.subviews) {
            [view setHidden:YES];
        }
        [self setFrame:self.collapsedFrame];
    }];
    
}

- (void) expand {
    if (CGRectEqualToRect(self.frame, self.expandedFrame)) return;
    [UIView animateWithDuration:0.5 animations:^{
        for (UIView* view in self.superview.subviews) {
            if (CGRectGetMinY(view.frame) > CGRectGetMaxY(self.frame))
                view.frame = [self lowerFrame:view.frame withTag: view.tag];
        }
        [self setFrame:self.expandedFrame];
    } completion:^(BOOL finished){
        for (UIView* view in self.subviews) {
            [view setHidden:NO];
        }
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
