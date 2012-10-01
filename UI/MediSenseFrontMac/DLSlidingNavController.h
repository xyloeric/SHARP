//
//  DLSlidingNavController.h
//  MediSenseFrontMac
//
//  Created by Zhe Li on 12/26/11.
//  Copyright 2011 Dr.Lulu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "DLSlidingBackgroundView.h"

@class DLSlidingChildView;
@class MSTableViewController;

@interface DLSlidingNavController : NSViewController <DLSlidingBackgroundViewDelegate> 
{
    DLSlidingBackgroundView *backgroundView;
    NSPoint lastDragLocation;
    CGFloat dragOffset;
    
    NSMutableArray *onscreenViews;
    NSMutableArray *offscreenViews;
    DLSlidingChildView *frontView;
    
    MSTableViewController *tableViewController;
    
    CFMutableDictionaryRef viewControllers;
}

@property (strong) DLSlidingBackgroundView *backgroundView;
@property (strong) NSMutableArray *onscreenViews, *offscreenViews;
@property (strong) DLSlidingChildView *frontView;

- (id)initWithFrame:(NSRect)_frame;
- (void)_addNewView;

- (NSPoint)leftDockingPoint;
- (NSPoint)middleDockingPoint;
- (NSPoint)rightDockingPoint;

- (void)redockViews;
- (void)shiftViewsLeft;
- (void)shiftViewsRight;
- (void)moveViewWithOffset:(CGFloat)offset;

- (void)pushView:(NSView *)_view;
- (void)pushViewController:(NSViewController *)_viewController fromParent:(NSViewController *)sender;
- (void)popOffscreenViews;
- (void)popAllViews;

@end
