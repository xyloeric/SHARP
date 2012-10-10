//
//  AppDelegate.h
//  Shoji
//
//  Created by Zhe Li on 3/1/12.
//  Copyright (c) 2012 Dr.Lulu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLShojiNavController;
@class DLEventForwardingWindow;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    DLShojiNavController *slidingNavController;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DLShojiNavController *slidingNavController;


@end
