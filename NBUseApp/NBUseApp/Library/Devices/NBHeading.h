//
//  NBHeading.h
//  NBUseApp
//
//  Created by jz on 27/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDevice.h"
#import <CoreLocation/CoreLocation.h>

@interface NBHeading : NBDevice

- (id) initWithPort:(NSString *)port;

@property (assign, nonatomic) CLLocationDirection currentDirection;

@end
