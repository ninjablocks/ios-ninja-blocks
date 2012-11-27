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

- (void) didUpdateNBDevice:(NBDevice*)device;

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
    @private
    NSString *_currentValue;
}

+ (NSString *) addressKey:(NBDeviceAddress)address;

- (id) initWithAddress:(NBDeviceAddress)address initialValue:(NSString*)initialValue;

//- (bool) isActive;

- (NSString *) addressKey;

- (void) processCommand:(NBCommand*)command;


@property (assign, nonatomic) NBDeviceAddress address;
@property (readonly, nonatomic) NSString *currentValue;

@property (assign, nonatomic) id<NBDeviceProtocol> deviceDelegate;
@property (assign, nonatomic) NBDeviceHWInterface *deviceHWInterface;
@end

