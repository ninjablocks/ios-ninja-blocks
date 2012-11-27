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
    return [super initWithAddress:(NBDeviceAddress){kVendorNinjaBlocks, kNBWebcam, port}
                     initialValue:@"0"
            ];
}

- (void) processCommand:(NBCommand *)command
{
    NSNumber *dataValue = [command.commandData objectForKey:kCommandDataValueKey];
    if ([dataValue isKindOfClass:[NSNumber class]] && ([dataValue intValue] == 1))
    {
        [self.deviceHWInterface getSnapshot];
    }
}

@end
