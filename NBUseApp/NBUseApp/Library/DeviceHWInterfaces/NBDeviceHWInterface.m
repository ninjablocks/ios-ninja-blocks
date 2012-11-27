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

// NB. must be called by any subclass implementation
- (void) setRequestingAction:(bool)requestingAction
{
    if (_requestingAction != requestingAction)
    {
        if (requestingAction)
        {
            for (NBDevice *device in self.devices)
            {
                if ([device isKindOfClass:[NBPollingSensor class]])
                {
                    [(NBPollingSensor*)device startPolling];
                }
            }
        }
        else
        {
            for (NBDevice *device in self.devices)
            {
                if ([device isKindOfClass:[NBPollingSensor class]])
                {
                    [(NBPollingSensor*)device stopPolling];
                }
            }
        }
        _requestingAction = requestingAction;
    }
}

- (bool) updateReading:(NBPollingSensor*)sensorDevice
{
    return false;
}


@end
