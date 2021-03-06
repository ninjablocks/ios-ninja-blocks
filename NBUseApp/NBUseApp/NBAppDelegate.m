//
//  NBAppDelegate.m
//  NBUseApp
//
//  Created by jz on 15/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBAppDelegate.h"

#import "InitialisationViewController.h"
#import "NBDeviceManager.h"

#import "NBViewController.h"


@implementation NBAppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    [self showInitialisationViewControllerAutoLogin:true];
    return YES;
}

- (void) showInitialisationViewControllerAutoLogin:(bool)autoLogin
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.initViewController = [[[InitialisationViewController alloc] initWithNibName:@"InitialisationViewController" bundle:nil] autorelease];
    } else {
        self.initViewController = [[[InitialisationViewController alloc] initWithNibName:@"InitialisationViewController" bundle:nil] autorelease];
    }
    
    self.initViewController.delegate = self;
    [self.initViewController setAutoLogin:autoLogin];
    
    self.window.rootViewController = self.initViewController;
    [self.window makeKeyAndVisible];
}

- (void) didFinishInitialisationWithData:(NBConnectionData*)connectionData
{
    NBDeviceManager *deviceManager = [NBDeviceManager sharedManager];
    [deviceManager setupWithConnectionData:connectionData];
    [deviceManager setDelegate:self];
    NBViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController = [[[NBViewController alloc] initWithNibName:@"NBViewController_iPhone" bundle:nil] autorelease];
    } else {
        viewController = [[[NBViewController alloc] initWithNibName:@"NBViewController_iPad" bundle:nil] autorelease];
    }
    
    [deviceManager activateInterfaces];
    
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.window.rootViewController = self.navigationController;
    //    [self.window makeKeyAndVisible];
    
}

- (void) didLogout:(NBDeviceManager*)deviceManager
{
    [deviceManager reset];
    [self showInitialisationViewControllerAutoLogin:false];
}

- (void) didReceiveAuthenticationError:(NBDeviceManager*)deviceManager
{
    UIAlertView *authAlert = [[[UIAlertView alloc] initWithTitle:@"Authentication Failure"
                                                         message:@"Please login again."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil
                               ] autorelease];
    [authAlert show];
    [self.initViewController clearUserData];
    [self showInitialisationViewControllerAutoLogin:false];
}

- (void) didReceiveAlreadyAuthenticatedError:(NBDeviceManager *)deviceManager
{
    UIAlertView *authAlert = [[[UIAlertView alloc] initWithTitle:@"Already Registered"
                                                        message:@"Please unpair device from \n\
                                                                the dashboard, and try again"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil
                              ] autorelease];
    [authAlert show];
    [self showInitialisationViewControllerAutoLogin:false];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NBDeviceManager sharedManager] willEnterForeground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
 {
 }
 */

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
 {
 }
 */

@end
