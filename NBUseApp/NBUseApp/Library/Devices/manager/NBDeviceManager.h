//
//  NBDeviceManager.h
//  nbTest
//
//  Created by jz on 23/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NBNetworkCommandHandler.h"
#import "NBDevice.h"


typedef NSArray NBDeviceHWInterfaceArray;
typedef NSDictionary NBDeviceDictionary;

@protocol NBDeviceManagerDelegate <NSObject>


@end


@class NBNetworkHandler;

@class NBConnectionData;
@class NBDeviceHWInterface;
@interface NBDeviceManager : NSObject <NBDeviceProtocol, NBNetworkCommandHandlerDelegate>

- (id) initWithConnectionData:(NBConnectionData*)connectionData;
- (void) addDeviceHWInterface:(NBDeviceHWInterface*)interface;

//TODO: remove. Testing only
- (void) triggerCameraData;
- (void) ledData;

@property (strong, nonatomic) NBNetworkHandler *networkHandler;

@property (strong, nonatomic) NBDeviceHWInterfaceArray *interfaces;
@property (strong, nonatomic) NBDeviceDictionary *devices;

@end
