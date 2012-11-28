//
//  NetworkHandler.m
//  nbTest
//
//  Created by jz on 15/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDefinitions.h"

#import "NBNetworkHandler.h"


#import "NetworkConstants.h"
#import "NetworkHelperFunctions.h"

#import "NBDevice.h"
#import "NBDeviceIds.h"
#import "NBConnectionData.h"

#import "NBCamera.h"

@interface NBNetworkHandler ()
{
    NBConnectionData *connectionData;
}
@end

@implementation NBNetworkHandler

- (id) initWithConnectionData:(NBConnectionData*)connectionDataParam
{
    self = [super init];
    if (self) {
        connectionData = [connectionDataParam retain];
    }
    return self;
}

//TODO: remove.
- (void) sendHeartbeatWithDeviceDataArray:(NSArray*)deviceDataArray
{
    NBLog(3, @"send heartbeat data: %@", deviceDataArray);
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/heartbeat"
                           , kBaseBlockURL, connectionData.nodeId
                           ];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]
                                     initWithURL:[NSURL
                                                  URLWithString:urlString]] autorelease];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:kContentTypeAppJson
   forHTTPHeaderField:kContentTypeName];
    
    [request setValue:connectionData.blockToken
   forHTTPHeaderField:kNinjaTokenName];
    
    NSMutableString *content = [NSMutableString stringWithString:@"["];
    int i = 0;
    NBDevice *deviceData = [deviceDataArray objectAtIndex:i];
    [content appendFormat:@"%@", [NetworkHelperFunctions jsonifyDeviceData:deviceData withNodeId:connectionData.nodeId]];
    for (i=1; i<[deviceDataArray count]; i++)
    {
        deviceData = [deviceDataArray objectAtIndex:i];
        [content appendFormat:@",%@", [NetworkHelperFunctions jsonifyDeviceData:deviceData withNodeId:connectionData.nodeId]];
    }
    [content appendString:@"]"];
    NBLog(kNBLogNetwork, @"content = %@", content);
    
    [request setValue:[NSString stringWithFormat:@"%d",
                       [content length]]
   forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[content
                          dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[[NSURLConnection alloc]
      initWithRequest:request
      delegate:self] autorelease];
    
}

- (void) reportDeviceData:(NBDevice*)deviceData
{
    NBLog(kNBLogNetwork, @"Report data: %@", deviceData);
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/data"
                           , kBaseBlockURL, connectionData.nodeId
                           ];
    NBLog(kNBLogNetwork, @"url = %@", urlString);
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]
                                     initWithURL:[NSURL
                                                  URLWithString:urlString]] autorelease];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:kContentTypeAppJson
   forHTTPHeaderField:kContentTypeName];
    
    [request setValue:connectionData.blockToken
   forHTTPHeaderField:kNinjaTokenName];
    
    NSString *content = [NetworkHelperFunctions jsonifyDeviceData:deviceData withNodeId:connectionData.nodeId];
    
    NBLog(kNBLogNetwork, @"content = %@", content);
    
    [request setValue:[NSString stringWithFormat:@"%d",
                       [content length]]
   forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[content
                          dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[[NSURLConnection alloc]
      initWithRequest:request
      delegate:self] autorelease];
}

- (void) sendSnapshot:(NBCamera*)cameraDevice
{
    NSString *guid = [NetworkHelperFunctions guidWithAddress:cameraDevice.address //device id is
                                                      nodeId:connectionData.nodeId
                      ];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/snapshot"
                           , kBaseCameraURL, guid
                           ];
    NBLog(kNBLogNetwork, @"SendSnapshot: (datalength = %d)", cameraDevice.snapshotData.length);
    NBLog(kNBLogNetwork, @"%@", urlString);
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]
                                     initWithURL:[NSURL
                                                  URLWithString:urlString]] autorelease];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:kContentTypeAppPNG
   forHTTPHeaderField:kContentTypeName];
    NBLog(kNBLogNetwork, @"blockToken: %@", connectionData.blockToken);
    [request setValue:connectionData.blockToken
   forHTTPHeaderField:kNinjaTokenName];
    
    [request setValue:[NSString stringWithFormat:@"%d", cameraDevice.snapshotData.length]
   forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:cameraDevice.snapshotData];
    
    [[[NSURLConnection alloc]
      initWithRequest:request
      delegate:self] autorelease];
}

@end


@implementation NBNetworkHandler (RequestResponseFunctions)

- (void) finishedRequest:(NSURLRequest*)request
{
    NBLog(kNBLogNetwork, @"Finished request");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    bool expectingContent = ([response expectedContentLength] > 0);
    NBLog(kNBLogNetwork, @"Response length: %lld", [response expectedContentLength]);
    NBLog(kNBLogNetwork, @"Response filename: %@", [response suggestedFilename]);
    NBLog(kNBLogNetwork, @"Response mimetype: %@", [response MIMEType]);
    NBLog(kNBLogNetwork, @"Response textEncodingName: %@", [response textEncodingName]);
    NBLog(kNBLogNetwork, @"Response url: %@", [response URL]);
    if (!expectingContent)
    {
        [self finishedRequest:connection.currentRequest];
    }
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NBLog(kNBLogNetwork, @"didFailWithError");
    [self finishedRequest:connection.currentRequest];
}
- (void) connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NBLog(kNBLogNetwork, @"didCancelAuthenticationChallenge");
    [self finishedRequest:connection.currentRequest];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *dataString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NBLog(kNBLogNetwork, @"received data string: %@", dataString);
    
    NSError *error = [[NSError alloc] init];
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:&error
                                        ];
    NBLog(kNBLogNetwork, @"received json dictionary: %@", responseDictionary);
    [error release];

    NSString *errorValue = [responseDictionary objectForKey:kResponseErrorKey];
    if ((id)errorValue != [NSNull null])  // && [errorValue isEqualToString:kResponseErrorValueInvalid]) {
    {
        NBLog(kNBLogError, @"error response for url: %@", connection.originalRequest.URL);
        NBLog(kNBLogError, @"error response for headers: %@", connection.originalRequest.allHTTPHeaderFields);
    }
    
    [self finishedRequest:connection.currentRequest];
}


@end
