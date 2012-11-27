//
//  NBDevice+DeviceHWInterfaceFunctions.m
//  nbTest
//
//  Created by jz on 26/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDevice+DeviceHWInterfaceFunctions.h"

@implementation NBDevice (DeviceHWInterfaceFunctions)

@dynamic currentValue;
- (void) setCurrentValue:(NSString *)currentValue
{
    [_currentValue release];
    _currentValue = [currentValue retain];
    [self.deviceDelegate didUpdateNBDevice:self];
}

@end
