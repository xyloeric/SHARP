//
//  DLSlidingBackgroundView.h
//  MediSenseFrontMac
//
//  Created by Zhe Li on 12/27/11.
//  Copyright 2011 Dr.Lulu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol DLSlidingBackgroundViewDelegate

@optional
- (void)handleMouseDown:(NSEvent *)theEvent;
- (void)handleMouseDragged:(NSEvent *)theEvent;
- (void)handleMouseMoved:(NSEvent *)theEvent;
- (void)handleMouseUp:(NSEvent *)theEvent;
- (void)handleScrollWheel:(NSEvent *)theEvent;
- (void)handleSwipe:(NSEvent *)theEvent;
- (void)relayoutViews;
@end

@interface DLSlidingBackgroundView : NSView
{
    NSPoint lastDragLocation;
    __unsafe_unretained id<DLSlidingBackgroundViewDelegate> delegate;
}

@property (assign, nonatomic) id<DLSlidingBackgroundViewDelegate> delegate;

- (id)initWithDelegate:(id<DLSlidingBackgroundViewDelegate>)_delegate;

@end


