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

- (void) setCurrentValue:(NSString *)currentValue
{
    bool significantChange = [self isChangeSignificantWithValue:currentValue];
    [_currentValue release];
    _currentValue = [currentValue retain];
    NBLog(kNBLogReadings, @"Set %@   (%@)", NSStringFromClass([self class]), self.currentValue);
    if (significantChange)
    {
        [self.deviceDelegate didChangeSignificantly:self];
    }
}

- (bool) isChangeSignificantWithValue:(NSString*)value
{
    return false;
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
    return description;
}


@end
