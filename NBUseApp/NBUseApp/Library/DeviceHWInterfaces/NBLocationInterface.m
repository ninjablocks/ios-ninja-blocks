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
#import "NBLocation.h"

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
        self.interfaceName = @"Location";

        locationManager = [[CLLocationManager alloc] init];
        //[locationManager setDelegate:self];
    }
    return self;
}

- (void) dealloc
{
    [locationManager stopUpdatingHeading];
    [locationManager stopUpdatingLocation];
    [locationManager release];
    [super dealloc];
}


- (void) addDevices
{
    NBHeading *headingDevice = [[[NBHeading alloc] init] autorelease];
    [headingDevice setDeviceHWInterface:self];
    [_devices addObject:headingDevice];
    NBLocation *location = [[[NBLocation alloc] init] autorelease];
    [location setDeviceHWInterface:self];
    [_devices addObject:location];
}

- (void) updateDeviceAvailabilityFromHardware
{
    bool locationAvailable = [CLLocationManager locationServicesEnabled];
    [self updateDevicesOfClass:[NBLocation class] withAvailability:locationAvailable];
    [self updateDevicesOfClass:[NBHeading class] withAvailability:[CLLocationManager headingAvailable]];
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
                [locationManager startUpdatingLocation];
            }
        }
        else
        {
            [locationManager stopUpdatingHeading];
            [locationManager stopUpdatingLocation];
        }
    }
    [super setRequestingAction:requestingAction];
}

- (bool) updateReading:(NBPollingSensor*)sensorDevice
{
    bool result = false;
    if (sensorDevice.active)
    {
        if ([sensorDevice isKindOfClass:[NBHeading class]])
        {
            result = [self updateHeading:(NBHeading*)sensorDevice];
        }
        else if ([sensorDevice isKindOfClass:[NBLocation class]])
        {
            result = [self updateLocation:(NBLocation*)sensorDevice];
        }
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

- (bool) updateLocation:(NBLocation*)locationDevice
{
    bool result = false;
    NSString *locationString = @"0, 0";
    if ([CLLocationManager locationServicesEnabled])
    {
        CLLocationCoordinate2D coordinate = locationManager.location.coordinate;
        locationString = [NSString stringWithFormat:@"%f, %f", coordinate.latitude, coordinate.longitude];
        result = true;
    }
    [locationDevice setCurrentValue:locationString];
    return result;
}

@end
