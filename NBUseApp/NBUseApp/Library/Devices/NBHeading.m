//
//  NBHeading.m
//  NBUseApp
//
//  Created by jz on 27/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBHeading.h"

#import "NBDeviceIds.h"

@implementation NBHeading

- (id) init
{
    return [self initWithPort:@"0"];
}

- (id) initWithPort:(NSString *)port
{
    self = [super initWithAddress:(NBDeviceAddress){kVendorNinjaBlocks, kNBDIDNorthHeading, port}
                     initialValue:@"0"
            ];
    if (self)
    {
    }
    return self;
}

#define kSignificantDeltaHeading    10.

- (void) setCurrentDirection:(CLLocationDirection)currentDirection
{
    bool isSignificant = (ABS(currentDirection - _currentDirection) > kSignificantDeltaHeading);
    _currentDirection = currentDirection;
    [self setCurrentValue:[NSString stringWithFormat:@"%f", currentDirection] isSignificant:isSignificant];
}



- (NSString*)deviceName
{
    return @"Heading";
}

@end
