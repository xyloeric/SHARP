//
//  UIView+DLShojiSupport.m
//  Shoji
//
//  Created by Zhe Li on 3/3/12.
//  Copyright 2012 Dr.Lulu. All rights reserved.
//

#import "UIView+DLShojiSupport.h"
#import "DLShojiBackgroundView.h"
#import "DLShojiNavController.h"

@implementation UIView (UIView_DLShojiSupport)

- (id)initWithShojiSupport:(CGRect)frame
{
    self = [self initWithFrame:frame];
    if (self) {
//        CGColorRef backgroundColor = [[UIColor lightGrayColor] CGColor];
//        self.layer.backgroundColor = backgroundColor;
        //CGColorRelease(backgroundColor);
        
//        self.layer.masksToBounds = NO;
//        self.layer.cornerRadius = 8; // if you like rounded corners
//        //self.layer.shadowOffset = CGSizeMake(-3, 3);
//        self.layer.shadowRadius = 8;
//        self.layer.shadowOpacity = 0.5;
        
        //[self initializeGestureRecognizers];
    }
    
    return self;
}

- (void)shojiSupport
{
//    CGColorRef backgroundColor = [[UIColor lightGrayColor] CGColor];
//    self.layer.backgroundColor = backgroundColor;
    
    self.layer.masksToBounds = NO;
    self.layer.shadowRadius = 8;
    self.layer.shadowOpacity = 0.5;

    [self initializeGestureRecognizers];
}

- (void)addShadow
{
    self.layer.shadowRadius = 8;
    self.layer.shadowOpacity = 0.5;

}

- (void)removeShadow
{
    self.layer.shadowRadius = 0;
    self.layer.shadowOpacity = 0;
}

- (void)initializeGestureRecognizers
{
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGestureRecognizer.delegate = self;
    //[panGestureRecognizer setCancelsTouchesInView:NO];
    [panGestureRecognizer setMinimumNumberOfTouches:2];
    [self addGestureRecognizer:panGestureRecognizer];
    
}

- (void)moveForXOffset:(CGFloat)_xOffset
{
    CGPoint onscreenPilePoint = [[self navController] onscreenDockingPoint];
    
    CGPoint thisOrigin = [self frame].origin;
    if (thisOrigin.x + _xOffset >= onscreenPilePoint.x) {
        thisOrigin.x += _xOffset;
        self.frame = CGRectMake(thisOrigin.x, thisOrigin.y, self.frame.size.width, self.frame.size.height);
    }
}

- (void)redockToPoint:(CGPoint)_point
{
    if (_point.x != self.frame.origin.x) {
        CGRect firstViewFrame = [self frame];
        CGRect newViewFrame1 = CGRectMake(_point.x, _point.y, firstViewFrame.size.width, firstViewFrame.size.height);

        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = newViewFrame1;
        } completion:^(BOOL finished) {
         
        }];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //originCache = self.frame.origin;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        if (abs(translation.x) > abs(translation.y)) {
            
            DLShojiBackgroundView *background = (DLShojiBackgroundView *)self.superview;
            DLShojiNavController *navController = (DLShojiNavController *)background.delegate;
            [navController moveViewWithTranslation:translation.x];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateFailed)
    {
        DLShojiNavController *navController = [self navController];
        [navController determinAndShiftViews];
    }
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer
{
    UITableView *tableView = (UITableView *)self;
    
    UITableViewCell *newCell;
    for (UITableViewCell* aCell in tableView.visibleCells) {
        if ([aCell pointInside:[recognizer locationInView:aCell] withEvent:nil]) {
            newCell = aCell;
            break;
        }
    }

    if (newCell) {
        NSLog(@"%f", recognizer.scale);
        CGFloat degree = 0;
        
        if (recognizer.scale >= 1.0f && recognizer.scale <= 2.0f) {
            
            degree = M_PI*recognizer.scale - M_PI;
            
//            newCell.layer.transform = CATransform3DMakeRotation(degree,1.0,0.0,0.0);
            newCell.transform = CGAffineTransformMakeScale(recognizer.scale, recognizer.scale);
        }
        
        //    else if (recognizer.scale >= 0.0f && recognizer.scale < 1.0f) {
        //        
        //        degree = M_PI*recognizer.scale - M_PI;
        //        
        //        self.layer.transform = CATransform3DMakeRotation(degree,1.0,0.0,0.0);
        //    }
        
        if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateFailed)
        {
            if (degree > M_PI/2) {
                [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    newCell.layer.transform = CATransform3DMakeRotation(M_PI,1.0,0.0,0.0);
                } completion:^(BOOL finished) {
                    
                }];
            }
            else {
                [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    newCell.layer.transform = CATransform3DMakeRotation(0,1.0,0.0,0.0);
                } completion:^(BOOL finished) {
                    
                }];
            }
        }

    }
        
}

- (DLShojiNavController *)navController
{
    DLShojiBackgroundView *background = (DLShojiBackgroundView *)self.superview;
    DLShojiNavController *navController = (DLShojiNavController *)background.delegate;
    return navController;
}

@end
