//
//  NBDevice.m
//  nbTest
//
//  Created by jz on 19/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDefinitions.h"

#import "NBDevice.h"
#import "NBCommand.h"

@implementation NBDevice

- (id) init
{
    return nil;
}

- (id) initWithAddress:(NBDeviceAddress)address initialValue:(NSString*)initialValue
{
    self = [super init];
    if (self) {
        _address = address;
        _currentValue = [initialValue retain];
    }
    return self;
}

- (NSString*)deviceName
{
    return @"Unnamed Device";
}

+ (NSString *) addressKey:(NBDeviceAddress)address
{
    return [NSString stringWithFormat:@"%d_%d_%@", address.vendorId, address.deviceId, address.port];
}

- (NSString *) addressKey
{
    return [NBDevice addressKey:self.address];
}

- (NSString*) pollValue
{
    return self.currentValue;
}

- (void) setCurrentValue:(NSString *)currentValue
{
    [self setCurrentValue:currentValue isSignificant:false];
}
- (void) setCurrentValue:(NSString *)currentValue isSignificant:(bool)isSignficant
{
    [_currentValue release];
    _currentValue = [currentValue retain];
    if (isSignficant)
    {
        [self.deviceDelegate didChangeSignificantly:self];
    }
}


- (void) setActive:(bool)active
{
    _active = active;
    [self.deviceDelegate didChangeActiveStateForDevice:self];
}
- (void) setAvailable:(bool)available
{
    _available = available;
    [self.deviceDelegate didChangeAvailableForDevice:self];
}

- (void) processCommand:(NBCommand*)command
{
    //implement in sub class
    NBLog(kNBLogCommands, @"processing of commands not implemented");
}

- (NSString *) description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"DeviceData: %d", (int)self];
    [description appendFormat:@"   vendorId: %d", self.address.vendorId];
    [description appendFormat:@"   deviceId: %d", self.address.deviceId];
    [description appendFormat:@"   port: %@", self.address.port];
    
    [description appendFormat:@"   value: %@", self.currentValue];
    [description appendFormat:@"   %@ Available, %@ Active", (self.available?@"IS":@"NOT"), (self.active?@"IS":@"NOT")];
    [description appendFormat:@"   lastSend: %@", self.lastSend];
    return description;
}


@end
