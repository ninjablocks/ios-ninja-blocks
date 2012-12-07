//
//  NBGestureInterface.m
//  NBUseApp
//
//  Created by jz on 7/12/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDefinitions.h"

#import "NBGestureInterface.h"
#import "NBDeviceHWInterfaceSubclass.h"

#import "NBGestureDevice.h"

#import "NBAccelerometerInterface.h"

@implementation NBGestureInterface
{
    NBAccelerometerInterface *accelerometerInterface;
}

- (id) init
{
    return nil;
}

- (id) initWithAccelerometerInterface:(NBAccelerometerInterface*)interface
{
    self = [super init];
    if (self)
    {
        accelerometerInterface = [interface retain];
        [accelerometerInterface setDelegate:self];
    }
    return self;
}

- (void) dealloc
{
    [accelerometerInterface release];
    [super dealloc];
}

- (void) addDevices
{
    NBGestureDevice *gestureDevice = [[[NBGestureDevice alloc] init] autorelease];
    [gestureDevice setDeviceHWInterface:self];
    [_devices addObject:gestureDevice];
}

- (void) updateDeviceAvailabilityFromHardware
{
    bool hardwareAvailable = [accelerometerInterface isAccelerometerHardwareAvailable];
    [self updateDevicesOfClass:[NBGestureDevice class] withAvailability:hardwareAvailable];
}

unsigned int const stateLength = 4;
enum {axisIndex, gtIndex, thresholdIndex, deltaTimeIndex};

enum {xAxis, yAxis, zAxis};
int const gt = 1, lt = 0;

typedef struct {
    int axis;
    bool gtCheck;
    double threshold;
    double timeout;
}GestureState;

typedef enum {
    failed = -1
    , notFailed = 0
    , passed = 1
}
GestureStateResult;

unsigned int const pulseGestureLength = 4;
GestureState pulseGesture[pulseGestureLength] = {
    {zAxis, gt, -1.2, 0}
    , {zAxis, lt, -1.4, 1}
    , {zAxis, gt, -0.8, 1}
    , {zAxis, lt, -1.4, 1}
};
NSUInteger pulseState = 0;
NSDate *pulseGestureStateChange;
NSString *pulseString = @"z";


- (GestureStateResult) passedState:(GestureState)state
                  withAcceleration:(CMAcceleration)acceleration
                        firstState:(bool)firstState
{
    bool result = notFailed;
    if (!firstState && (-[pulseGestureStateChange timeIntervalSinceNow] > state.timeout))
    {
        return failed;
    }

    double reading = 0;
    switch (state.axis)
    {
        case xAxis:
            reading = acceleration.x;
            break;
        case yAxis:
            reading = acceleration.y;
            break;
        case zAxis:
            reading = acceleration.z;
            break;
    }
    if (state.gtCheck?(reading>state.threshold):(reading<state.threshold))
    {
        NBLog(kNBLogGestures, @"Passed (%f %c %f) in time (%f < %f)"
              , reading, (state.gtCheck?'>':'<'), state.threshold
              , -[pulseGestureStateChange timeIntervalSinceNow], state.timeout
              );
        result = passed;
        pulseGestureStateChange = [[NSDate alloc] init];
    }
    return result;
}

- (void) didReceiveAcceleration:(CMAcceleration)acceleration withAverage:(CMAcceleration)avgAcceleration
{
    GestureStateResult result = [self passedState:pulseGesture[pulseState]
                                 withAcceleration:acceleration
                                       firstState:(pulseState == 0)
                                 ];
    if (result == passed)
    {
        pulseState++;
        if (pulseState == pulseGestureLength)
        {
            pulseState = 0;
            [self reportGesture:pulseString];
        }
    }
    else if (result == failed)
    {
        NBLog(kNBLogGestures, @"RESET");
        pulseState = 0;
    }
}

- (void) reportGesture:(NSString*)gesture
{
    for (NBDevice *device in self.devices)
    {
        [device setCurrentValue:pulseString];
    }
}

@end
