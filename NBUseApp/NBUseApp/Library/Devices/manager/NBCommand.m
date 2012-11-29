//
//  NBCommand.m
//  nbTest
//
//  Created by jz on 26/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBCommand.h"

@implementation NBCommand

- (id) initWithAddress:(NBDeviceAddress)address dataValue:(NSString *)dataValue
{
    self = [super init];
    if (self)
    {
        _address = address;
        _commandData = @{kCommandDataValueKey: dataValue};
    }
    return self;
}

- (NSString *) description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"Command: %d", (int)self];
    [description appendFormat:@"   vendorId: %d", self.address.vendorId];
    [description appendFormat:@"   deviceId: %d", self.address.deviceId];
    [description appendFormat:@"   port: %@", self.address.port];
    
    [description appendFormat:@"   value: %@", [self.commandData objectForKey:kCommandDataValueKey]];
    return description;
}


@end
