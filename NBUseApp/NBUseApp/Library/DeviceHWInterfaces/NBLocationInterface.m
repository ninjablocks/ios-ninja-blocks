//
//  NBLocationInterface.m
//  NBUseApp
//
//  Created by jz on 27/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBLocationInterface.h"
#import "NBDeviceHWInterfaceSubclass.h"

#import <CoreLocation/CoreLocation.h>

#import "NBHeading.h"

@interface NBLocationInterface ()
{
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) CLHeading *currentHeading;

@end

@implementation NBLocationInterface


- (id) init
{
    self = [super init];
    if (self)
    {
        locationManager = [[CLLocationManager alloc] init];
        //[locationManager setDelegate:self];
    }
    return self;
}

- (void) dealloc
{
    [locationManager stopUpdatingHeading];
    [locationManager release];
    [super dealloc];
}


- (void) addDevices
{
    NBHeading *headingDevice = [[[NBHeading alloc] init] autorelease];
    [headingDevice setDeviceHWInterface:self];
    [_devices addObject:headingDevice];
}

- (void)setRequestingAction:(bool)requestingAction
{
    if (_requestingAction != requestingAction)
    {
        if (requestingAction)
        {
            if ([CLLocationManager headingAvailable])
            {
                [locationManager startUpdatingHeading];
            }
        }
        else
        {
            [locationManager stopUpdatingHeading];
        }
    }
    [super setRequestingAction:requestingAction];
}

- (bool) updateReading:(NBPollingSensor*)sensorDevice
{
    bool result = false;
    if ([sensorDevice isKindOfClass:[NBHeading class]])
    {
        result = [self updateHeading:(NBHeading*)sensorDevice];
    }
    return result;
}

- (bool) updateHeading:(NBHeading*)headingDevice
{
    bool result = false;
    
    if ([CLLocationManager headingAvailable])
    {
        CLHeading *heading = locationManager.heading;
        CLLocationDirection direction = heading.trueHeading;
        [headingDevice setCurrentValue:[NSString stringWithFormat:@"%f", direction]];
        result = true;
    }
    return result;
}

@end
