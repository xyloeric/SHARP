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

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    currentDirection = kScrollNone;
}

- (void)sendEvent:(NSEvent *)theEvent
{
    if (theEvent.type == NSScrollWheel) {
        if (horizontalScrollForwardView) {
            [self manipulateScrollWheelEventToForward:theEvent];
        }
    }
    else {
        [super sendEvent:theEvent];
    }
}

- (void)manipulateScrollWheelEventToForward:(NSEvent *)theEvent
{
    switch (theEvent.phase) {
        case NSEventPhaseBegan:
        {
            if (abs(theEvent.scrollingDeltaY) < abs(theEvent.scrollingDeltaX))
            {
                currentDirection = kScrollHorizontal;
            }
            else {
                currentDirection = kScrollVertical;
            }
        }
            break;
        case NSEventPhaseEnded:
        {
            if (currentDirection == kScrollHorizontal) {
                [horizontalScrollForwardView scrollWheel:theEvent];                
            }
            else if (currentDirection == kScrollVertical) {
                [super sendEvent:theEvent];
            }
            currentDirection = kScrollNone;
        }
            break;
        default:
        {
            if (currentDirection == kScrollHorizontal) {
                [horizontalScrollForwardView scrollWheel:theEvent];                
            }
            else if (currentDirection == kScrollVertical) {
                [super sendEvent:theEvent];
            }
        }
            break;
    }
}

@end
