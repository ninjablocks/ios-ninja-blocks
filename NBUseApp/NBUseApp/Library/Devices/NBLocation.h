//
//  NBLocation.h
//  NBUseApp
//
//  Created by jz on 29/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDevice.h"

#import <CoreLocation/CoreLocation.h>

@interface NBLocation : NBDevice

- (id) initWithPort:(NSString *)port;

@property (strong, nonatomic) CLLocation *currentLocation;

@end
