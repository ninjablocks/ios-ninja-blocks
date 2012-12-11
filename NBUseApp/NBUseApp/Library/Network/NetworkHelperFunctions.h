//
//  NetworkHelperFunctions.h
//  nbTest
//
//  Created by jz on 22/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ConnectionConstants.h"


#import "NBDevice.h"

@interface NetworkHelperFunctions : NSObject

// constructing json strings
+ (NSString *) guidWithAddress:(NBDeviceAddress)deviceAddress nodeId:(NSString *)nodeId;

+ (NSString *) jsonifyDeviceData:(NBDevice*)deviceData withNodeId:(NSString*)nodeId;
+ (NSString *) jsonifyDeviceData:(NBDevice*)deviceData withNodeId:(NSString*)nodeId isPoll:(bool)poll;

+ (NSString *) jsonifyName:(NSString*)name value:(id)value;

+ (NSString *) jsonifyInnerName:(NSString*)name value:(id)value;
+ (NSString *) jsonifyNames:(NSArray*)names values:(NSArray*)values;


// interpreting json data
+ (bool) hasSuccessWithJsonData:(NSData*)jsonResponse;
+ (bool) hasErrorWithJsonData:(NSData*)jsonResponse;
+ (bool) hasAlreadyActivatedErrorWithJsonData:(NSData*)jsonResponse;
+ (bool) hasAuthenticationErrorWithJsonData:(NSData*)jsonResponse;

@end
