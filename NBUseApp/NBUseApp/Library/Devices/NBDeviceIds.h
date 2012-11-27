//
//  DeviceIds.h
//  nbTest
//
//  Created by jz on 19/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#ifndef nbTest_DeviceIds_h
#define nbTest_DeviceIds_h

#define kVendorNinjaBlocks 0

typedef enum {
    kNBAccelerometer            = 2
    , kNBAccelerometerState     = 3
    , kNBOrientation            = 4
    , kNBPushButton             = 5
    , kNBTemperatureDHT22       = 9
    , kNBLEDBoard               = 999
    , kNBLEDUser                = 1000
    , kNBWebcam                 = 1004
    
    
    
} NBDeviceId;

#endif
