//
//  NBDeviceHWInterface.h
//  nbTest
//
//  Created by jz on 23/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import <Foundation/Foundation.h>


@class NBPollingSensor;
@interface NBDeviceHWInterface : NSObject
{
    @protected
    NSMutableArray *_devices;
    bool _requestingAction;
}

- (void) updateDeviceAvailabilityFromHardware;

- (bool) updateReading:(NBPollingSensor*)sensorDevice;

- (void) performSelector:(SEL)selector forEachDeviceOfClass:(Class)class;
- (void) performSelector:(SEL)selector withObject:(id)object forEachDeviceOfClass:(Class)class;


@property (strong, nonatomic) NSString *interfaceName;
@property (readonly, nonatomic) NSArray *devices;

// For sensors/actuators, if requested sensing/actuation from iOS.
// NB: must subclass setter implementations should call super setter.
@property (assign, nonatomic) bool requestingAction;

@end
