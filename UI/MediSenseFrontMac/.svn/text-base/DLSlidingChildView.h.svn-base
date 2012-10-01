//
//  DLSlidingChildView.h
//  MediSenseFrontMac
//
//  Created by Zhe Li on 12/26/11.
//  Copyright 2011 Dr.Lulu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class  MSTableViewController;

enum {
    kDockAtLeft = 0,
    kDockAtRight
};

@interface DLSlidingChildView : NSView
{
    NSPoint lastDragLocation;
    NSAnimation *redockingAnimation;
    
    NSViewController *viewController;

}

@property (strong) NSAnimation *redockingAnimation;
@property (strong) NSViewController *viewController;
- (void)moveForXOffset:(CGFloat)_xOffset;
- (void)redockToPoint:(NSPoint)_point;

@end
