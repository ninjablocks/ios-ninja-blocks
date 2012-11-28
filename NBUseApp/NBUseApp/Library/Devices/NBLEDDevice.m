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
    return [super initWithAddress:(NBDeviceAddress){kVendorNinjaBlocks, kNBLEDUser, port}
                     initialValue:@"0"
            ];
}

- (void) processCommand:(NBCommand *)command
{
    NSString *dataValue = [command.commandData objectForKey:kCommandDataValueKey];
    if ([dataValue isKindOfClass:[NSString class]])
    {
        if ([dataValue isEqualToString:@"000000"])
        {
            [self.deviceHWInterface setCameraLEDToggle:false];
            [self setCurrentValue:dataValue];
        }
        else
        {
            [self.deviceHWInterface setCameraLEDToggle:true];
            [self setCurrentValue:@"FFFFFF"];
        }
    }
}

@end
