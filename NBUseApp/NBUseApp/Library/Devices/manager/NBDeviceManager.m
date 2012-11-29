//
//  NBDeviceManager.m
//  nbTest
//
//  Created by jz on 23/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDeviceManager.h"

#import "NBDefinitions.h"

#import "NBConnectionData.h"

#import "NBNetworkHandler.h"
#import "NBNetworkCommandHandler.h"

#import "NBAccelerometerInterface.h"
#import "NBCameraInterface.h"
#import "NBLocationInterface.h"

#import "NBDevice.h"
#import "NBDeviceIds.h"
#import "NBPollingSensor.h"
#import "NBCommand.h"

#import "NBCamera.h" //special handling of image data

@interface NBDeviceManager ()
{
    NBNetworkCommandHandler *networkCommandHandler;
    NSMutableArray *_interfaces;
    NSMutableDictionary *_devices;
}

@end

@implementation NBDeviceManager

- (id) initWithConnectionData:(NBConnectionData*)connectionData
{
    self = [super init];
    if (self) {
        _interfaces = [[NSMutableArray alloc] init];
        _devices = [[NSMutableDictionary alloc] init];
        
        self.networkHandler = [[[NBNetworkHandler alloc] initWithConnectionData:connectionData] autorelease];

        NBAccelerometerInterface *accelerometerInterface = [[[NBAccelerometerInterface alloc] init] autorelease];
        [self addDeviceHWInterface:accelerometerInterface];
        
        NBCameraInterface *cameraInterface = [[[NBCameraInterface alloc] init] autorelease];
        [self addDeviceHWInterface:cameraInterface];
        
        NBLocationInterface *locationInterface = [[[NBLocationInterface alloc] init] autorelease];
        [self addDeviceHWInterface:locationInterface];
        
        networkCommandHandler = [[NBNetworkCommandHandler alloc] initWithConnectionData:connectionData delegate:self];
        
    }
    return self;
}

- (void) activateInterfaces
{
    for (NBDeviceHWInterface *interface in self.interfaces)
    {
        [interface setRequestingAction:true];
    }
    NSTimer *devicePollTimer = [NSTimer timerWithTimeInterval:5.
                                              target:self
                                            selector:@selector(heartbeatWithAllDeviceData)
                                            userInfo:nil
                                             repeats:true
                       ];
    [[NSRunLoop mainRunLoop] addTimer:devicePollTimer
                              forMode:NSDefaultRunLoopMode
     ];
}

- (void) heartbeatWithAllDeviceData
{
    for (NBDeviceHWInterface *interface in self.interfaces)
    {
        for (NBDevice *device in [interface devices])
        {
            if ([device isKindOfClass:[NBPollingSensor class]])
            {
                [interface updateReading:(NBPollingSensor*)device];
            }
        }
    }
    [self.networkHandler sendHeartbeatWithDeviceDataArray:[self.devices allValues]];
}

- (void) addDeviceHWInterface:(NBDeviceHWInterface*)interface
{
    [_interfaces addObject:interface];
    for (NBDevice *device in [interface devices])
    {
        NBLog(kNBLogDefault, @"Adding device: %@ for key: %@", device, [device addressKey]);
        [_devices setObject:device forKey:[device addressKey]];
        [device setDeviceDelegate:self];
    }
}

- (void) triggerSendOfDeviceData:(NBDevice*)device
{
    //TODO: could be better, probably seperate camera network functions or even handler...
    if ([device isKindOfClass:[NBCamera class]])
    {
        if ([(NSString*)device.currentValue isEqualToString:@"1"])
        {
            [self.networkHandler performSelector:@selector(sendSnapshot:)
                                        onThread:[NSThread mainThread]
                                      withObject:(NBCamera*)device
                                   waitUntilDone:false
             ];
        }
        else
        {
            [device setCurrentValue:@"1"];
        }
    }
    else
    {
        [self.networkHandler performSelector:@selector(reportDeviceData:)
                                    onThread:[NSThread mainThread]
                                  withObject:device
                               waitUntilDone:false
         ];
    }
}


- (void) didReceiveCommand:(NBCommand*)deviceCommand
{
    NSString *addressKey = [NBDevice addressKey:deviceCommand.address];
    NBDevice *commandedDevice = [self.devices objectForKey:addressKey];
    NBLog(kNBLogCommands, @"Will process command %@ with device: %@", deviceCommand, commandedDevice);
    [commandedDevice processCommand:deviceCommand];
}


- (void) jiggleTest
{
    NBAccelerometerInterface *interface = [self.interfaces objectAtIndex:0];
    [interface fakeJiggle];
}
- (void) triggerCameraData
{
    NBLog(kNBLogVideo, @"devices: %@", self.devices);
    for (NBDevice *device in self.devices.allValues)
    {
        if ([device isKindOfClass:[NBCamera class]])
        {
            [device setCurrentValue:@"1"];
        }
    }
}

- (void) ledData
{
    NBDevice *ledDevice = [[NBDevice alloc] initWithAddress:(NBDeviceAddress){kVendorNinjaBlocks, kNBDIDLEDUser, @"0"}
                                               initialValue:@"0"];
    [ledDevice setDeviceDelegate:self];
    [ledDevice setCurrentValue:@"1"];
}

@end
