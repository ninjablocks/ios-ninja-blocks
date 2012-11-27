//
//  NBAccelerometerInterface.m
//  nbTest
//
//  Created by jz on 23/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBAccelerometerInterface.h"
#import "NBDeviceHWInterfaceSubclass.h"

#import <CoreMotion/CoreMotion.h> //jiggle

#import "NBAccelerometerState.h"
#import "NBOrientation.h"

@interface NBAccelerometerInterface()
{
    bool _detectState;
    CMMotionManager *motionManager;
    NSOperationQueue *motionOperationQueue;
    CMAcceleration averageAcceleration;
    CMAcceleration currentAcceleration;
    
    NBAccelerometerState *accelerometerStateDevice;
    NBOrientation *orientationDevice;
}

@end


@implementation NBAccelerometerInterface

- (id) init
{
    self = [super init];
    if (self)
    {
        motionManager = [[CMMotionManager alloc] init];
    }
    return self;
}

- (void) dealloc
{
    [motionManager release];
    [super dealloc];
}

- (void) addDevices
{
    accelerometerStateDevice = [[NBAccelerometerState alloc] init];
    [_devices addObject:accelerometerStateDevice];
    
    orientationDevice = [[NBOrientation alloc] init];
    [_devices addObject:orientationDevice];
}

//TODO: remove. Testing only.
- (void) fakeJiggle
{
    [self didJiggle];
}

- (void) setRequestingAction:(bool)requestingAction
{
    if (_requestingAction != requestingAction)
    {
        if (requestingAction)
        {
            motionOperationQueue = [[NSOperationQueue alloc] init];
            [motionManager setAccelerometerUpdateInterval:0.2];
            [motionManager startAccelerometerUpdatesToQueue:motionOperationQueue
                                                withHandler:^( CMAccelerometerData* data, NSError* error) {
                                                    [self processAccelerometerData:data];
                                                }];
        }
        else
        {
            [motionManager stopAccelerometerUpdates];
            [motionOperationQueue release];
            motionOperationQueue = nil;
        }
        _requestingAction = requestingAction;
    }
}


- (void) processAccelerometerData:(CMAccelerometerData *)data
{
    currentAcceleration.x = data.acceleration.x;
    currentAcceleration.y = data.acceleration.y;
    currentAcceleration.z = data.acceleration.z;
 
    // influence average accelerations with new reading
    averageAcceleration.x = (averageAcceleration.x * 3 + currentAcceleration.x) / 4;
    averageAcceleration.y = (averageAcceleration.y * 3 + currentAcceleration.y) / 4;
    averageAcceleration.z = (averageAcceleration.z * 3 + currentAcceleration.z) / 4;
    
    [self checkJiggle];
    [self checkOrientation];
}

#define kJiggleDelta .30
- (void) checkJiggle
{
    if (ABS((averageAcceleration.x-currentAcceleration.x) > kJiggleDelta)
        || ABS((averageAcceleration.y-currentAcceleration.y) > kJiggleDelta)
        || ABS((averageAcceleration.z-currentAcceleration.z) > kJiggleDelta)
        )
    {
        NSLog(@"did jiggle");
        //TODO: removed for testing only
        //[accelerometerStateDevice setCurrentValue:@"1"];
    }
}

#define kOrientationDelta .20
- (bool) isAxis1G:(double) axisGForce
{
    double delta1G = ABS(axisGForce) - 1;
    return (ABS(delta1G) < kOrientationDelta);
}

- (void) checkOrientation
{
    NBOrientationValue orientationValue = 0;
    bool xIs1G = [self isAxis1G:averageAcceleration.x];
    bool yIs1G = [self isAxis1G:averageAcceleration.y];
    bool zIs1G = [self isAxis1G:averageAcceleration.z];
    if (xIs1G && !yIs1G && !zIs1G)
    {
        orientationValue = ((averageAcceleration.x > 0) ? xPositive : xNegative);
    }
    else if (!xIs1G && yIs1G && !zIs1G)
    {
        orientationValue = ((averageAcceleration.y > 0) ? yPositive : yNegative);
    }
    else if (!xIs1G && !yIs1G && zIs1G)
    {
        orientationValue = ((averageAcceleration.z > 0) ? zPositive : zNegative);
    }
    NSString *orientationString = [NSString stringWithFormat:@"%d", orientationValue];
    // only set value on change
    if (![orientationString isEqualToString:orientationDevice.currentValue])
    {
        [orientationDevice setCurrentValue:orientationString];
    }
}


@end
