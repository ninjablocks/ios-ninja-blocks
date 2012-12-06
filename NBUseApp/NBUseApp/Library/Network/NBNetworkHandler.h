//
//  NetworkHandler.h
//  nbTest
//
//  Created by jz on 15/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "ConnectionConstants.h"

@protocol NBNetworkDelegate <NSObject>

- (void) didReceiveAuthenticationError;

@end

@class NBDevice;
@class NBConnectionData;
@class NBCamera;
@interface NBNetworkHandler : NSObject <NSURLConnectionDataDelegate>

- (id) initWithConnectionData:(NBConnectionData*)connectionData;

- (void) sendAllWithDeviceDataArray:(NSArray*)deviceDataArray;
- (void) reportDeviceData:(NBDevice*)deviceData;

- (void) unplugDevice:(NBDevice*)device;
- (void) plugDevice:(NBDevice*)device;

- (void) sendSnapshot:(NBCamera*)cameraDevice;


@property (assign, nonatomic) id<NBNetworkDelegate> delegate;

@end

