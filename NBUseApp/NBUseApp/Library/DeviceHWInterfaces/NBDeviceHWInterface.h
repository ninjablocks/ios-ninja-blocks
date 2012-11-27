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

- (bool) updateReading:(NBPollingSensor*)sensorDevice;

@property (readonly, nonatomic) NSArray *devices;

// For sensors/actuators, if requested sensing/actuation from iOS.
// NB: must subclass setter implementations should call super setter.
@property (assign, nonatomic) bool requestingAction;

@end
