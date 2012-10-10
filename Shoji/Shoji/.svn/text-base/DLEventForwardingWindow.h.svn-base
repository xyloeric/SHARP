//
//  DLEventForwardingWindow.h
//  MediSenseFrontMac
//
//  Created by Zhe Li on 1/1/12.
//  Copyright 2012 Dr.Lulu. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    kScrollVertical,
    kScrollHorizontal,
    kScrollNone
};

@interface DLEventForwardingWindow : UIWindow
{
    __weak UIView *horizontalScrollForwardView;
    NSInteger currentDirection;
}

@property (weak) UIView *horizontalScrollForwardView;


- (void)manipulateScrollWheelEventToForward:(UIEvent *)theEvent;

@end
