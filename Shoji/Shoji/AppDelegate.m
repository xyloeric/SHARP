//
//  AppDelegate.m
//  Shoji
//
//  Created by Zhe Li on 3/1/12.
//  Copyright (c) 2012 Dr.Lulu. All rights reserved.
//

#import "AppDelegate.h"
#import "DLShojiNavController.h"
#import "DLEventForwardingWindow.h"
#import "DLShojiTableViewController.h"

@interface AppDelegate (hidden) 

-(void)initializeSlidingNavController;

@end

@implementation AppDelegate


@synthesize window = _window;
@synthesize slidingNavController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:0];

    [self initializeSlidingNavController];
    
    return YES;
}

-(void)initializeSlidingNavController
{
    self.slidingNavController = [[DLShojiNavController alloc] initWithNibName:@"DLShojiNavController" bundle:nil];
    //((DLEventForwardingWindow *)self.window).horizontalScrollForwardView = slidingNavController.backgroundView;
   // self.slidingNavController.view.frame = self.window.frame;
//    slidingNavController.wantsFullScreenLayout = YES;
    
//    slidingNavController.view.autoresizingMask = NSViewWidthSizable | NSViewMaxXMargin | NSViewHeightSizable | NSViewMaxYMargin;
    [self.window addSubview:slidingNavController.view];
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
