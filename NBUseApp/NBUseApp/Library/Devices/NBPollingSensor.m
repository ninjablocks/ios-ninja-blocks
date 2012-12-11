//
//  NBPollingSensor.m
//  NBUseApp
//
//  Created by jz on 27/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDefinitions.h"
#import "NBPollingSensor.h"

#import "NBDeviceHWInterface.h"

@interface NBPollingSensor ()
{
}

@end

@implementation NBPollingSensor

- (NSString*)deviceName
{
    return @"Unnamed Sensor";
}

- (void) resetValue
{
    [self.deviceHWInterface updateReading:self];
}

- (void) setCurrentValue:(NSString *)currentValue
{
    [_currentValue release];
    _currentValue = [currentValue retain];
    NBLog(kNBLogReadings, @"Set %@   (%@)", NSStringFromClass([self class]), self.currentValue);
}


@end
