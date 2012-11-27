//
//  NetworkHandler.h
//  nbTest
//
//  Created by jz on 15/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "ConnectionConstants.h"

@class NBDevice;
@class NBConnectionData;
@class NBCamera;
@interface NBNetworkHandler : NSObject <NSURLConnectionDataDelegate>

- (id) initWithConnectionData:(NBConnectionData*)connectionData;

- (void) sendHeartbeatWithDeviceDataArray:(NSArray*)deviceDataArray;

- (void) reportDeviceData:(NBDevice*)deviceData;

- (void) sendSnapshot:(NBCamera*)cameraDevice;

@end
