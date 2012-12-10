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

static NBDeviceManager *sharedDeviceManager = nil;

@implementation NBDeviceManager

// May be nil. Can only create shared instance with NBConnectionData
+ (id) sharedManager
{
    return sharedDeviceManager;
}

+ (id) sharedManagerWithConnectionData:(NBConnectionData*)connectionData
{
    if (sharedDeviceManager != nil)
    {
        [sharedDeviceManager release];
    }
    sharedDeviceManager = [[super allocWithZone:NULL] initWithConnectionData:connectionData];
    sharedDeviceManager.settings = [[[NBSettings alloc] init] autorelease];

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


- (id) init
{
    return nil;
}

- (id) initWithConnectionData:(NBConnectionData*)connectionData
{
    self = [super init];
    if (self) {
        _interfaces = [[NSMutableArray alloc] init];
        _devices = [[NSMutableDictionary alloc] init];
        
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
        
        networkCommandHandler = [[NBNetworkCommandHandler alloc] initWithConnectionData:connectionData delegate:self];
        
    }
    return self;
}

- (void) willEnterForeground
{
    [self initialiseInterfaces];
}

- (void) dealloc
{
    self.networkHandler = nil;
    self.interfaces = nil;
    self.devices = nil;
    [networkCommandHandler release];
    networkCommandHandler = nil;
    self.delegate = nil;
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
    [self.networkHandler setDelegate:nil];
    self.networkHandler = nil;
    [networkCommandHandler setDelegate:nil];
    [networkCommandHandler release];
    networkCommandHandler = nil;
    [self.delegate didReceiveAuthenticationError:self];
}

#define kDeviceManagerPollInterval      5.
- (void) activateInterfaces
{
    for (NBDeviceHWInterface *interface in self.interfaces)
    {
        [interface setRequestingAction:true];
    }
    NSTimer *devicePollTimer = [NSTimer timerWithTimeInterval:kDeviceManagerPollInterval
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
    for (NBDeviceHWInterface *interface in self.interfaces)
    {
        for (NBDevice *device in [interface devices])
        {
            if ([device isKindOfClass:[NBPollingSensor class]])
            {
                [interface updateReading:(NBPollingSensor*)device];
            }
            else if (-[device.lastSend timeIntervalSinceNow] > kDeviceManagerPollInterval) //event driven device not sent recently
            {
                [device resetValue];
            }
        }
    }
    
    NSMutableArray *devicesToSend = [NSMutableArray arrayWithCapacity:[[self.devices allValues] count]];
    for (NBDevice *device in [self.devices allValues])
    {
        if (device.available
            && device.active
            )
        {
            [devicesToSend addObject:device];
        }
    }
    [self.networkHandler sendAllWithDeviceDataArray:devicesToSend];
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
    [self.networkHandler performSelector:@selector(reportDeviceData:)
                                onThread:[NSThread mainThread]
                              withObject:device
                           waitUntilDone:false
     ];
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
