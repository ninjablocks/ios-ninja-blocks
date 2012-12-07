//
//  NBAccelerometerInterface.h
//  nbTest
//
//  Created by jz on 23/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDeviceHWInterface.h"

#import <CoreMotion/CoreMotion.h>

#define kNotificationAccelerometer

@protocol NBAccelerometerDelegate <NSObject>

- (void) didReceiveAcceleration:(CMAcceleration)acceleration
                    withAverage:(CMAcceleration)avgAcceleration;

@end

@interface NBAccelerometerInterface : NBDeviceHWInterface

- (bool) isAccelerometerHardwareAvailable;

@property (assign, nonatomic) id<NBAccelerometerDelegate> delegate;

@end
