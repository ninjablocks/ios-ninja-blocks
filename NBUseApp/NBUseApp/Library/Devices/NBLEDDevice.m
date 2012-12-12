//
//  NBLEDDevice.m
//  NBUseApp
//
//  Created by jz on 28/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBLEDDevice.h"

#import "NBDeviceIds.h"
#import "NBCommand.h"

#import "NBCameraInterface.h"



@interface NBLEDDevice ()

@property (assign, nonatomic) NBCameraInterface *deviceHWInterface;

@end

@implementation NBLEDDevice

- (id) initWithPort:(NSString *)port
{
    return [super initWithAddress:(NBDeviceAddress){kVendorNinjaBlocks, kNBDIDLEDUser, port}
                     initialValue:@"0"
            ];
}

- (NSString*)deviceName
{
    return @"LED";
}

- (void) commandValue:(NSString *)value
{
    NSString *ledValue = kLEDColourOff;
    if ([value isEqualToString:kLEDColourOff])
    {
        [self.deviceHWInterface setCameraLEDToggle:false];
    }
    else
    {
        if ([self.deviceHWInterface setCameraLEDToggle:true])
        {
            ledValue = kLEDColourWhite;
        }
    }
    [self setCurrentValue:ledValue isSignificant:true];
}

@end
