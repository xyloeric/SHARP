//
//  DLEventForwardingWindow.h
//  MediSenseFrontMac
//
//  Created by Zhe Li on 1/1/12.
//  Copyright 2012 Dr.Lulu. All rights reserved.
//

#import <AppKit/AppKit.h>

enum {
    kScrollVertical,
    kScrollHorizontal,
    kScrollNone
};

@interface DLEventForwardingWindow : NSWindow
{
    NSView *horizontalScrollForwardView;
    NSInteger currentDirection;
}

@property (strong) NSView *horizontalScrollForwardView;


- (void)manipulateScrollWheelEventToForward:(NSEvent *)theEvent;

@end
