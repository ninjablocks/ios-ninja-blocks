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
    //TODO: use these once sql is updated on staging
//    kNBDIDPushButton                = 200
//    , kNBDIDAccelerometer           = 206
//    , kNBDIDOrientation             = 207
//    , kNBDIDAccelerometerState      = 208
//    , kNBDIDNorthHeading            = 221
//    , kNBDIDLocation                = 222
//    , kNBDIDLEDUser                 = 1000
//    , kNBDIDWebcam                  = 1004
  
    kNBDIDTemperature               = 1 //not implemented
    , kNBDIDAccelerometer           = 2
    , kNBDIDAccelerometerState      = 3
    , kNBDIDOrientation             = 4
    , kNBDIDPushButton              = 5
    , kNBDIDLightSensor             = 6 //not implemented
    , kNBDIDPassiveInfrared         = 7 //not implemented
    , kNBDIDHumiditySensor          = 8 //not implemented
    , kNBDIDTemperatureDHT22        = 9
    , kNBDIDDistanceSensor          = 10 //not implemented
    , kNBDIDRF433                   = 11 //not implemented
    , kNBDIDSoundSensor             = 12
    , kNBDIDTemperatureLC           = 13 //not implemented
    , kNBDIDHIDDevice               = 14 //not implemented
    , kNBDIDRFIDReader              = 15 //not implemented
    , kNBDIDServo                   = 16 //not implemented
    , kNBDIDNorthHeading            = 15
    , kNBDIDLocation                = 16
    , kNBDIDLEDBoard                = 999
    , kNBDIDLEDUser                 = 1000
    , kNBDIDWebcam                  = 1004

} NBDeviceId;

#endif
