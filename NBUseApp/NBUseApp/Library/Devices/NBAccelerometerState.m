//
//  NBAccelerometer.m
//  nbTest
//
//  Created by jz on 19/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBAccelerometerState.h"

#import "NBDeviceIds.h"
#import "NBAccelerometerInterface.h"

@interface NBAccelerometerState ()

@property (assign, nonatomic) NBAccelerometerInterface *deviceHWInterface;

@end

@implementation NBAccelerometerState

- (id) init
{
    return [self initWithPort:@"0"];
}

- (id) initWithPort:(NSString *)port
{
    return [super initWithAddress:(NBDeviceAddress){kVendorNinjaBlocks, kNBDIDAccelerometerState, port}
                     initialValue:@"0"
            ];
}

- (bool) isChangeSignificantWithValue:(NSString*)value
{
    return true; //any change considered significant
}

- (NSString*)deviceName
{
    return @"Jiggle";
}

@end
