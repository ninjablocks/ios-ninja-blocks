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

#import "NBSettings.h"

#import "NBAccelerometerInterface.h"
#import "NBCameraInterface.h"
#import "NBLocationInterface.h"
#import "NBGestureInterface.h"

#import "NBDevice.h"
#import "NBDeviceIds.h"
#import "NBCommand.h"

#import "NBCamera.h" //special handling of image data

@interface NBDeviceManager ()
{
    NBNetworkCommandHandler *networkCommandHandler;
    NSMutableArray *_interfaces;
    NSMutableDictionary *_devices;
    NSTimer *devicePollTimer;
}

@end

static NBDeviceManager *sharedDeviceManager = nil;

@implementation NBDeviceManager

// May be nil. Can only create shared instance with NBConnectionData
+ (id) sharedManager
{
    if (sharedDeviceManager == nil)
    {
        sharedDeviceManager = [[super allocWithZone:NULL] init];
    }
    return sharedDeviceManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
- (id)retain
{
    return self;
}
- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}
- (oneway void)release
{
    //do nothing
}
- (id)autorelease
{
    return self;
}

#define kDeviceCapacityInitial  7

- (void) setupWithConnectionData:(NBConnectionData*)connectionData
{
    self.interfaces = [NSMutableArray array];
    self.devices = [NSMutableDictionary dictionaryWithCapacity:kDeviceCapacityInitial];

    self.networkHandler = [[[NBNetworkHandler alloc] initWithConnectionData:connectionData] autorelease];
    [self.networkHandler setDelegate:self];
    
    NBAccelerometerInterface *accelerometerInterface = [[[NBAccelerometerInterface alloc] init] autorelease];
    [self addDeviceHWInterface:accelerometerInterface];
    
    NBCameraInterface *cameraInterface = [[[NBCameraInterface alloc] init] autorelease];
    [self addDeviceHWInterface:cameraInterface];
    
    NBLocationInterface *locationInterface = [[[NBLocationInterface alloc] init] autorelease];
    [self addDeviceHWInterface:locationInterface];
    
    NBGestureInterface *gestureInterface = [[[NBGestureInterface alloc] initWithAccelerometerInterface:accelerometerInterface]
                                            autorelease];
    [self addDeviceHWInterface:gestureInterface];

    [self initialiseInterfaces];
    sharedDeviceManager.settings = [[[NBSettings alloc] init] autorelease];

    networkCommandHandler = [[NBNetworkCommandHandler alloc] initWithConnectionData:connectionData delegate:self];
        
}
- (void) reset
{
    [devicePollTimer invalidate];
    [devicePollTimer release];
    devicePollTimer = nil;
    for (NBDeviceHWInterface *interface in self.interfaces)
    {
        [interface setRequestingAction:false];
    }
    [networkCommandHandler stopListening];
    networkCommandHandler.delegate = nil;
    [networkCommandHandler release];
    networkCommandHandler = nil;
    self.settings = nil;
    self.networkHandler.delegate = nil;
    self.networkHandler = nil;
    self.interfaces = nil;
    self.devices = nil;
//    self.delegate = nil;
}

- (void) willEnterForeground
{
    [self initialiseInterfaces];
}

- (void) dealloc
{
    [self reset];
    [super dealloc];
}

- (void) initialiseInterfaces
{
    for (NBDeviceHWInterface *interface in self.interfaces)
    {
        [interface updateDeviceAvailabilityFromHardware];
    }
}

- (void) didReceiveAuthenticationError
{
    [self reset];
    [self.delegate didReceiveAuthenticationError:self];
}
- (void) didReceiveAlreadyAuthenticatedError
{
    [self reset];
    [self.delegate didReceiveAlreadyAuthenticatedError:self];
}

#define kDeviceManagerPollInterval      5.
- (void) activateInterfaces
{
    for (NBDeviceHWInterface *interface in self.interfaces)
    {
        [interface setRequestingAction:true];
    }
    if (devicePollTimer != nil)
    {
        [devicePollTimer invalidate];
        [devicePollTimer release];
    }
    devicePollTimer = [[NSTimer alloc] initWithFireDate:[NSDate date]
                                               interval:kDeviceManagerPollInterval
                                                 target:self
                                               selector:@selector(sendAllActiveDeviceData)
                                               userInfo:nil
                                                repeats:true
                       ];
    [[NSRunLoop mainRunLoop] addTimer:devicePollTimer
                              forMode:NSDefaultRunLoopMode
     ];
}

- (void) sendAllActiveDeviceData
{
    NSMutableArray *devicesToSend = [NSMutableArray arrayWithCapacity:[[self.devices allValues] count]];
    for (NBDevice *device in [self.devices allValues])
    {
        if (device.available
            && device.active
            )
        {
            if ((device.lastSend == nil) || -[device.lastSend timeIntervalSinceNow] >= (kDeviceManagerPollInterval-0.5))
            {// time since last send was not much earlier than poll interval
                [devicesToSend addObject:device];
            }
        }
    }
    NBLog(kNBLogReadings, @"Decided to send: %@", devicesToSend);
    [self.networkHandler sendAllWithDeviceDataArray:devicesToSend];
    [self.messageDelegate didSendDeviceArray:devicesToSend];
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

- (void) didChangeSignificantly:(NBDevice*)device
{
    if ([device available] && [device active])
    {
        [self.networkHandler performSelector:@selector(reportDeviceData:)
                                    onThread:[NSThread mainThread]
                                  withObject:device
                               waitUntilDone:false
         ];
        [self.messageDelegate didSendDevice:device];
    }
}

- (void) didChangeActiveStateForDevice:(NBDevice*)device;
{
    [self.settings didUpdateSettingDevice:device];
}

- (void) didChangeAvailableForDevice:(NBDevice*)device;
{
    if (device.available)
    {
        [self.networkHandler plugDevice:device];
    }
    else
    {
        [self.networkHandler unplugDevice:device];
    }
}

- (void) saveSettings
{
    [self.settings saveSettings];
}
- (void) logout
{
    [self reset];
    [self.delegate didLogout:self];
}


- (void) didSendDeviceData
{
    [self.dataDelegate didSendData];
}
- (void) didReceiveData
{
    [self.dataDelegate didReceiveData];
}


- (void) didReceiveCommand:(NBCommand*)deviceCommand
{
    [self.dataDelegate didReceiveCommand];
    [self.messageDelegate didReceiveCommand:deviceCommand.description];
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
            [device setCurrentValue:@"1" isSignificant:true];
        }
    }
}

- (void) ledData
{
    NBDevice *ledDevice = [[NBDevice alloc] initWithAddress:(NBDeviceAddress){kVendorNinjaBlocks, kNBDIDLEDUser, @"0"}
                                               initialValue:@"0"];
    [ledDevice setDeviceDelegate:self];
    [ledDevice setCurrentValue:@"1" isSignificant:true];
}

@end
