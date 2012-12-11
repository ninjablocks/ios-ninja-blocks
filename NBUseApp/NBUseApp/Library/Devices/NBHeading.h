//
//  NBHeading.h
//  NBUseApp
//
//  Created by jz on 27/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBPollingSensor.h"
#import <CoreLocation/CoreLocation.h>

@interface NBHeading : NBPollingSensor

- (id) initWithPort:(NSString *)port;

@property (assign, nonatomic) CLLocationDirection currentDirection;

@end
