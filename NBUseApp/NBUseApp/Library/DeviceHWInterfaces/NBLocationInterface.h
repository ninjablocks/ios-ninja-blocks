//
//  NBLocationInterface.h
//  NBUseApp
//
//  Created by jz on 27/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDeviceHWInterface.h"

#import <CoreLocation/CoreLocation.h>

@interface NBLocationInterface : NBDeviceHWInterface <CLLocationManagerDelegate>

@end
