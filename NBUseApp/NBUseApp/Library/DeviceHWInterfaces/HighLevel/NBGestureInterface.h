//
//  NBGestureInterface.h
//  NBUseApp
//
//  Created by jz on 7/12/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDeviceHWInterface.h"

#import "NBAccelerometerInterface.h"

@interface NBGestureInterface : NBDeviceHWInterface <NBAccelerometerDelegate>

- (id) initWithAccelerometerInterface:(NBAccelerometerInterface*)interface;

@end
