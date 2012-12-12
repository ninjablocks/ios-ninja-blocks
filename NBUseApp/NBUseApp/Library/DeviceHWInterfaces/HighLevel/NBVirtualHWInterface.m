//
//  NBVirtualHWInterface.m
//  NBUseApp
//
//  Created by jz on 12/12/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDefinitions.h"

#import "NBVirtualHWInterface.h"
#import "NBDeviceHWInterfaceSubclass.h"

#import "NBLEDDevice.h"

@implementation NBVirtualHWInterface

- (void) addDevices
{
    NBLEDDevice *leftEye = [[[NBLEDDevice alloc] init] autorelease];
    [leftEye setDeviceHWInterface:self];
    NBLEDDevice *rightEye = [[[NBLEDDevice alloc] init] autorelease];
    [rightEye setDeviceHWInterface:self];
    [_devices addObject:leftEye];
    [_devices addObject:rightEye];
}

- (void) updateDeviceAvailabilityFromHardware
{
    [self updateDevicesOfClass:[NBLEDDevice class] withAvailability:true];
}

@end
