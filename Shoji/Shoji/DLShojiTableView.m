//
//  DLSlidingChildView.m
//  MediSenseFrontMac
//
//  Created by Zhe Li on 12/26/11.
//  Copyright 2011 Dr.Lulu. All rights reserved.
//

#import "DLShojiTableView.h"
#import <QuartzCore/QuartzCore.h>
#import "DLShojiNavController.h"

@implementation DLShojiTableView
@synthesize navController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        //CGColorRef backgroundColor = [[UIColor lightGrayColor] CGColor];
        //self.layer.backgroundColor = backgroundColor;
        //CGColorRelease(backgroundColor);
        
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8; // if you like rounded corners
        self.layer.shadowOffset = CGSizeMake(-3, 3);
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.5;
        
       
    }
    
    return self;
}

- (id)initWithNavController:(DLShojiNavController *)_navController
{
    self = [super initWithFrame:CGRectMake(_navController.backgroundView.frame.size.width, 0, _navController.backgroundView.frame.size.width*0.4375, _navController.backgroundView.frame.size.height)];
    if (self) {
        self.navController = _navController;
        
        //CGColorRef backgroundColor = [[UIColor lightGrayColor] CGColor];
        //self.layer.backgroundColor = backgroundColor;
        //CGColorRelease(backgroundColor);
        
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8; // if you like rounded corners
        self.layer.shadowOffset = CGSizeMake(-3, 3);
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.5;
        
        [self initializeGestureRecognizers];
        
    }
    
    return self;
}

- (void)initializeGestureRecognizers
{
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGestureRecognizer.delegate = self;
    //[panGestureRecognizer setCancelsTouchesInView:NO];
    [panGestureRecognizer setMinimumNumberOfTouches:1];
    [self addGestureRecognizer:panGestureRecognizer];
}

- (void)setViewController:(UIViewController *)_viewController
{
    viewController = _viewController;
//    if ([_viewController respondsToSelector:@selector(setContainerView:)]) {
//        MSTableViewController *tvc = (MSTableViewController *)_viewController;
//        [tvc setContainerView:self];
//    }
//    
//    
//    viewController = _viewController;
//    viewController.view.frame = self.bounds;
//    viewController.view.autoresizingMask = NSViewWidthSizable | NSViewMaxXMargin | NSViewHeightSizable | NSViewMaxYMargin;
//    double delayInSeconds = 0.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self addSubview:viewController.view];
//    });
//    
}

- (UIViewController *)viewController
{
    return viewController;
}

//- (void)drawRect:(CGRect)dirtyRect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    
//    [context setCompositingOperation:NSCompositePlusDarker];
//    
//    NSBezierPath *path = [NSBezierPath
//                          bezierPathWithRoundedRect:[self bounds]
//                          xRadius:2.0f
//                          yRadius:2.0f];
//    
//    [[NSColor whiteColor] setStroke];
//    
//    NSShadow * shadow = [[NSShadow alloc] init];
//    [shadow setShadowColor:[NSColor greenColor]];
//    [shadow setShadowBlurRadius:30.0f];
//    [shadow set];
//    
//    [path stroke];
//    
//    [context restoreGraphicsState];
//}

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

- (void)redockToPoint:(CGPoint)_point
{

    if (_point.x != self.frame.origin.x) {
        CGRect firstViewFrame = [self frame];
        CGRect newViewFrame = CGRectMake(_point.x, _point.y, firstViewFrame.size.width, firstViewFrame.size.height);
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = newViewFrame;
        } completion:^(BOOL finished) {
            
        }];
        
        
//        NSMutableDictionary* firstViewDict;
//        
//        {
//            // Create the attributes dictionary for the first view.
//            firstViewDict = [NSMutableDictionary dictionaryWithCapacity:3];
//            firstViewFrame = [self frame];
//            
//            // Specify which view to modify.
//            [firstViewDict setObject:self forKey:NSViewAnimationTargetKey];
//            
//            // Specify the starting position of the view.
//            [firstViewDict setObject:[NSValue valueWithRect:firstViewFrame]
//                              forKey:NSViewAnimationStartFrameKey];
//            
//            // Change the ending position of the view.
//            newViewFrame = firstViewFrame;
//            newViewFrame.origin = _point;
//            [firstViewDict setObject:[NSValue valueWithRect:newViewFrame]
//                              forKey:NSViewAnimationEndFrameKey];
//        }
//        
//        theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:firstViewDict, nil]];
//        self.redockingAnimation = theAnim;
//        // Set some additional attributes for the animation.
//        [redockingAnimation setDuration:0.3];    // One and a half seconds.
//        [redockingAnimation setAnimationCurve:NSAnimationEaseInOut];
//        
//        // Run the animation.
//        [redockingAnimation startAnimation];
    }
    
    //originCache = _point;
}

- (void)moveForXOffset:(CGFloat)_xOffset
{
//    if (redockingAnimation) {
//        [redockingAnimation stopAnimation];
//    }
    CGPoint thisOrigin = [self frame].origin;
	thisOrigin.x += _xOffset;
    self.frame = CGRectMake(thisOrigin.x, thisOrigin.y, self.frame.size.width, self.frame.size.height);
    
}

- (void)moveForTranslation:(CGFloat)_translation
{
    CGPoint thisOrigin = originCache;
    thisOrigin.x += _translation;
    self.frame = CGRectMake(thisOrigin.x, thisOrigin.y, self.frame.size.width, self.frame.size.height);

}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //originCache = self.frame.origin;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        if (abs(translation.x) > abs(translation.y)) {
            [navController moveViewWithTranslation:translation.x];
        }
        else
        {
            recognizer.enabled = NO;
            recognizer.enabled = YES;
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateFailed)
    {
        [navController determinAndShiftViews];
    }
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    originCache = self.frame.origin;
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
//        if (xOffset > abs(currentLoc.y - previousLoc.y)) {
//            [navController moveViewWithOffset:xOffset];
//        }
//    }
//    
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [navController determinAndShiftViews];
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//}

@end
