//
//  UIView+DLShojiSupport.h
//  Shoji
//
//  Created by Zhe Li on 3/3/12.
//  Copyright 2012 Dr.Lulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  DLShojiNavController;
@interface UIView (UIView_DLShojiSupport) <UIGestureRecognizerDelegate>

- (id)initWithShojiSupport:(CGRect)frame;

- (void)shojiSupport;
- (void)addShadow;
- (void)removeShadow;
- (void)initializeGestureRecognizers;
- (void)moveForXOffset:(CGFloat)_xOffset;
- (void)redockToPoint:(CGPoint)_point;
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer;
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer;
- (DLShojiNavController *)navController;
@end
