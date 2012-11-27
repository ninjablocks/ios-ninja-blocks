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
    self = [super initWithAddress:(NBDeviceAddress){kVendorNinjaBlocks, kNBNorthHeading, port}
                     initialValue:@"0"
            ];
    if (self)
    {
        pollInterval = kPollingSensorIntervalHeading;
    }
    return self;
}

@end
