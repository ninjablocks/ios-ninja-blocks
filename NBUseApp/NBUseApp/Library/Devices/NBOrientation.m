//
//  NBOrientation.m
//  nbTest
//
//  Created by jz on 27/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBOrientation.h"

#import "NBDeviceIds.h"
#import "NBPollingSensorIntervals.h"

@implementation NBOrientation

- (id) init
{
    return [self initWithPort:@"0"];
}

- (id) initWithPort:(NSString *)port
{
    self = [super initWithAddress:(NBDeviceAddress){kVendorNinjaBlocks, kNBDIDOrientation, port}
                     initialValue:@"0"
            ];
    if (self)
    {
        pollInterval = kPollingSensorIntervalOrientation;
    }
    return self;
}

@end
