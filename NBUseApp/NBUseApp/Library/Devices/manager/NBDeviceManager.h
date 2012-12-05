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


@class NBNetworkHandler;

@class NBConnectionData;
@class NBDeviceHWInterface;
@interface NBDeviceManager : NSObject <NBDeviceProtocol, NBNetworkCommandHandlerDelegate, NBNetworkDelegate>

+ (id) sharedManager;
+ (id) sharedManagerWithConnectionData:(NBConnectionData*)connectionData;

- (void) willEnterForeground;

- (void) addDeviceHWInterface:(NBDeviceHWInterface*)interface;

- (void) activateInterfaces;

//TODO: remove. Testing only
- (void) triggerCameraData;
- (void) ledData;


@property (strong, nonatomic) NBNetworkHandler *networkHandler;

@property (strong, nonatomic) NBDeviceHWInterfaceArray *interfaces;
@property (strong, nonatomic) NBDeviceDictionary *devices;

@property (assign, nonatomic) id<NBDeviceManagerDelegate> delegate;

@end
