//
//  DLSlidingBackgroundView.h
//  MediSenseFrontMac
//
//  Created by Zhe Li on 12/27/11.
//  Copyright 2011 Dr.Lulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DLShojiBackgroundViewDelegate

@optional
- (void)moveViewWithOffset:(CGFloat)offset;
- (void)determinAndShiftViews;
- (void)relayoutViews;
- (void)moveViewWithTranslation:(CGFloat)translation;
- (void)determinAndShiftViews;
@end

@interface DLShojiBackgroundView : UIView <UIGestureRecognizerDelegate>
{
    CGPoint lastDragLocation;
    __weak id<DLShojiBackgroundViewDelegate> delegate;
}

@property (weak, nonatomic) id<DLShojiBackgroundViewDelegate> delegate;

- (id)initWithDelegate:(id<DLShojiBackgroundViewDelegate>)_delegate;
- (void)initializeGestureRecognizers;
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer;
@end


