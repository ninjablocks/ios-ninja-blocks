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


typedef enum {noAxis=0
    , xAxis=1
    , xAxisNeg = -1
    , yAxis=2
    , yAxisNeg = -2
    , zAxis=3
    , zAxisNeg = -3
} AccAxis;
typedef enum {opLT=-1, opNear=0, opGT=1} Operator;

typedef struct {
    AccAxis gestureAxis;
    int operator;
    double value;
    double timeout;
}GestureState;
unsigned int const stateLength = 4;

#define kOperatorNearThreshold 0.2

typedef enum {
    failed = -1
    , notFailed = 0
    , passed = 1
}
GestureStateResult;

#define kGestureResultX     @"xp"
#define kGestureResultY     @"yp"
#define kGestureResultZ     @"zp"
#define kGestureResultXNeg  @"xn"
#define kGestureResultYNeg  @"yn"
#define kGestureResultZNeg  @"zn"
#define kGestureResultNone  @"NN"

unsigned int const pulseGestureLength = 3;
GestureState pulseGesture[pulseGestureLength] = {
    {noAxis, opGT, 1.4, 1.0}
    , {noAxis, opLT, 0.8, 1.0}
    , {noAxis, opGT, 1.4, 1.0}
};

@implementation NBGestureInterface
{
    NBAccelerometerInterface *accelerometerInterface;

    NSUInteger gestureState;
    AccAxis currentGestureAxis;
    NSDate *pulseGestureStateChange;
    
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
        gestureState = 0;
        currentGestureAxis = noAxis;
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




- (GestureStateResult) passedState:(GestureState)state
                  withAcceleration:(CMAcceleration)acceleration
                        firstState:(bool)firstState
                              axis:(AccAxis)gestureAxis
{
    bool result = notFailed;
    if (!firstState && (-[pulseGestureStateChange timeIntervalSinceNow] > state.timeout))
    {
        NBLog(kNBLogGestures, @" - Failed in time (%f < %f)"
              , -[pulseGestureStateChange timeIntervalSinceNow], state.timeout
              );
        return failed;
    }
    bool reversed = (gestureAxis < 0);
    if (reversed)
    {
        gestureAxis = -gestureAxis;
    }
    double reading = 0;
    AccAxis axis = ((state.gestureAxis!=noAxis) ? state.gestureAxis : gestureAxis);
    switch (axis)
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
        default:
            reading = -999.; //axis set to parameter if noAxis
            break;
    }
    Operator operator = (reversed?-state.operator:state.operator);
    double value = (reversed?-state.value:state.value);
    bool compareResult = false;
    switch (operator)
    {
        case opLT:
            compareResult = reading < value;
            break;
        case opNear:
            compareResult = ABS(reading-value) < kOperatorNearThreshold;
            break;
        case opGT:
            compareResult = reading > value;
            break;
    }
    if (compareResult)
    {
        NBLog(kNBLogGestures, @"Passed (%f %d %f) in time (%f < %f)"
              , reading, operator, state.value
              , -[pulseGestureStateChange timeIntervalSinceNow], state.timeout
              );
        result = passed;
        [pulseGestureStateChange release];
        pulseGestureStateChange = [[NSDate alloc] init];
    }
    return result;
}

- (AccAxis) findFirstPassAxis:(CMAcceleration)acceleration
{
    AccAxis passAxis = noAxis;
    const int axisCount = 6;
    AccAxis axes[axisCount] = {xAxis, yAxis, zAxis, xAxisNeg, yAxisNeg, zAxisNeg};
    GestureStateResult stateResult;
    for (int i=0; i<axisCount; i++)
    {
        stateResult = [self passedState:pulseGesture[gestureState]
                       withAcceleration:acceleration
                             firstState:true
                                   axis:axes[i]
                       ];
        if (stateResult == passed)
        {
            passAxis = axes[i];
            break;
        }
    }
    return passAxis;
}

- (void) didReceiveAcceleration:(CMAcceleration)acceleration withAverage:(CMAcceleration)avgAcceleration
{
    GestureStateResult result = notFailed;
    if (currentGestureAxis == noAxis)
    {
        gestureState = 0;
        currentGestureAxis = [self findFirstPassAxis:acceleration];
        if (currentGestureAxis != noAxis)
        {
            result = passed;
            NBLog(kNBLogGestures, @"Passed First Axis: %d", currentGestureAxis);
        }
    }
    else
    {
        result = [self passedState:pulseGesture[gestureState]
                  withAcceleration:acceleration
                        firstState:false
                              axis:currentGestureAxis
                  ];
    }
    if (result == passed)
    {
        gestureState++;
        if (gestureState == pulseGestureLength)
        {
            NSString *gestureString;
            switch (currentGestureAxis)
            {
                case xAxis:
                    gestureString = kGestureResultX;
                    break;
                case yAxis:
                    gestureString = kGestureResultY;
                    break;
                case zAxis:
                    gestureString = kGestureResultZ;
                    break;
                case xAxisNeg:
                    gestureString = kGestureResultXNeg;
                    break;
                case yAxisNeg:
                    gestureString = kGestureResultYNeg;
                    break;
                case zAxisNeg:
                    gestureString = kGestureResultZNeg;
                    break;
                case noAxis:
                    gestureString = kGestureResultNone;
                    break;

            }
            [self reportGesture:gestureString];
            
            gestureState = 0;
            currentGestureAxis = noAxis;
        }
    }
    else if (result == failed)
    {
        NBLog(kNBLogGestures, @"RESET");
        gestureState = 0;
        currentGestureAxis = noAxis;
    }
}

- (void) reportGesture:(NSString*)gestureString
{
    for (NBDevice *device in self.devices)
    {
        [device setCurrentValue:gestureString isSignificant:true];
    }
}

@end
