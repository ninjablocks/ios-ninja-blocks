//
//  NBDeviceHWInterface.h
//  nbTest
//
//  Created by jz on 23/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBDeviceHWInterface : NSObject
{
    @protected
    NSMutableArray *_devices;
    bool _requestingAction;
}

@property (readonly, nonatomic) NSArray *devices;

// For sensors/actuators, if requested sensing/actuation from iOS.
@property (assign, nonatomic) bool requestingAction;

@end
