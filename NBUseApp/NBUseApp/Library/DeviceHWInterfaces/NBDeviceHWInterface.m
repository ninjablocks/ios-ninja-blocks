//
//  NBDeviceHWInterface.m
//  nbTest
//
//  Created by jz on 23/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDeviceHWInterface.h"
#import "NBDeviceHWInterfaceSubclass.h"

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
    [_devices release];
    [super dealloc];
}

@end
