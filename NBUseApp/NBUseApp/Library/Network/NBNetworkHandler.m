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
    NSMutableURLRequest *sendAllRequest;
    int bytesExpected;
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

- (void) sendAllWithDeviceDataArray:(NSArray*)deviceDataArray
{
    bool awaitingSendAllResponse = (sendAllRequest != nil);
    if (!awaitingSendAllResponse
        && (deviceDataArray != nil)
        && ([deviceDataArray count] > 0)
        )
    {
        
        NBLog(kNBLogNetwork, @"send all data: %@", deviceDataArray);
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/data"
                               , kBaseBlockURL, connectionData.nodeId
                               ];
        sendAllRequest = [[NSMutableURLRequest alloc]
                             initWithURL:[NSURL URLWithString:urlString]];
        
        [sendAllRequest setHTTPMethod:@"POST"];
        [sendAllRequest setValue:kContentTypeAppJson
       forHTTPHeaderField:kContentTypeName];

        [sendAllRequest setValue:connectionData.blockToken
       forHTTPHeaderField:kNinjaTokenName];
        
        NSMutableString *content = [NSMutableString stringWithString:@"["];
        int i = 0;
        NBDevice *deviceData = [deviceDataArray objectAtIndex:i];
        [content appendFormat:@"%@", [NetworkHelperFunctions jsonifyDeviceData:deviceData withNodeId:connectionData.nodeId]];
        for (i=1; i<[deviceDataArray count]; i++)
        {
            deviceData = [deviceDataArray objectAtIndex:i];
            [content appendFormat:@",%@", [NetworkHelperFunctions jsonifyDeviceData:deviceData withNodeId:connectionData.nodeId]];
            [deviceData setLastSend:[NSDate date]];
        }
        [content appendString:@"]"];
        NBLog(kNBLogNetwork, @"content = %@", content);
        
        [sendAllRequest setValue:[NSString stringWithFormat:@"%d",
                           [content length]]
       forHTTPHeaderField:@"Content-length"];
        
        [sendAllRequest setHTTPBody:[content
                              dataUsingEncoding:NSUTF8StringEncoding]];
        
        [[[NSURLConnection alloc]
          initWithRequest:sendAllRequest
          delegate:self] autorelease];
    }
}

- (void) reportBadAuthData:(NBDevice*)deviceData
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
    
    [request setValue:@"TESTbadTokenTEST"//connectionData.blockToken
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
    [deviceData setLastSend:[NSDate date]];

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

- (void) unplugDevice:(NBDevice*)device
{
    //TODO: after this is finished - https://www.pivotaltracker.com/projects/689341#!/stories/40193843
}
- (void) plugDevice:(NBDevice*)device
{
    //TODO: send data command of 0 ?
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
    if (request == sendAllRequest)
    {
        [sendAllRequest release];
        sendAllRequest = nil;
    }
    NBLog(kNBLogNetwork, @"Finished finished");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    bytesExpected = [response expectedContentLength];
    NBLog(kNBLogNetwork, @"Response length: %lld", [response expectedContentLength]);
    NBLog(kNBLogNetwork, @"Response filename: %@", [response suggestedFilename]);
    NBLog(kNBLogNetwork, @"Response mimetype: %@", [response MIMEType]);
    NBLog(kNBLogNetwork, @"Response textEncodingName: %@", [response textEncodingName]);
    NBLog(kNBLogNetwork, @"Response url: %@", [response URL]);
    if (bytesExpected <= 0)
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
    NBLog(kNBLogNetwork, @"NTW: received data");
    bytesExpected -= [data length];
    NSString *dataString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NBLog(kNBLogNetwork, @"NTW: string: %@", dataString);
    
    NSDictionary *responseDictionary = nil;
    responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil
                          ];
    NBLog(kNBLogNetwork, @"received json dictionary: %@", responseDictionary);

    if ([NetworkHelperFunctions hasErrorWithJsonData:data])
    {
        if ([NetworkHelperFunctions hasAuthenticationErrorWithJsonData:data])
        {
            [self.delegate didReceiveAuthenticationError];
        }
        else {
            NBLog(kNBLogError, @"error response for url: %@", connection.originalRequest.URL);
            NBLog(kNBLogError, @"error response for headers: %@", connection.originalRequest.allHTTPHeaderFields);
        }
    }
    else if (bytesExpected <= 0)
    {
        [self finishedRequest:connection.currentRequest];
    }
}


@end
