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
    [_currentValue release];
    _currentValue = [currentValue retain];
    NBLog(kNBLogReadings, @"Set %@(%@)", NSStringFromClass([self class]), self.currentValue);
    [self.deviceDelegate triggerSendOfDeviceData:self];
}

- (void) processCommand:(NBCommand*)command
{
    //implement in sub class
    NBLog(kNBLogCommands, @"processing of commands not implemented");
}

- (NSString *) description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"DeviceData: %d\n", (int)self];
    [description appendFormat:@"\tvendorId: %d\n", self.address.vendorId];
    [description appendFormat:@"\tdeviceId: %d\n", self.address.deviceId];
    [description appendFormat:@"\tport: %@\n", self.address.port];
    
    [description appendFormat:@"\n\tvalue: %@\n", self.currentValue];
    return description;
}


@end
