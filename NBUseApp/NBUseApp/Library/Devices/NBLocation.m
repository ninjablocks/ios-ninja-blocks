//
//  NBLocation.m
//  NBUseApp
//
//  Created by jz on 29/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBLocation.h"

#import "NBDeviceIds.h"
#import "NBPollingSensorIntervals.h"

@implementation NBLocation

- (id) init
{
    return [self initWithPort:@"0"];
}

- (id) initWithPort:(NSString *)port
{
    self = [super initWithAddress:(NBDeviceAddress){kVendorNinjaBlocks, kNBDIDLocation, port}
                     initialValue:@"0"
            ];
    if (self)
    {
        pollInterval = kPollingSensorIntervalLocation;
    }
    return self;
}

- (NSString*)deviceName
{
    return @"Location";
}

@end
