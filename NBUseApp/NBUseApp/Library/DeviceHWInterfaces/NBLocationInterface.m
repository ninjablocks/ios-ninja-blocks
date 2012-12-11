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

- (void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    for (NBDevice *device in self.devices)
    {
        if ([device isKindOfClass:[NBHeading class]])
        {
            [self updateHeading:(NBHeading*)device];
        }
    }
}
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (NBDevice *device in self.devices)
    {
        if ([device isKindOfClass:[NBLocation class]])
        {
            [self updateLocation:(NBLocation*)device];
        }
    }
}

- (void)setRequestingAction:(bool)requestingAction
{
    if (_requestingAction != requestingAction)
    {
        if (requestingAction)
        {
            [locationManager setDelegate:self];
            if ([CLLocationManager headingAvailable])
            {
                [locationManager startUpdatingHeading];
            }
            if ([CLLocationManager locationServicesEnabled])
            {
                [locationManager startUpdatingLocation];
            }
        }
        else
        {
            [locationManager stopUpdatingHeading];
            [locationManager stopUpdatingLocation];
        }
    }
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
        [headingDevice setCurrentDirection:direction];
        result = true;
    }
    return result;
}

- (bool) updateLocation:(NBLocation*)locationDevice
{
    bool result = false;
    if ([CLLocationManager locationServicesEnabled])
    {
        [locationDevice setCurrentLocation:locationManager.location];
        result = true;
    }
    return result;
}

@end
