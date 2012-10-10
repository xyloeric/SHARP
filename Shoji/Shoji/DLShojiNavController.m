//
//  DLSlidingNavController.m
//  MediSenseFrontMac
//
//  Created by Zhe Li on 12/26/11.
//  Copyright 2011 Dr.Lulu. All rights reserved.
//

#import "DLShojiNavController.h"
#import "DLShojiBackgroundView.h"
#import "DLShojiTableViewController.h"
#import "UIView+DLShojiSupport.h"
#import "TraceCoordinator.h"

#define RATIO 0.475

enum {
    kDockAtLeft = 0,
    kDockAtMiddle,
    kDockAtRight
};

@implementation DLShojiNavController
@synthesize backgroundView;
@synthesize onscreenViewControllers, offscreenViewControllers;
@synthesize patientButton;
@synthesize patientSelectionPopover;
@synthesize pId;

@synthesize focusViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.onscreenViewControllers = [[NSMutableArray alloc] init];
        self.offscreenViewControllers = [[NSMutableArray alloc] init];
        
                
        previousTranlation = 0;
        
        focusViewPositionStatus = kDockAtLeft;
        onscreenViewPositionStatus = kDockAtLeft;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)_frame;
{
    self = [super init];
    if (self) {
        self.view = [[UIView alloc] initWithFrame:_frame];
        
        
        self.backgroundView = [[DLShojiBackgroundView alloc] initWithDelegate:self];
        backgroundView.frame = CGRectMake(self.view.bounds.origin.x + 5, self.view.bounds.origin.y + 5, self.view.bounds.size.width - 10, self.view.bounds.size.height - 10); 
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        [self.view addSubview:backgroundView];
        
        self.onscreenViewControllers = [[NSMutableArray alloc] init];
        self.offscreenViewControllers = [[NSMutableArray alloc] init];
        
        focusViewPositionStatus = kDockAtLeft;
        onscreenViewPositionStatus = kDockAtLeft;
    }
    
    return self;
}

- (void)dealloc
{

}

- (void)viewDidLoad
{
    backgroundView.delegate = self;
    [backgroundView initializeGestureRecognizers];
}


- (void)viewDidLayoutSubviews{
    //NSLog(@"%f, %f, %f, %f", self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    [super viewDidLayoutSubviews];
    backgroundView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + 44, self.view.bounds.size.width, self.view.bounds.size.height - 44);
    [self relayoutViews];
    //backgroundView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 44, self.view.frame.size.width, self.view.frame.size.height - 44);
    
}

- (IBAction)selectPatient:(id)sender
{
    @autoreleasepool {
        if (patientSelectionPopover == nil) {
            PatientSelectionTableViewController *pstcv = [[PatientSelectionTableViewController alloc] initWithDelegate:self];
            pstcv.view.frame = CGRectMake(0, 0, 350.0, 250.0);
            self.patientSelectionPopover = [[UIPopoverController alloc] initWithContentViewController:pstcv];
            patientSelectionPopover.delegate = self;
            [patientSelectionPopover presentPopoverFromBarButtonItem:patientButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }
        else {
            [patientSelectionPopover dismissPopoverAnimated:YES];
            self.patientSelectionPopover = nil;
        }
        
    }
}

- (void)selectedPatient:(NSString *)_pid
{
    [self popAllViews];
    if (_pid != nil) {
        self.patientButton.title = _pid;
        self.pId = _pid;
        __autoreleasing DLShojiTableViewController *rootTvc = [[DLShojiTableViewController alloc] initWithTerm:@"HypothesisQuery" andPatientID:pId];
        [self pushViewController:rootTvc fromParent:nil];
    }
    
    if (patientSelectionPopover) {
        [patientSelectionPopover dismissPopoverAnimated:YES];
        self.patientSelectionPopover = nil;
    }
}

- (CGPoint)onscreenDockingPoint
{
    if (onscreenViewPositionStatus == kDockAtLeft) {
        return CGPointMake((1-2*RATIO)*self.backgroundView.frame.size.width, 0.0);
    }
    else {
        return CGPointMake(self.backgroundView.frame.size.width*(1-RATIO)*0.5, 0.0);    
    }
}

- (CGPoint)focusViewDockingPoint
{
    
    CGPoint currentOnscreenPilePoint = [self onscreenDockingPoint];

    if ([onscreenViewControllers count] == 0) {
        return CGPointMake(self.backgroundView.frame.size.width*(1-RATIO)*0.5, 0.0);
    }

    if (focusViewPositionStatus == kDockAtRight) {
        return CGPointMake(currentOnscreenPilePoint.x + self.backgroundView.frame.size.width*RATIO, 0.0);

    }
    else {
        return CGPointMake(currentOnscreenPilePoint.x + self.backgroundView.frame.size.width*(1-2*RATIO), 0.0);
    }
    

}

- (CGPoint)offscreenDockingPoint
{
    return CGPointMake(self.backgroundView.frame.size.width, 0.0);
}


- (void)redockViews
{    
    [onscreenViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *_oViewController = (UIViewController *)obj;
        UIView *_oView = _oViewController.view;
        [_oView redockToPoint:[self onscreenDockingPoint]];
    }];
    
    [offscreenViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *_fViewController = (UIViewController *)obj;
        UIView *_fView = _fViewController.view;        
        [_fView redockToPoint:[self offscreenDockingPoint]];
    }];
    
    [self.focusViewController.view redockToPoint:[self focusViewDockingPoint]];
}

- (void)determinAndShiftViews
{
    if (dragOffset >= self.backgroundView.frame.size.width*RATIO*0.2) {
        [self shiftViewsRight];
    }
    else if (dragOffset <= -self.backgroundView.frame.size.width*RATIO*0.2) {
        [self shiftViewsLeft];
    }
    [self redockViews];
    dragOffset = 0;
    previousTranlation = 0;
}

- (CGRect)convertToLargeViewRect:(CGRect)_input
{
    return CGRectMake(_input.origin.x, _input.origin.y, backgroundView.frame.size.width * RATIO * 1.9f, _input.size.height);
}

- (CGRect)convertToSmallViewRect:(CGRect)_input
{
    return CGRectMake(_input.origin.x, _input.origin.y, backgroundView.frame.size.width * RATIO, _input.size.height);

}

- (void)shiftViewsRight
{
    if (focusViewPositionStatus == kDockAtLeft) {
        focusViewPositionStatus = kDockAtRight;
        self.focusViewController.view.frame = [self convertToSmallViewRect:self.focusViewController.view.frame];
    }
    else {
        if ([onscreenViewControllers count] > 1) {
            UIViewController *lastViewController = [onscreenViewControllers lastObject];
            
            //lastViewController.view.frame = [self convertToLargeViewRect:lastViewController.view.frame];
            
            self.focusViewController.view.frame = [self convertToSmallViewRect:self.focusViewController.view.frame];
                                                             
            [offscreenViewControllers addObject:self.focusViewController];
            
            self.focusViewController = lastViewController;
            
            [onscreenViewControllers removeLastObject];
        }
        else if ([onscreenViewControllers count] == 1 && focusViewPositionStatus == kDockAtRight) {
            onscreenViewPositionStatus = kDockAtRight;
        }

    }
}

- (void)shiftViewsLeft
{
    if (onscreenViewPositionStatus == kDockAtRight) {
        onscreenViewPositionStatus = kDockAtLeft;
    }
    else {
        if (focusViewPositionStatus == kDockAtRight) {
            focusViewPositionStatus = kDockAtLeft;
            self.focusViewController.view.frame = [self convertToLargeViewRect:self.focusViewController.view.frame];
        }
        else {
            if ([offscreenViewControllers count] > 0) {
                UIViewController *lastViewController = [offscreenViewControllers lastObject];
                
                lastViewController.view.frame = [self convertToLargeViewRect:lastViewController.view.frame];
                
                self.focusViewController.view.frame = [self convertToSmallViewRect:self.focusViewController.view.frame];

                [onscreenViewControllers addObject:self.focusViewController];
                
                self.focusViewController = lastViewController;
                
                [offscreenViewControllers removeLastObject];
            }
        }

    }
}

- (IBAction)shiftLeftAndDock:(id)sender
{
    [self shiftViewsLeft];
    [self redockViews];
}

- (IBAction)shiftRightAndDock:(id)sender
{
    [self shiftViewsRight];
    [self redockViews];
}

- (void)moveViewWithOffset:(CGFloat)_offset
{
    dragOffset += _offset;
    
    [self.focusViewController.view moveForXOffset:_offset];
    
    if (dragOffset > 0) {    
        int32_t pass;
        if (focusViewPositionStatus == kDockAtRight) {
            pass = (int32_t)(dragOffset/(self.backgroundView.frame.size.width*RATIO));
        }
        else {
            pass = (int32_t)(dragOffset/(self.backgroundView.frame.size.width*RATIO))-1;
        }
        [onscreenViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIViewController *_oViewController = (UIViewController *)obj;
            UIView *_oView = (UIView *)_oViewController.view;  
            if ((int32_t)idx >= (int32_t)[onscreenViewControllers count]-1-pass && idx != [onscreenViewControllers count]) {
                [_oView moveForXOffset:_offset];
            }
        }];
    }
    else {
        int32_t pass;
        if (focusViewPositionStatus == kDockAtLeft) {
            pass = -(int32_t)(dragOffset/(self.backgroundView.frame.size.width*RATIO));
        }
        else {
            pass = -(int32_t)(dragOffset/(self.backgroundView.frame.size.width*RATIO)) - 1;
        }
        
        [offscreenViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIViewController *_fViewController = (UIViewController *)obj;
            UIView *_fView = (UIView *)_fViewController.view;        
            
            if ((int32_t)idx >= (int32_t)[offscreenViewControllers count]-1-pass ) {
                [_fView moveForXOffset:_offset];
            }
        }];
        
        if (onscreenViewPositionStatus == kDockAtRight) {
            UIViewController *_oViewController = [onscreenViewControllers lastObject];
            UIView *_oView = (UIView *)_oViewController.view;  
            [_oView moveForXOffset:_offset];
        }
    }
}

- (void)moveViewWithTranslation:(CGFloat)_translation
{
    //dragOffset = _translation;
    CGFloat moveOffset = _translation - previousTranlation;
    previousTranlation = _translation;
    //NSLog(@"%f, %f", _translation, moveOffset);
    
    [self moveViewWithOffset:moveOffset];
}

- (void)relayoutViews
{
    [self.focusViewController.view setFrame:CGRectMake([self focusViewDockingPoint].x, [self focusViewDockingPoint].y, self.backgroundView.frame.size.width*RATIO, self.backgroundView.frame.size.height)];
    
    [onscreenViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *_oViewController = (UIViewController *)obj;
        UIView *_oView = (UIView *)_oViewController.view;
        
//        if (idx == [onscreenViewControllers count] - 1) {
//            [_oView setFrame:CGRectMake([self focusViewDockingPoint].x, [self focusViewDockingPoint].y, self.backgroundView.frame.size.width*RATIO, self.backgroundView.frame.size.height)];
//        }
//        else {
            [_oView setFrame:CGRectMake([self onscreenDockingPoint].x, [self onscreenDockingPoint].y, self.backgroundView.frame.size.width*RATIO, self.backgroundView.frame.size.height)];
        //}
    }];
    
    [offscreenViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *_fViewController = (UIViewController *)obj;
        UIView *_fView = (UIView *)_fViewController.view; 
        
        [_fView setFrame:CGRectMake([self offscreenDockingPoint].x, [self offscreenDockingPoint].y, self.backgroundView.frame.size.width*RATIO, self.backgroundView.frame.size.height)];
    }];
    
    //[self redockViews];
}

- (IBAction)_addNewView:(id)sender
{
    //UIView *newSubview = [[UIView alloc] initWithFrame:CGRectMake(self.backgroundView.frame.size.width, 0, self.backgroundView.frame.size.width*RATIO, self.backgroundView.frame.size.height)];
    
    DLShojiTableViewController *newController = [[DLShojiTableViewController alloc] initWithTerm:@"HypothesisQuery" andPatientID:@"7440"];
    
    UIView *newView = newController.view;
    newView.frame = CGRectMake(self.backgroundView.frame.size.width, 0, self.backgroundView.frame.size.width*RATIO, self.backgroundView.frame.size.height);
    [newView shojiSupport];
    
    //DLShojiTableView *newSubview = [[DLShojiTableView alloc] initWithFrame:CGRectMake(self.backgroundView.frame.size.width, 0, self.backgroundView.frame.size.width*RATIO, self.backgroundView.frame.size.height)];
    
    //[newSubview shojiSupport];
    //DLSlidingChildView *lastSubview = [self.backgroundView.subviews lastObject];
    //[self popOffscreenViews];
    
//    [self.backgroundView addSubview:newView];
//    [onscreenViewControllers addObject:newController];
    [self pushViewController:newController fromParent:nil];
    [self redockViews];
    
    //DLShojiTableViewController *tbc = [[DLShojiTableViewController alloc] initWithTerm:@"HypothesisQuery" andPatientID:@"7440"];
}

- (void)pushView:(UIView *)_pushView
{
    UIViewController *newController = [[UIViewController alloc] init];
    UIView *newSubview = [[UIView alloc] initWithFrame:CGRectMake(self.backgroundView.frame.size.width, 0, self.backgroundView.frame.size.width*RATIO, self.backgroundView.frame.size.height)];
    newController.view = newSubview;
    
    //    _pushView.frame = newSubview.bounds;
    //    [newSubview addSubview:_pushView];
        
    [self.backgroundView addSubview:newController.view];
    [onscreenViewControllers addObject:newController];
    [self redockViews];
    
}

- (void)pushViewController:(UIViewController *)_viewController fromParent:(UIViewController *)sender
{
    @autoreleasepool {
        
        if (sender) {
            
            focusViewPositionStatus = kDockAtLeft;
            
            if (sender == focusViewController) {
                [self popOffscreenViews];
                sender.view.frame = [self convertToSmallViewRect:sender.view.frame];
                [onscreenViewControllers addObject:sender];
                self.focusViewController = nil;
            }
            //children view
//            if ([onscreenViewControllers indexOfObject:sender] == [onscreenViewControllers count] - 1) {
//                [self popOffscreenViews];
//            }//last view
            else if([onscreenViewControllers containsObject:sender]) {
                
                [self popOffscreenViews];
                [self.focusViewController.view removeFromSuperview];
                self.focusViewController = nil;
                
//                UIViewController *lastController = [onscreenViewControllers lastObject];
//                UIView *lastView = lastController.view;
//                [lastView removeFromSuperview];
//                [onscreenViewControllers removeLastObject];
            }//the one before last view
        }
        else {
            //root view
            [self popAllViews];
        }
        
        [_viewController.view shojiSupport];
        _viewController.view.frame = CGRectMake(self.backgroundView.frame.size.width, 0, 1.9f*self.backgroundView.frame.size.width*RATIO, self.backgroundView.frame.size.height);
                
        [self.backgroundView addSubview:_viewController.view];
        //[onscreenViewControllers addObject:_viewController];
        
        self.focusViewController = _viewController;
        [self redockViews];
                
        //    double delayInSeconds = 2.0;
        //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //        _viewController.view.frame = newSubview.bounds;
        //        _viewController.view.autoresizingMask = NSViewWidthSizable | NSViewMaxXMargin | NSViewHeightSizable | NSViewMaxYMargin;
        //        [newSubview addSubview:_viewController.view];
        //});
        
        
        //CFDictionarySetValue(viewControllers, (__bridge const void *)newSubview, (__bridge const void *)_viewController);
        
//        [self popOffscreenViews];
    }
}

- (void)popOffscreenViews
{
    [offscreenViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *viewController = (UIViewController *)obj;
        UIView *popView = viewController.view;
        [popView removeFromSuperview];        
    }];
    [offscreenViewControllers removeAllObjects];
}

- (void)popAllViews
{
    [self popOffscreenViews];
    
    [onscreenViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *viewController = (UIViewController *)obj;
        UIView *popView = viewController.view;        
        [popView removeFromSuperview];
        
    }];
    [onscreenViewControllers removeAllObjects];
    
    [self.focusViewController.view removeFromSuperview];
    self.focusViewController = nil;
    
}

- (IBAction)_removeAllViews:(id)sender
{
    [self popAllViews];
}

- (IBAction)_flipView:(id)sender
{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        focusViewController.view.layer.transform = CATransform3DMakeRotation(M_PI,1.0,0.0,0.0);

    } completion:^(BOOL finished) {
        
    }];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"will");
    [focusViewController.view removeShadow];
    [onscreenViewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        [vc.view removeShadow];
    }];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"did");
    [focusViewController.view addShadow];
    [onscreenViewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        [vc.view addShadow];
    }];
}

- (void)viewDidUnload {
    [self setPatientButton:nil];
    [super viewDidUnload];
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == patientSelectionPopover) {
        self.patientSelectionPopover = nil;
    }
}

@end
