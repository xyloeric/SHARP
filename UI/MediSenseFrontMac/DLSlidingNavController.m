//
//  DLSlidingNavController.m
//  MediSenseFrontMac
//
//  Created by Zhe Li on 12/26/11.
//  Copyright 2011 Dr.Lulu. All rights reserved.
//

#import "DLSlidingNavController.h"
#import "DLSlidingChildView.h"
#import "DLSlidingBackgroundView.h"
#import "MSTableViewController.h"
#import "MediSenseFrontMacAppDelegate.h"

@implementation DLSlidingNavController
@synthesize backgroundView;
@synthesize onscreenViews, offscreenViews;
@synthesize frontView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithFrame:(NSRect)_frame;
{
    self = [super init];
    if (self) {
        self.view = [[NSView alloc] initWithFrame:_frame];
        self.backgroundView = [[DLSlidingBackgroundView alloc] initWithDelegate:self];
        backgroundView.frame = NSMakeRect(self.view.bounds.origin.x + 5, self.view.bounds.origin.y + 5, self.view.bounds.size.width - 10, self.view.bounds.size.height - 10); 
        backgroundView.autoresizingMask = NSViewWidthSizable | NSViewMaxXMargin | NSViewHeightSizable | NSViewMaxYMargin;
        [self.view addSubview:backgroundView];
        
        MediSenseFrontMacAppDelegate *appDelegate = (MediSenseFrontMacAppDelegate *)[[NSApplication sharedApplication] delegate];
        appDelegate.window.horizontalScrollForwardView = backgroundView;
        
        self.onscreenViews = [[NSMutableArray alloc] init];
        self.offscreenViews = [[NSMutableArray alloc] init];
        
        tableViewController = [[MSTableViewController alloc] initWithNibName:@"MSTableViewController" bundle:[NSBundle mainBundle]];
        tableViewController = [[MSTableViewController alloc] initWithEntities:nil];
        tableViewController.view.frame = NSMakeRect(0, 0, backgroundView.frame.size.width*0.25, backgroundView.frame.size.height);
        tableViewController.view.autoresizingMask = NSViewWidthSizable | NSViewMaxXMargin | NSViewHeightSizable | NSViewMaxYMargin;
        [backgroundView addSubview:tableViewController.view];
        
        viewControllers = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
        
    }
    
    return self;
}

- (void)dealloc
{
    CFRelease(viewControllers);
}

- (NSPoint)leftDockingPoint
{
    return NSMakePoint(0.125*self.backgroundView.frame.size.width, 0.0);
}

- (NSPoint)middleDockingPoint
{
    if ([onscreenViews count] == 1) {
        return NSMakePoint(self.backgroundView.frame.size.width*(1-0.4375)*0.5, 0.0);
    }
    return NSMakePoint(0.5625*self.backgroundView.frame.size.width, 0.0);
}

- (NSPoint)rightDockingPoint
{
    return NSMakePoint(self.backgroundView.frame.size.width, 0.0);
    
}

- (void)handleMouseDown:(NSEvent *)theEvent
{
    dragOffset = 0;
    lastDragLocation = [theEvent locationInWindow];
}

- (void)handleMouseDragged:(NSEvent *)theEvent
{
    NSPoint newDragLocation = [theEvent locationInWindow];
	CGFloat _offset = 0.5*(-lastDragLocation.x + newDragLocation.x);
    lastDragLocation = newDragLocation;
    
    [self moveViewWithOffset:_offset];
    
}

- (void)handleMouseMoved:(NSEvent *)theEvent
{
    
}

- (void)handleMouseUp:(NSEvent *)theEvent
{
    if (dragOffset >= self.backgroundView.frame.size.width*0.4375*0.25) {
        [self shiftViewsRight];
    }
    else if (dragOffset <= -self.backgroundView.frame.size.width*0.4375*0.25) {
        [self shiftViewsLeft];
    }
    [self redockViews];
    dragOffset = 0;
}

- (void)handleSwipe:(NSEvent *)theEvent
{
    if (theEvent.deltaX < 0) {
        [self shiftViewsRight];
    }
    else {
        [self shiftViewsLeft];
    }
    [self redockViews];
}

- (void)handleScrollWheel:(NSEvent *)theEvent
{
    @autoreleasepool {
        
        
        if (theEvent.phase == NSEventPhaseBegan) {
            dragOffset = 0;
        }
        
        else if (theEvent.phase == NSEventPhaseChanged) {
            CGFloat scrollWheelOffset = 0.3 * theEvent.scrollingDeltaX;
            [self moveViewWithOffset:scrollWheelOffset];
        }
        else if (theEvent.phase == NSEventPhaseCancelled || theEvent.phase == NSEventPhaseEnded || theEvent.momentumPhase == NSEventPhaseEnded){
            if (dragOffset >= self.backgroundView.frame.size.width*0.4375*0.2) {
                [self shiftViewsRight];
            }
            else if (dragOffset <= -self.backgroundView.frame.size.width*0.4375*0.2) {
                [self shiftViewsLeft];
            }
            [self redockViews];
            dragOffset = 0;
        }
    }
}

- (void)redockViews
{
    [onscreenViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DLSlidingChildView *_oView = (DLSlidingChildView *)obj;
        if (idx == [onscreenViews count] - 1) {
            [_oView redockToPoint:[self middleDockingPoint]];
        }
        else {
            [_oView redockToPoint:[self leftDockingPoint]];
        }
    }];
    
    [offscreenViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DLSlidingChildView *_fView = (DLSlidingChildView *)obj;
        [_fView redockToPoint:[self rightDockingPoint]];
    }];
}

- (void)shiftViewsRight
{
    if ([onscreenViews count] > 2) {
        DLSlidingChildView *lastView = [onscreenViews lastObject];
        [offscreenViews addObject:lastView];
        [onscreenViews removeLastObject];
    }
}

- (void)shiftViewsLeft
{
    if ([offscreenViews count] > 0) {
        DLSlidingChildView *lastView = [offscreenViews lastObject];
        [onscreenViews addObject:lastView];
        [offscreenViews removeLastObject];
    }
}

- (void)moveViewWithOffset:(CGFloat)_offset
{
    dragOffset += _offset;
    
    
    DLSlidingChildView *_oView1 = [onscreenViews lastObject];
    [_oView1 moveForXOffset:_offset];
    
    if (dragOffset > 0) {
        int32_t pass = (int32_t)(dragOffset/(self.view.frame.size.width*0.4375));
        [onscreenViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            DLSlidingChildView *_oView = (DLSlidingChildView *)obj;
            if ((int32_t)idx >= (int32_t)[onscreenViews count]-2-pass && idx != [onscreenViews count] - 1) {
                [_oView moveForXOffset:_offset];
            }
        }];
    }
    else {
        int32_t pass = -(int32_t)(dragOffset/(self.view.frame.size.width*0.4375));
        
        [offscreenViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            DLSlidingChildView *_fView = (DLSlidingChildView *)obj;
            if ((int32_t)idx >= (int32_t)[offscreenViews count]-1-pass ) {
                [_fView moveForXOffset:_offset];
            }
        }];
    }
}

- (void)relayoutViews
{
    [onscreenViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DLSlidingChildView *_oView = (DLSlidingChildView *)obj;
        if (idx == [onscreenViews count] - 1) {
            [_oView setFrame:NSMakeRect([self middleDockingPoint].x, [self middleDockingPoint].y, self.backgroundView.frame.size.width*0.4375, self.backgroundView.frame.size.height)];
        }
        else {
            [_oView setFrame:NSMakeRect([self leftDockingPoint].x, [self leftDockingPoint].y, self.backgroundView.frame.size.width*0.4375, self.backgroundView.frame.size.height)];
        }
    }];
    
    [offscreenViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DLSlidingChildView *_fView = (DLSlidingChildView *)obj;
        [_fView setFrame:NSMakeRect([self rightDockingPoint].x, [self rightDockingPoint].y, self.backgroundView.frame.size.width*0.4375, self.backgroundView.frame.size.height)];
    }];
    
    //[self redockViews];
}

- (void)_addNewView
{
    DLSlidingChildView *newSubview = [[DLSlidingChildView alloc] initWithFrame:NSMakeRect(self.view.frame.size.width, 0, self.view.frame.size.width*0.4375, self.view.frame.size.height)];
    
    
    //DLSlidingChildView *lastSubview = [self.backgroundView.subviews lastObject];
    [offscreenViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSView *view = (NSView *)obj;
        [view removeFromSuperview];
    }];
    [offscreenViews removeAllObjects];
    
    [self.backgroundView addSubview:newSubview];
    [onscreenViews addObject:newSubview];
    [self redockViews];
}

- (void)pushView:(NSView *)_view
{
    DLSlidingChildView *newSubview = [[DLSlidingChildView alloc] initWithFrame:NSMakeRect(self.view.frame.size.width, 0, self.view.frame.size.width*0.4375, self.view.frame.size.height)];
    
    _view.frame = newSubview.bounds;
    _view.autoresizingMask = NSViewWidthSizable | NSViewMaxXMargin | NSViewHeightSizable | NSViewMaxYMargin;
    [newSubview addSubview:_view];
    
    [self popOffscreenViews];
    
    [self.backgroundView addSubview:newSubview];
    [onscreenViews addObject:newSubview];
    [self redockViews];
    
}

- (void)pushViewController:(NSViewController *)_viewController fromParent:(NSViewController *)sender
{
    @autoreleasepool {
        
        DLSlidingChildView *newSubview = [[DLSlidingChildView alloc] initWithFrame:NSMakeRect(self.backgroundView.frame.size.width, 0, self.backgroundView.frame.size.width*0.4375, self.backgroundView.frame.size.height)];
        
        newSubview.viewController = _viewController;
        
        
        CFDictionarySetValue(viewControllers, (__bridge const void *)_viewController, (__bridge const void *)newSubview);
        DLSlidingChildView *parentContainer = (__bridge DLSlidingChildView *)CFDictionaryGetValue(viewControllers, (__bridge const void *)sender);
        if (parentContainer) {
            //children view
            if ([onscreenViews indexOfObject:parentContainer] == [onscreenViews count] - 1) {
                [self popOffscreenViews];
            }
            else if([onscreenViews indexOfObject:parentContainer] == [onscreenViews count] - 2) {
                [self popOffscreenViews];
                NSView *lastView = [onscreenViews lastObject];
                [lastView removeFromSuperview];
                [onscreenViews removeLastObject];
                lastView = nil;
            }
        }
        else {
            //root view
            
        }
        
        
        [self.backgroundView addSubview:newSubview];
        [onscreenViews addObject:newSubview];
        [self redockViews];
        
        //    double delayInSeconds = 2.0;
        //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //        _viewController.view.frame = newSubview.bounds;
        //        _viewController.view.autoresizingMask = NSViewWidthSizable | NSViewMaxXMargin | NSViewHeightSizable | NSViewMaxYMargin;
        //        [newSubview addSubview:_viewController.view];
        //});
        
        
        //CFDictionarySetValue(viewControllers, (__bridge const void *)newSubview, (__bridge const void *)_viewController);
        
        [self popOffscreenViews];
    }
}

- (void)popOffscreenViews
{
    [offscreenViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DLSlidingChildView *view = (DLSlidingChildView *)obj;
        [view removeFromSuperview];
        CFDictionaryRemoveValue(viewControllers, (__bridge const void*)view.viewController);
        view = nil;
        
    }];
    [offscreenViews removeAllObjects];
}

- (void)popAllViews
{
    [self popOffscreenViews];
    
    [onscreenViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DLSlidingChildView *view = (DLSlidingChildView *)obj;
        [view removeFromSuperview];
        CFDictionaryRemoveValue(viewControllers, (__bridge const void*)view.viewController);
        view = nil;
    }];
    [onscreenViews removeAllObjects];
    
}



@end
