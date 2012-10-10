//
//  DLEventForwardingWindow.m
//  MediSenseFrontMac
//
//  Created by Zhe Li on 1/1/12.
//  Copyright 2012 Dr.Lulu. All rights reserved.
//

#import "DLEventForwardingWindow.h"

@implementation DLEventForwardingWindow
@synthesize horizontalScrollForwardView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        currentDirection = kScrollNone;

    }
    
    return self;
}

- (void)awakeFromNib
{
    currentDirection = kScrollNone;
}

- (void)sendEvent:(UIEvent *)theEvent
{
    if (theEvent.type == UIEventTypeTouches) {
        if (horizontalScrollForwardView) {
            [self manipulateScrollWheelEventToForward:theEvent];
        }
    }
    else {
        [super sendEvent:theEvent];
    }
}

- (void)manipulateScrollWheelEventToForward:(UIEvent *)theEvent
{
    @autoreleasepool {
        
        
        NSSet *touches = [theEvent allTouches];
        
        if ([touches count] == 1) {
            NSMutableSet *began = nil;
            NSMutableSet *moved = nil;
            NSMutableSet *ended = nil;
            NSMutableSet *cancelled = nil;
            
            UITouch *touch = [[touches allObjects] lastObject];
            
            CGPoint currentLoc = [touch locationInView:horizontalScrollForwardView];
            CGPoint previousLoc = [touch previousLocationInView:horizontalScrollForwardView];
            
            if (abs(currentLoc.x-previousLoc.x) > abs(currentLoc.y-previousLoc.y)) {
                if (currentDirection == kScrollNone) {
                    currentDirection = kScrollHorizontal;
                }
            }
            else if (abs(currentLoc.x-previousLoc.x) < abs(currentLoc.y-previousLoc.y))
            {
                if (currentDirection == kScrollNone) {
                    currentDirection = kScrollVertical;
                }
            }
            
            if (currentDirection == kScrollHorizontal) {
                switch ([touch phase]) {
                    case UITouchPhaseBegan:
                        if (!began) began = [NSMutableSet set];
                        [began addObject:touch];
                        break;
                    case UITouchPhaseMoved:
                        if (!moved) moved = [NSMutableSet set];
                        [moved addObject:touch];
                        break;
                    case UITouchPhaseEnded:
                        if (!ended) ended = [NSMutableSet set];
                        [ended addObject:touch];
                        currentDirection = kScrollNone;
                        break;
                    case UITouchPhaseCancelled:
                        if (!cancelled) cancelled = [NSMutableSet set];
                        [cancelled addObject:touch];
                        currentDirection = kScrollNone;
                        break;
                    default:
                        break;
                }
                
                if (began)     [horizontalScrollForwardView touchesBegan:began withEvent:theEvent];
                if (moved)     [horizontalScrollForwardView touchesMoved:moved withEvent:theEvent];
                if (ended)     [horizontalScrollForwardView touchesEnded:ended withEvent:theEvent];
                if (cancelled) [horizontalScrollForwardView touchesCancelled:cancelled withEvent:theEvent];
                
                return;
            }
            else if (currentDirection == kScrollVertical)
            {
                [super sendEvent:theEvent];

                switch ([touch phase]) {
                    case UITouchPhaseEnded:
                        currentDirection = kScrollNone;
                        break;
                    case UITouchPhaseCancelled:
                        currentDirection = kScrollNone;
                        break;
                    default:
                        break;
                }
                
            }
            else if (currentDirection == kScrollNone)
            {
                [super sendEvent:theEvent];
            }
            
            
        }
    }
}

@end
