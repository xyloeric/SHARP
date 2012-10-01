//
//  MediSenseFrontMacAppDelegate.m
//  MediSenseFrontMac
//
//  Created by Zhe Li on 12/25/11.
//  Copyright 2011 Dr.Lulu. All rights reserved.
//

#import "MediSenseFrontMacAppDelegate.h"

@implementation MediSenseFrontMacAppDelegate

@synthesize window = _window;
@synthesize contentBox = _contentBox;
@synthesize testButton = _testButton;
@synthesize slidingNavController;
@synthesize csmlCoordinator = _csmlCoordinator;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.window setMovableByWindowBackground:YES];
    [self initializeSlidingNavController];
}

-(void)initializeSlidingNavController
{
    self.slidingNavController = [[DLSlidingNavController alloc] initWithFrame:self.contentBox.bounds];
    slidingNavController.view.autoresizingMask = NSViewWidthSizable | NSViewMaxXMargin | NSViewHeightSizable | NSViewMaxYMargin;
    [self.contentBox addSubview:slidingNavController.view];
    
    self.csmlCoordinator.navController = self.slidingNavController;
}

-(IBAction)addView:(id)sender
{
    [slidingNavController _addNewView];
}

@end
