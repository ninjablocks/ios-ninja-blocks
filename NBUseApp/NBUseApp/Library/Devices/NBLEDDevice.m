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

#define kLEDColourOff   @"000000"
#define kLEDColourWhite @"FFFFFF"


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

- (void) processCommand:(NBCommand *)command
{
    NSString *dataValue = [command.commandData objectForKey:kCommandDataValueKey];
    if ([dataValue isKindOfClass:[NSString class]])
    {
        NSString *ledValue = kLEDColourOff;
        if ([dataValue isEqualToString:kLEDColourOff])
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
        [self setCurrentValue:ledValue];
    }
}

@end
