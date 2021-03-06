//
//  NBAppDelegate.h
//  NBUseApp
//
//  Created by jz on 15/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InitialisationViewController.h"
#import "NBDeviceManager.h"

@interface NBAppDelegate : UIResponder <UIApplicationDelegate, InitialisationDelegate, NBDeviceManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) InitialisationViewController *initViewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end