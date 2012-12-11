//
//  NBLocation.h
//  NBUseApp
//
//  Created by jz on 29/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBPollingSensor.h"

#import <CoreLocation/CoreLocation.h>

@interface NBLocation : NBPollingSensor

- (id) initWithPort:(NSString *)port;

@property (strong, nonatomic) CLLocation *currentLocation;

@end
