//
//  NBHeading.m
//  NBUseApp
//
//  Created by jz on 27/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBHeading.h"

#import "NBDeviceIds.h"
#import "NBPollingSensorIntervals.h"

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
        pollInterval = kPollingSensorIntervalHeading;
    }
    return self;
}

- (bool) isChangeSignificantWithValue:(NSString*)value
{
    //TODO: compare currentValue to value, and return if greater than threshold
    return false;
}

- (NSString*)deviceName
{
    return @"Heading";
}

@end
