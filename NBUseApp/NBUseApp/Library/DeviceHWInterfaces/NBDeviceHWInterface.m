//
//  NBDeviceHWInterface.m
//  nbTest
//
//  Created by jz on 23/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDeviceHWInterface.h"
#import "NBDeviceHWInterfaceSubclass.h"

#import "NBDevice.h"
#import "NBPollingSensor.h"

@implementation NBDeviceHWInterface

- (id) init
{
    self = [super init];
    if (self)
    {
        _devices = [[NSMutableArray alloc] init];
        [self addDevices];
    }
    return self;
}

- (void) dealloc
{
    for (NBDevice *device in _devices)
    {
        [device setDeviceHWInterface:nil];
    }
    [_devices release];
    [super dealloc];
}

- (void) performSelector:(SEL)selector forEachDeviceOfClass:(Class)class
{
    for (NBDevice *device in self.devices)
    {
        if ([device isKindOfClass:class])
        {
            [device performSelector:selector];
        }
    }
}

- (void) performSelector:(SEL)selector withObject:(id)object forEachDeviceOfClass:(Class)class
{
    for (NBDevice *device in self.devices)
    {
        if ([device isKindOfClass:class])
        {
            [device performSelector:selector withObject:object];
        }
    }
}


- (void) updateDevicesOfClass:(Class)deviceClass withAvailability:(bool)available
{
    for (NBDevice *device in self.devices)
    {
        if ([device isKindOfClass:deviceClass])
        {
            [device setAvailable:available];
        }
    }
}

- (void) updateDeviceAvailabilityFromHardware
{
    //implement in subclass
}

- (bool) updateReading:(NBPollingSensor*)sensorDevice
{
    return false;
}


@end
