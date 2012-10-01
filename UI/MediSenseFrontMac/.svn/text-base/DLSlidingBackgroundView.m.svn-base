//
//  DLSlidingBackgroundView.m
//  MediSenseFrontMac
//
//  Created by Zhe Li on 12/27/11.
//  Copyright 2011 Dr.Lulu. All rights reserved.
//

#import "DLSlidingBackgroundView.h"
#import <QuartzCore/QuartzCore.h>
#import "DLSlidingChildView.h"


@implementation DLSlidingBackgroundView
@synthesize delegate;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithDelegate:(id<DLSlidingBackgroundViewDelegate>)_delegate
{
    self = [super init];
    if (self) {
        self.delegate = _delegate;
        
        self.wantsLayer = YES;
        self.layer = [CALayer layer];
        
        CGColorRef backgroundColor = CGColorCreateGenericGray(0.5, 1);
        self.layer.backgroundColor = backgroundColor;
        CGColorRelease(backgroundColor);
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{

}

- (void)mouseDown:(NSEvent *)theEvent
{
    [delegate handleMouseDown:theEvent];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    [delegate handleMouseDragged:theEvent];
    
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    [delegate handleMouseMoved:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    [delegate handleMouseUp:theEvent];
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    [delegate handleScrollWheel:theEvent];
}

- (void)swipeWithEvent:(NSEvent *)event
{
    [delegate handleSwipe:event];
}

- (void)resizeWithOldSuperviewSize:(NSSize)oldSize
{
    [self setFrameSize:NSMakeSize([self.superview frame].size.width - 10, [self.superview frame].size.height - 10)];
    [delegate relayoutViews];
}


@end
