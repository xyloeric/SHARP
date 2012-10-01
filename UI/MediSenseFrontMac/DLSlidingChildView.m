//
//  DLSlidingChildView.m
//  MediSenseFrontMac
//
//  Created by Zhe Li on 12/26/11.
//  Copyright 2011 Dr.Lulu. All rights reserved.
//

#import "DLSlidingChildView.h"
#import <QuartzCore/QuartzCore.h>
#import <WebKit/WebKit.h>
#import "MSTableViewController.h"

@implementation DLSlidingChildView
@synthesize redockingAnimation;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setWantsLayer:YES];
        self.layer = [CALayer layer];
        
        CGColorRef backgroundColor = CGColorCreateGenericGray(1.0, 1.0);
        self.layer.backgroundColor = backgroundColor;
        CGColorRelease(backgroundColor);
        
        NSShadow * _shadow = [[NSShadow alloc] init];
        [_shadow setShadowColor:[NSColor blackColor]];
        [_shadow setShadowBlurRadius:5.0f];
        self.shadow = _shadow;
        
//        WebView *webView = [[WebView alloc] initWithFrame:self.bounds];
//        webView.autoresizingMask = NSViewWidthSizable | NSViewMaxXMargin | NSViewHeightSizable | NSViewMaxYMargin;
//        [self addSubview:webView];
//        [[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]]];
        

       
    }
    
    return self;
}

- (void)setViewController:(NSViewController *)_viewController
{
    if ([_viewController respondsToSelector:@selector(setContainerView:)]) {
        MSTableViewController *tvc = (MSTableViewController *)_viewController;
        [tvc setContainerView:self];
    }
    
    
    viewController = _viewController;
    viewController.view.frame = self.bounds;
    viewController.view.autoresizingMask = NSViewWidthSizable | NSViewMaxXMargin | NSViewHeightSizable | NSViewMaxYMargin;
    double delayInSeconds = 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self addSubview:viewController.view];
    });
    
}

- (NSViewController *)viewController
{
    return viewController;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    [context saveGraphicsState];
    
    [context setCompositingOperation:NSCompositePlusDarker];
    
    NSBezierPath *path = [NSBezierPath
                          bezierPathWithRoundedRect:[self bounds]
                          xRadius:2.0f
                          yRadius:2.0f];
    
    [[NSColor whiteColor] setStroke];
    
    NSShadow * shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[NSColor greenColor]];
    [shadow setShadowBlurRadius:30.0f];
    [shadow set];
    
    [path stroke];
    
    [context restoreGraphicsState];
}

//- (void)mouseDown:(NSEvent *)theEvent
//{
////    lastDragLocation = [theEvent locationInWindow];
////    if (redockingAnimation) {
////        [redockingAnimation stopAnimation];
////    }
//}
//
//- (void)mouseDragged:(NSEvent *)theEvent
//{
////    NSPoint newDragLocation = [theEvent locationInWindow];
////	NSPoint thisOrigin = [self frame].origin;
////	thisOrigin.x += 0.5*(-lastDragLocation.x + newDragLocation.x);
////    //	thisOrigin.y += (-lastDragLocation.y + newDragLocation.y);
////	[self setFrameOrigin:thisOrigin];
////	lastDragLocation = newDragLocation;
//    
//}
//
//
//- (void)mouseMoved:(NSEvent *)theEvent
//{
//    
//}
//
//- (void)mouseUp:(NSEvent *)theEvent
//{
//    //    CABasicAnimation *redockAnimation = [CABasicAnimation animation];
//    //    [redockAnimation setFromValue:[NSValue valueWithPoint:lastDragLocation]];
//    //    [redockAnimation setToValue:[NSValue valueWithPoint:NSMakePoint(0.0, 0.0)]];
//    //    [self setAnimations:<#(NSDictionary *)#>
//    
////    [self redockToPoint:NSMakePoint(0.0, 0.0)];
//}

- (void)redockToPoint:(NSPoint)_point
{
    if(redockingAnimation)
    {
        [redockingAnimation stopAnimation];
    }
    
    if (_point.x != self.frame.origin.x) {
        NSViewAnimation *theAnim;
        NSRect firstViewFrame;
        NSRect newViewFrame;
        NSMutableDictionary* firstViewDict;
        
        {
            // Create the attributes dictionary for the first view.
            firstViewDict = [NSMutableDictionary dictionaryWithCapacity:3];
            firstViewFrame = [self frame];
            
            // Specify which view to modify.
            [firstViewDict setObject:self forKey:NSViewAnimationTargetKey];
            
            // Specify the starting position of the view.
            [firstViewDict setObject:[NSValue valueWithRect:firstViewFrame]
                              forKey:NSViewAnimationStartFrameKey];
            
            // Change the ending position of the view.
            newViewFrame = firstViewFrame;
            newViewFrame.origin = _point;
            [firstViewDict setObject:[NSValue valueWithRect:newViewFrame]
                              forKey:NSViewAnimationEndFrameKey];
        }
        
        theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:firstViewDict, nil]];
        self.redockingAnimation = theAnim;
        // Set some additional attributes for the animation.
        [redockingAnimation setDuration:0.3];    // One and a half seconds.
        [redockingAnimation setAnimationCurve:NSAnimationEaseInOut];
        
        // Run the animation.
        [redockingAnimation startAnimation];
    }
    
}

- (void)moveForXOffset:(CGFloat)_xOffset
{
    if (redockingAnimation) {
        [redockingAnimation stopAnimation];
    }
    NSPoint thisOrigin = [self frame].origin;
	thisOrigin.x += _xOffset;
    [self setFrameOrigin:thisOrigin];
    
}




@end
