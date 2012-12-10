//
//  NBDeviceManager.h
//  nbTest
//
//  Created by jz on 23/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NBNetworkHandler.h"
#import "NBNetworkCommandHandler.h"
#import "NBDevice.h"


typedef NSArray NBDeviceHWInterfaceArray;
typedef NSDictionary NBDeviceDictionary;

@class NBDeviceManager;
@protocol NBDeviceManagerDelegate <NSObject>

- (void) didReceiveAuthenticationError:(NBDeviceManager*)deviceManager;

@end

@protocol NBDeviceManagerDataDelegate <NSObject>

- (void) didSendData;
- (void) didReceiveData;

- (void) didReceiveCommand;

@end

@class NBNetworkHandler;

@class NBConnectionData;
@class NBDeviceHWInterface;

@class NBSettings;
@interface NBDeviceManager : NSObject <NBDeviceProtocol, NBNetworkCommandHandlerDelegate, NBNetworkDelegate>

+ (id) sharedManager;
+ (id) sharedManagerWithConnectionData:(NBConnectionData*)connectionData;

- (void) willEnterForeground;

- (void) addDeviceHWInterface:(NBDeviceHWInterface*)interface;

- (void) activateInterfaces;

//TODO: remove. Testing only
- (void) triggerCameraData;
- (void) ledData;

- (void) saveSettings;

@property (strong, nonatomic) NBNetworkHandler *networkHandler;

@property (strong, nonatomic) NBDeviceHWInterfaceArray *interfaces;
@property (strong, nonatomic) NBDeviceDictionary *devices;

@property (assign, nonatomic) id<NBDeviceManagerDelegate> delegate;
@property (assign, nonatomic) id<NBDeviceManagerDataDelegate> dataDelegate;

@property (strong, nonatomic) NBSettings *settings;

@end
