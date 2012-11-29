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
    kNBDIDAccelerometer             = 2
    , kNBDIDAccelerometerState      = 3
    , kNBDIDOrientation             = 4
    , kNBDIDPushButton              = 5
    , kNBDIDLightSensor             = 6 //not yet implemented
    , kNBDIDPassiveInfrared         = 7
    , kNBDIDTemperatureDHT22        = 9
    , kNBDIDSoundSensor             = 12
    , kNBDIDNorthHeading            = 15
    , kNBDIDLocation                = 16
    , kNBDIDLEDBoard                = 999
    , kNBDIDLEDUser                 = 1000
    , kNBDIDWebcam                  = 1004
    
} NBDeviceId;

#endif
