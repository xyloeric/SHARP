//
//  DLSlidingChildView.h
//  MediSenseFrontMac
//
//  Created by Zhe Li on 12/26/11.
//  Copyright 2011 Dr.Lulu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  DLShojiNavController;

enum {
    kDockAtLeft = 0,
    kDockAtRight
};

@interface DLShojiTableView : UITableView <UIGestureRecognizerDelegate>
{
    __weak DLShojiNavController *navController;
    
    CGPoint lastDragLocation;
    
    CGPoint originCache;
    
    UIViewController *viewController;

}

@property (strong, nonatomic) UIViewController *viewController;
@property (weak, nonatomic) DLShojiNavController *navController;


- (id)initWithNavController:(DLShojiNavController *)_navController;
- (void)initializeGestureRecognizers;

- (void)moveForXOffset:(CGFloat)_xOffset;
- (void)moveForTranslation:(CGFloat)_translation;

- (void)redockToPoint:(CGPoint)_point;

@end
