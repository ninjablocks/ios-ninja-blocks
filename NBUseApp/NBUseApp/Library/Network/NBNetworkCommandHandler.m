//
//  NBNetworkCommandHandler.m
//  nbTest
//
//  Created by jz on 23/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBNetworkCommandHandler.h"

#import "NetworkConstants.h"
#import "NetworkHelperFunctions.h"

#import "NBCommand.h"
#import "NBDeviceIds.h"
#import "NBConnectionData.h"

@interface NBNetworkCommandHandler ()
{
    NSMutableURLRequest *commandRequest;
    NBConnectionData *connectionData;
}

@end

@implementation NBNetworkCommandHandler

- (id) initWithConnectionData:(NBConnectionData*)connectionDataParam
                     delegate:(id<NBNetworkCommandHandlerDelegate>)delegate
{
    self = [super init];
    if (self) {
        connectionData = [connectionDataParam retain];
        self.delegate = delegate;
        [self listenForCommands];
    }
    return self;
}

- (void) listenForCommands
{
    bool awaitingCommands = (commandRequest != nil);
    if (!awaitingCommands)
    {
        [self makeCommandRequest];
    }
}

- (void) makeCommandRequest
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/commands"
                           , kBaseBlockURL, connectionData.nodeId
                           ];
    NSLog(@"%@ \n   Listening ...", urlString);
    commandRequest = [[NSMutableURLRequest alloc]
                      initWithURL:[NSURL URLWithString:urlString]];
    
    [commandRequest setHTTPMethod:@"GET"];
    [commandRequest setValue:kContentTypeAppJson
          forHTTPHeaderField:kContentTypeName];
    
    [commandRequest setValue:connectionData.blockToken
          forHTTPHeaderField:kNinjaTokenName];
    
    [[[NSURLConnection alloc]
      initWithRequest:commandRequest
      delegate:self] autorelease];
}

- (void) createDevicesFromCommands:(NSDictionary*)commands
{
    NSLog(@"Commands: %@", [commands description]);
    NSArray *devicesInput = [commands objectForKey:kResponseDeviceName];
    for (NSDictionary *deviceDictionary in devicesInput)
    {
        NSNumber *vendorNumber = [deviceDictionary objectForKey:kVendorIdName];
        if (![vendorNumber isKindOfClass:[NSNumber class]])
        {
            NSLog(@"Vendor not of type number");
            break;
        }
        NSNumber *deviceIdNumber = [deviceDictionary objectForKey:kDeviceIdName];
        if (![deviceIdNumber isKindOfClass:[NSNumber class]])
        {
            NSLog(@"DeviceId not of type number");
            break;
        }
        NSString *port = [deviceDictionary objectForKey:kPortName];
        NSString *dataValue = [deviceDictionary objectForKey:kDataName];
        
        
        NBCommand *command = [[NBCommand alloc] initWithAddress:
                                   (NBDeviceAddress){[vendorNumber intValue]
                                       , [deviceIdNumber intValue]
                                       , port}
                                                       dataValue:dataValue
                                   ];
        [self.delegate didReceiveCommand:command];
    }
}
@end

@implementation NBNetworkCommandHandler (RequestResponseFunctions)

- (void) finishedRequest:(NSURLRequest*)request
{
    NSLog(@"Finished request");
    if (commandRequest == request)
    {
        [commandRequest release];
        commandRequest = nil;
        NSLog(@"Finished listening for commands.");
        [self listenForCommands]; //listen perpetually
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    bool expectingContent = ([response expectedContentLength] > 0);
    NSLog(@"Response length: %lld", [response expectedContentLength]);
    NSLog(@"Response filename: %@", [response suggestedFilename]);
    NSLog(@"Response mimetype: %@", [response MIMEType]);
    NSLog(@"Response textEncodingName: %@", [response textEncodingName]);
    NSLog(@"Response url: %@", [response URL]);
    if (!expectingContent)
    {
        [self finishedRequest:connection.currentRequest];
    }
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
    [self finishedRequest:connection.currentRequest];
}
- (void) connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"didCancelAuthenticationChallenge");
    [self finishedRequest:connection.currentRequest];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *dataString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"received data string: %@", dataString);
    NSError *error = [[NSError alloc] init];
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:&error
                                        ];
    NSLog(@"received json dictionary: %@", responseDictionary);
    //TODO: check for json errors
    [error release];
    
    if (commandRequest == connection.currentRequest)
    {
        [self createDevicesFromCommands:responseDictionary];
    }
    [self finishedRequest:connection.currentRequest];
}
@end