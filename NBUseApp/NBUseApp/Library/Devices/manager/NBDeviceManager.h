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

- (void) didLogout:(NBDeviceManager*)deviceManager;
- (void) didReceiveAuthenticationError:(NBDeviceManager*)deviceManager;

@end

@protocol NBDeviceManagerDataDelegate <NSObject>

- (void) didSendData;
- (void) didReceiveData;

- (void) didReceiveCommand;

@end

@protocol NBDeviceManagerMessageDelegate <NSObject>

- (void) didSendDevice:(NBDevice*)device;
- (void) didSendDeviceArray:(NSArray*)devices;

- (void) didReceiveCommand:(NSString*)command;

@end

@class NBNetworkHandler;

@class NBConnectionData;
@class NBDeviceHWInterface;

@class NBSettings;
@interface NBDeviceManager : NSObject <NBDeviceProtocol, NBNetworkCommandHandlerDelegate, NBNetworkDelegate>

+ (id) sharedManager;

- (void) setupWithConnectionData:(NBConnectionData*)connectionData;
- (void) reset;

- (void) willEnterForeground;

- (void) addDeviceHWInterface:(NBDeviceHWInterface*)interface;

- (void) activateInterfaces;

//TODO: remove. Testing only
- (void) triggerCameraData;
- (void) ledData;

- (void) saveSettings;
- (void) logout;


@property (strong, nonatomic) NBNetworkHandler *networkHandler;

@property (strong, nonatomic) NBDeviceHWInterfaceArray *interfaces;
@property (strong, nonatomic) NBDeviceDictionary *devices;

@property (assign, nonatomic) id<NBDeviceManagerDelegate> delegate;
@property (assign, nonatomic) id<NBDeviceManagerDataDelegate> dataDelegate;
@property (assign, nonatomic) id<NBDeviceManagerMessageDelegate> messageDelegate;

@property (strong, nonatomic) NBSettings *settings;

@end
