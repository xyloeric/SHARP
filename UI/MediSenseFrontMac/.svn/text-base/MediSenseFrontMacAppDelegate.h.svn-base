//
//  MediSenseFrontMacAppDelegate.h
//  MediSenseFrontMac
//
//  Created by Zhe Li on 12/25/11.
//  Copyright 2011 Dr.Lulu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DLSlidingNavController.h"
#import "DLEventForwardingWindow.h"
#import "MSCSMLCoordinator.h"

@interface MediSenseFrontMacAppDelegate : NSObject <NSApplicationDelegate> {
    DLEventForwardingWindow *_window;
    NSBox *_contentBox;
    NSButton *_testButton;
    
    DLSlidingNavController *slidingNavController;
    MSCSMLCoordinator *_csmlCoordinator;
}

@property (strong) IBOutlet DLEventForwardingWindow *window;
@property (strong) IBOutlet NSBox *contentBox;
@property (strong) IBOutlet NSButton *testButton;
@property (strong) DLSlidingNavController *slidingNavController;
@property (strong) IBOutlet MSCSMLCoordinator *csmlCoordinator;

-(void)initializeSlidingNavController;

-(IBAction)addView:(id)sender;

@end
