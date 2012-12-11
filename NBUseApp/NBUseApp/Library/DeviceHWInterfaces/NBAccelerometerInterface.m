//
//  NBAccelerometerInterface.m
//  nbTest
//
//  Created by jz on 23/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDefinitions.h"

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
}

@property (strong, nonatomic) NSString *orientationValueString;

@end


@implementation NBAccelerometerInterface

- (id) init
{
    self = [super init];
    if (self)
    {
        self.interfaceName = @"Accelerometer";
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
    [accelerometerStateDevice setDeviceHWInterface:self];
    [_devices addObject:accelerometerStateDevice];
    
    NBOrientation *orientationDevice = [[[NBOrientation alloc] init] autorelease];
    [orientationDevice setDeviceHWInterface:self];
    [_devices addObject:orientationDevice];
}

- (bool) isAccelerometerHardwareAvailable
{
    return [motionManager isAccelerometerAvailable];
}

- (void) updateDeviceAvailabilityFromHardware
{
    bool accelerometerAvailable = [self isAccelerometerHardwareAvailable];
    [self updateDevicesOfClass:[NBAccelerometerState class] withAvailability:accelerometerAvailable];
    [self updateDevicesOfClass:[NBOrientation class] withAvailability:accelerometerAvailable];
}

- (bool) updateReading:(NBPollingSensor*)sensorDevice
{
    bool result = false;
    if ([sensorDevice isKindOfClass:[NBOrientation class]])
    {
        [self updateOrientation:(NBOrientation*)sensorDevice];
        result = true;
    }
    return result;
}

- (void) updateOrientation:(NBOrientation*)orientationDevice
{
    [orientationDevice setCurrentValue:self.orientationValueString];
}


//TODO: remove. Testing only.
- (void) fakeJiggle
{
    [accelerometerStateDevice setCurrentValue:@"1" isSignificant:true];
}

- (void) setRequestingAction:(bool)requestingAction
{
    if (_requestingAction != requestingAction)
    {
        if (requestingAction)
        {
            motionOperationQueue = [[NSOperationQueue alloc] init];
            [motionManager setAccelerometerUpdateInterval:0.1];
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
    
    [self.delegate didReceiveAcceleration:currentAcceleration
                              withAverage:averageAcceleration
     ];
    
    [self checkJiggle]; //for event driven updating of accelerometer state device
    [self calculateOrientationValue];
}

#define kJiggleDelta .30
- (void) checkJiggle
{
    if (ABS((averageAcceleration.x-currentAcceleration.x) > kJiggleDelta)
        || ABS((averageAcceleration.y-currentAcceleration.y) > kJiggleDelta)
        || ABS((averageAcceleration.z-currentAcceleration.z) > kJiggleDelta)
        )
    {
        NBLog(kNBLogDefault, @"did jiggle");
        [accelerometerStateDevice setCurrentValue:@"1" isSignificant:true];
    }
}

#define kOrientationDelta .20
- (bool) isAxis1G:(double) axisGForce
{
    double delta1G = ABS(axisGForce) - 1;
    return (ABS(delta1G) < kOrientationDelta);
}

#define kNoFixedOrientation @"0"
- (void) calculateOrientationValue
{
    NSString *orientationValue = kNoFixedOrientation; //default value
    bool xIs1G = [self isAxis1G:averageAcceleration.x];
    bool yIs1G = [self isAxis1G:averageAcceleration.y];
    bool zIs1G = [self isAxis1G:averageAcceleration.z];
    if (xIs1G && !yIs1G && !zIs1G)
    {
        orientationValue = ((averageAcceleration.x > 0) ? @"+x" : @"-x");
    }
    else if (!xIs1G && yIs1G && !zIs1G)
    {
        orientationValue = ((averageAcceleration.y > 0) ? @"+y" : @"-y");
    }
    else if (!xIs1G && !yIs1G && zIs1G)
    {
        orientationValue = ((averageAcceleration.z > 0) ? @"+z" : @"-z");
    }
    self.orientationValueString = orientationValue;
}

- (void) setOrientationValueString:(NSString *)orientationValueString
{
    //only set value when changed to different discrete value (eg, +x, -y, ...)
    if ((![orientationValueString isEqualToString:kNoFixedOrientation])
        && (![_orientationValueString isEqualToString:orientationValueString]))
    {
        [_orientationValueString release];
        _orientationValueString = [orientationValueString retain];
        for (NBDevice *device in self.devices)
        {
            if ([device isKindOfClass:[NBOrientation class]])
            {
                [device setCurrentValue:_orientationValueString isSignificant:true];
            }
        }
    }
}

@end
