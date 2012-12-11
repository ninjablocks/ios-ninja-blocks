//
//  NBLocation.m
//  NBUseApp
//
//  Created by jz on 29/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBLocation.h"

#import "NBDeviceIds.h"

@implementation NBLocation

- (id) init
{
    return [self initWithPort:@"0"];
}

- (id) initWithPort:(NSString *)port
{
    self = [super initWithAddress:(NBDeviceAddress){kVendorNinjaBlocks, kNBDIDLocation, port}
                     initialValue:@"0"
            ];
    if (self)
    {
    }
    return self;
}

#define kSignificantDeltaDist   10

- (void) setCurrentLocation:(CLLocation*)currentLocation
{
    bool isSignificant = ([currentLocation distanceFromLocation:_currentLocation] > 10);
    [_currentLocation release];
    _currentLocation = [currentLocation retain];
    CLLocationCoordinate2D coordinate = currentLocation.coordinate;
    [self setCurrentValue:[NSString stringWithFormat:@"%f, %f", coordinate.latitude, coordinate.longitude]
            isSignificant:isSignificant
     ];
}

- (NSString*)deviceName
{
    return @"Location";
}

@end
