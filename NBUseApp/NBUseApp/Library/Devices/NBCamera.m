//
//  NBCamera.m
//  nbTest
//
//  Created by jz on 26/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBCamera.h"

#import "NBDeviceIds.h"
#import "NBCommand.h"

#import "NBCameraInterface.h"

@interface NBCamera ()

@property (assign, nonatomic) NBCameraInterface *deviceHWInterface;

@end

@implementation NBCamera

- (id) init
{
    return [self initWithPort:@"0"];
}

- (id) initWithPort:(NSString *)port
{
    return [super initWithAddress:(NBDeviceAddress){kVendorNinjaBlocks, kNBDIDWebcam, port}
                     initialValue:@"0"
            ];
}

- (NSString*)pollValue
{
    return @"0";
}

- (NSString*)deviceName
{
    return @"Camera";
}

- (void) commandValue:(NSString *)value
{
    if ([value isEqualToString:@"1"])
    {
        [self.deviceHWInterface getSnapshot];
    }
}

@end
