//
//  NBAccelerometer.m
//  nbTest
//
//  Created by jz on 19/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBAccelerometerState.h"

#import "NBDeviceIds.h"

@implementation NBAccelerometerState

- (id) init
{
    return [self initWithPort:@"0"];
}

- (id) initWithPort:(NSString *)port
{
    return [super initWithAddress:(NBDeviceAddress){kVendorNinjaBlocks, kNBAccelerometerState, port}
                     initialValue:@"0"
            ];
}

@end
