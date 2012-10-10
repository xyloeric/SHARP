//
//  DLSlidingBackgroundView.m
//  MediSenseFrontMac
//
//  Created by Zhe Li on 12/27/11.
//  Copyright 2011 Dr.Lulu. All rights reserved.
//

#import "DLShojiBackgroundView.h"
#import <QuartzCore/QuartzCore.h>
#import "DLShojiTableView.h"


@implementation DLShojiBackgroundView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithDelegate:(id<DLShojiBackgroundViewDelegate>)_delegate
{
    self = [super init];
    if (self) {
        self.delegate = _delegate;
        
        CGColorRef backgroundColor = [[UIColor grayColor] CGColor];
        self.layer.backgroundColor = backgroundColor;
        CGColorRelease(backgroundColor);
        
        //[self initializeGestureRecognizers];
    }
    
    return self;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //originCache = self.frame.origin;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        if (abs(translation.x) > abs(translation.y)) {
            
//            DLShojiBackgroundView *background = (DLShojiBackgroundView *)self.superview;
            //DLShojiNavController *navController = (DLShojiNavController *)background.delegate;
            [delegate moveViewWithTranslation:translation.x];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateFailed)
    {
        //DLShojiNavController *navController = [self navController];
        [delegate determinAndShiftViews];
    }
}

- (void)initializeGestureRecognizers
{
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGestureRecognizer.delegate = self;
    //[panGestureRecognizer setCancelsTouchesInView:NO];
    [panGestureRecognizer setMinimumNumberOfTouches:1];
    [self addGestureRecognizer:panGestureRecognizer];
}

- (void)drawRect:(CGRect)dirtyRect
{

}


//- (void)resizeWithOldSuperviewSize:(CGSize)oldSize
//{
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.superview.frame.size.width, self.superview.frame.size.height - 10);
//    [delegate relayoutViews];
//}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if ([touches count] == 1) {
//        NSArray *touchesArray = [touches allObjects];
//        UITouch *touch = [touchesArray lastObject];
//        
//        CGPoint currentLoc = [touch locationInView:self];
//        CGPoint previousLoc = [touch previousLocationInView:self];
//        CGFloat xOffset = currentLoc.x - previousLoc.x;
//        
//        if (abs(xOffset) > abs(currentLoc.y - previousLoc.y)) {
//            [delegate moveViewWithOffset:xOffset];
//        }
//    }
//    
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [delegate determinAndShiftViews];
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//}


@end
