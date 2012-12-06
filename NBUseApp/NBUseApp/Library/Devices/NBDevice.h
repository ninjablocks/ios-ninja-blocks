//
//  NBDevice.h
//  nbTest
//
//  A NB representation of a specific use of hardware.
//  eg. The accelerometer hardware can be interpreted into two ninjablock devices,
//  a raw accelerometer (x,y,z) device, or simple a bump or "jiggle" state to
//  detect significant movement from stationary.
//
//  Created by jz on 19/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

@class NBDevice; //interface below
@protocol NBDeviceProtocol <NSObject>


- (void) didChangeSignificantly:(NBDevice*)device;

- (void) didChangeActiveStateForDevice:(NBDevice*)device;
- (void) didChangeAvailableForDevice:(NBDevice*)device;

@end


typedef struct _NBDeviceAddress {
    int vendorId;
    int deviceId;
    NSString *port;
} NBDeviceAddress;

@class NBCommand;
@class NBDeviceHWInterface;
@interface NBDevice : NSObject
{
    @protected
    NSString *_currentValue;
    bool _changedSignificantly;
}

+ (NSString *) addressKey:(NBDeviceAddress)address;

- (id) initWithAddress:(NBDeviceAddress)address initialValue:(NSString*)initialValue;

- (NSString *) addressKey;

- (void) processCommand:(NBCommand*)command;


// Used in NB settings view controller for display.
@property (strong, nonatomic) NSString *deviceName;

// Set from NB device/hw interface.
// Used in NB settings view controller for display.
@property (assign, nonatomic) bool available;

// Set from NBSettingsViewController
// Used in NB settings view controller for display.
@property (assign, nonatomic) bool active;


@property (readonly, nonatomic) NBDeviceAddress address;
@property (strong, nonatomic) NSString *currentValue;

@property (assign, nonatomic) id<NBDeviceProtocol> deviceDelegate;
@property (assign, nonatomic) NBDeviceHWInterface *deviceHWInterface;
@end

