//
//  NBAccelerometer.h
//  nbTest
//
//  Created by jz on 19/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBPollingSensor.h"

//TODO: have class variable that is the CMMotionManager instance.
@interface NBAccelerometerState : NBDevice

- (id) initWithPort:(NSString *)port;

@end
