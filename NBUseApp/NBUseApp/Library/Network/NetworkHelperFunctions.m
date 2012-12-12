//
//  NetworkHelperFunctions.m
//  nbTest
//
//  Created by jz on 22/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NetworkHelperFunctions.h"

#import "NetworkConstants.h"
#import "NBDevice.h"

#import "ConnectionConstants.h"

@implementation NetworkHelperFunctions

+ (bool) hasSuccessWithJsonData:(NSData*)jsonResponse
{
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:jsonResponse
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:nil
                                        ];
    NSNumber *resultNumber = [responseDictionary objectForKey:kResponseResultKey];
    return ((resultNumber != nil) && [resultNumber integerValue] == kResponseResultSuccess);
}

+ (bool) hasErrorWithJsonData:(NSData*)jsonResponse
{
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:jsonResponse
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:nil
                                        ];
    NSNumber *resultNumber = [responseDictionary objectForKey:kResponseResultKey];
    return ((resultNumber != nil) && [resultNumber integerValue] == kResponseResultFailure);
}

+ (bool) hasAlreadyActivatedErrorWithJsonData:(NSData*)jsonResponse
{
    return [self hasErrorId:kResponseIdAlreadyActivatedError withJsonData:jsonResponse];
}
+ (bool) hasAuthenticationErrorWithJsonData:(NSData*)jsonResponse
{
    return [self hasErrorId:kResponseIdAuthError withJsonData:jsonResponse];
}

+ (bool) hasErrorId:(NSInteger)errorId withJsonData:(NSData*)jsonResponse
{
    bool hasAuthenticationError = false;
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:jsonResponse
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:nil
                                        ];
    NSNumber *resultNumber = [responseDictionary objectForKey:kResponseResultKey];
    if ([resultNumber integerValue] == kResponseResultFailure)
    {
        NSNumber *idNumber = [responseDictionary objectForKey:kResponseIdKey];
        if ([idNumber integerValue] == errorId)
        {
            hasAuthenticationError = true;
        }
    }
    return hasAuthenticationError;
}

+ (NSString *) guidWithAddress:(NBDeviceAddress)deviceAddress nodeId:(NSString *)nodeId
{
    return [NSString stringWithFormat:@"%@_%@_%d_%d",
            nodeId,
            deviceAddress.port,
            deviceAddress.vendorId,
            deviceAddress.deviceId
            ];
}

+ (NSString *) jsonifyDeviceData:(NBDevice*)deviceData withNodeId:(NSString*)nodeId
{
    return [self jsonifyDeviceData:deviceData withNodeId:nodeId isPoll:false];
}
+ (NSString *) jsonifyDeviceData:(NBDevice*)deviceData withNodeId:(NSString*)nodeId isPoll:(bool)poll
{
    NBDeviceAddress address = deviceData.address;
    NSString *guid = [self guidWithAddress:address nodeId:nodeId];
    NSArray *names = [NSArray arrayWithObjects:kGUIDName, kPortName, kVendorIdName, kDeviceIdName, kDataName, nil];
    NSArray *values = [NSArray arrayWithObjects:guid,
                       deviceData.address.port,
                       [NSNumber numberWithInt:address.vendorId],
                       [NSNumber numberWithInt:address.deviceId],
                       (poll?deviceData.pollValue:deviceData.currentValue), nil];
    return [self jsonifyNames:names values:values];
}

+ (NSString *) jsonifyName:(NSString*)name value:(id)value
{
    return [NSString stringWithFormat:@"{%@}", [self jsonifyInnerName:name value:value]];
}

+ (NSString *) jsonifyInnerName:(NSString*)name value:(id)value
{
    NSString *result;
    if ([value isKindOfClass:[NSNumber class]])
    {
        result = [NSString stringWithFormat:@"\"%@\":%@", name, value];
    }
    else
    {
        result = [NSString stringWithFormat:@"\"%@\":\"%@\"", name, value];
    }
    return result;
}

+ (NSString *) jsonifyNames:(NSArray*)names values:(NSArray*)values
{
    NSMutableString *result = [[[NSMutableString alloc] initWithString:@"{"] autorelease];
    if (([names count]>0) && ([names count] == [values count]))
    {
        int i=0;
        [result appendFormat:@"%@", [self jsonifyInnerName:[names objectAtIndex:i]
                                                               value:[values objectAtIndex:i]
                                     ]
         ];
        for (i=1; i<[names count]; i++)
        {
            [result appendFormat:@",%@", [self jsonifyInnerName:[names objectAtIndex:i]
                                                                    value:[values objectAtIndex:i]]
             ];
        }
    }
    [result appendString:@"}"];
    return result;
}

@end
