//
//  DLSlidingNavController.h
//  MediSenseFrontMac
//
//  Created by Zhe Li on 12/26/11.
//  Copyright 2011 Dr.Lulu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DLShojiBackgroundView.h"
#import "PatientSelectionTableViewController.h"

@class DLShojiTableView;


@interface DLShojiNavController : UIViewController <DLShojiBackgroundViewDelegate, PatientSelectionTableViewControllerDelegate, UIPopoverControllerDelegate> 
{
    IBOutlet DLShojiBackgroundView *backgroundView;
    CGPoint lastDragLocation;
    
    //the offset when drag stops
    CGFloat dragOffset;
    
    //the offset while dragging
    CGFloat previousTranlation;
    
    NSMutableArray *onscreenViewControllers;
    NSMutableArray *offscreenViewControllers;
            
    __weak UIBarButtonItem *patientButton;
    UIPopoverController *patientSelectionPopover;
    NSString *pId;
    
    UIViewController *focusViewController;
    
    int focusViewPositionStatus;
    int onscreenViewPositionStatus;
}

@property (nonatomic, strong) DLShojiBackgroundView *backgroundView;
@property (nonatomic, strong) NSMutableArray *onscreenViewControllers, *offscreenViewControllers;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *patientButton;
@property (nonatomic, strong) UIPopoverController *patientSelectionPopover;
@property (nonatomic, strong) NSString *pId;

@property (nonatomic, strong) UIViewController *focusViewController;

- (id)initWithFrame:(CGRect)_frame;

- (IBAction)selectPatient:(id)sender;

- (CGPoint)onscreenDockingPoint;
- (CGPoint)focusViewDockingPoint;
- (CGPoint)offscreenDockingPoint;

- (void)redockViews;
- (void)shiftViewsLeft;
- (void)shiftViewsRight;
- (IBAction)shiftLeftAndDock:(id)sender;
- (IBAction)shiftRightAndDock:(id)sender;
- (void)determinAndShiftViews;
- (void)moveViewWithOffset:(CGFloat)offset;
- (void)moveViewWithTranslation:(CGFloat)_translation;

- (void)pushView:(UIView *)_view;
- (void)pushViewController:(UIViewController *)_viewController fromParent:(UIViewController *)sender;
- (void)popOffscreenViews;
- (void)popAllViews;

//debug utility
- (IBAction)_removeAllViews:(id)sender;
- (IBAction)_addNewView:(id)sender;
@end
