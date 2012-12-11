//
//  NBGestureDevice.m
//  NBUseApp
//
//  Created by jz on 7/12/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBGestureDevice.h"

#import "NBDeviceIds.h"

@implementation NBGestureDevice


- (id) init
{
    return [self initWithPort:@"0"];
}

- (id) initWithPort:(NSString *)port
{
    return [super initWithAddress:(NBDeviceAddress){kVendorNinjaBlocks, kNBDIDHIDDevice, port}
                     initialValue:@"0"
            ];
}

- (NSString*)pollValue
{
    return @"0";
}

- (NSString*)deviceName
{
    return @"Gestures";
}

@end
