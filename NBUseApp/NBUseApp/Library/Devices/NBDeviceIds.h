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
    kNBDIDPushButton                = 200   //
    , kNBDIDOrientation             = 208   //phone orientation
    , kNBDIDAccelerometerState      = 209   //"shake" "jiggle"
    , kNBDIDLightSensor             = 224   //not implemented
    , kNBDIDHIDDevice               = 210   //gestures
    , kNBDIDNorthHeading            = 222
    , kNBDIDLocation                = 223
    , kNBDIDLEDBoard                = 999
    , kNBDIDLEDUser                 = 1000
    , kNBDIDWebcam                  = 1004

} NBDeviceId;

#endif
