//
//  NBDeviceHWInterfaceSubclass.h
//  nbTest
//
//  Created by jz on 26/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#ifndef nbTest_NBDeviceHWInterfaceSubclass_h
#define nbTest_NBDeviceHWInterfaceSubclass_h

#import "NBDeviceHWInterface.h"

@interface NBDeviceHWInterface (ForSubclassEyesOnly)

//Create and add specific NBDevice subclass objects to _devices
- (void) addDevices;
- (void) updateDevicesOfClass:(Class)deviceClass withAvailability:(bool)available;

@end

#endif
