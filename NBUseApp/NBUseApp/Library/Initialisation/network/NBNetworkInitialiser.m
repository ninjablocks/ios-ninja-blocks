//
//  NBNetworkInitialiser.m
//  nbTest
//
//  Created by jz on 22/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDefinitions.h"

#import "NBNetworkInitialiser.h"

#import "NetworkConstants.h"
#import "ConnectionConstants.h"

#import "NetworkHelperFunctions.h"
#import "NBConnectionData.h"

@interface NBNetworkInitialiser ()

- (void) registerBlock;
- (void) activateBlock;


@end

#define kDefaultsConnectionData @"kDefaultsConnectionDataKey"

@implementation NBNetworkInitialiser
{
//    NSString *userId;

    NSString *trialNodeId;
    
    NSMutableURLRequest *activateRequest;
}


- (id) initWithDelegate:(id<NBNetworkInitDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}


#define kNodeIdSeparator @"xxx"

- (bool) hasDataForUserId:(NSString*)userId udid:(NSString*)udid
{
    bool result = false;
    NSString *nodeId = self.connectionData.nodeId;
    if ((userId.length > 0) && (nodeId != nil))
    {
        NSRange udidRange = [nodeId rangeOfString:udid options:NSBackwardsSearch];
        int storedUserIdLength = udidRange.location - [kNodeIdSeparator length];
        if (storedUserIdLength > 0) // has valid format
        {
            NSString *storedUserId = [nodeId substringToIndex:storedUserIdLength];
            if ([storedUserId isEqualToString:userId])
            {
                result = true;
            }
        }
    }
    return result;
}

- (void) connectWithUserId:(NSString *)userId
{
    NSData *rawData = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsConnectionData];
    self.connectionData = [NSKeyedUnarchiver unarchiveObjectWithData:rawData];
    NSString *deviceIdentifier;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)])
    {
        deviceIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    else
    {
        deviceIdentifier = [[UIDevice currentDevice] uniqueIdentifier];
    }
    if (![self hasDataForUserId:userId udid:deviceIdentifier])
    {
        self.connectionData = nil;
        trialNodeId = [[NSString alloc] initWithFormat:@"%@%@%@", userId, kNodeIdSeparator, deviceIdentifier];
        NBLog(kNBLogDefault, @"Activating/registering nodeId: %@", trialNodeId);
        [self activateBlock]; //await activation
        [self performSelector:@selector(registerBlock)
                   withObject:nil
                   afterDelay:1
         ];
    }
}

- (void) setConnectionData:(NBConnectionData*)connectionData
{
    [_connectionData release];
    _connectionData = [connectionData retain];
    if (connectionData == nil)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDefaultsConnectionData];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        NBLog(kNBLogDefault, @"setConnectionData: %@", _connectionData);
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_connectionData]
                                                  forKey:kDefaultsConnectionData];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.delegate didSetConnectionData:_connectionData];
    }
}

- (void) activateBlock
{
    bool awaitingActivation = (activateRequest != nil);
    if (!awaitingActivation)
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/activate"
                               , kBaseBlockURL, trialNodeId];
        
        activateRequest = [[NSMutableURLRequest alloc]
                           initWithURL:[NSURL
                                        URLWithString:urlString]];
        
        [activateRequest setHTTPMethod:@"GET"];
        [activateRequest setValue:kContentTypeAppJson
               forHTTPHeaderField:kContentTypeName];
        
        [[[NSURLConnection alloc]
          initWithRequest:activateRequest
          delegate:self] autorelease];
    }
}

- (void) registerBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@?%@=%@", kBaseBlockURL
                           , kAPIAccessTokenName, kAPIAccessToken];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]
                                     initWithURL:[NSURL
                                                  URLWithString:urlString]] autorelease];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:kContentTypeAppJson
   forHTTPHeaderField:kContentTypeName];
    
    NSString *content = [NetworkHelperFunctions jsonifyName:kNodeIdName value:trialNodeId];
    
    [request setValue:[NSString stringWithFormat:@"%d",
                       [content length]]
   forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[content
                          dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[[NSURLConnection alloc]
      initWithRequest:request
      delegate:self] autorelease];
}

- (void) finishedRequest:(NSURLRequest*)request
{
    if (activateRequest == request)
    {
        [activateRequest release];
        activateRequest = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    bool expectingContent = ([response expectedContentLength] > 0);
    if (!expectingContent)
    {
        [self finishedRequest:connection.currentRequest];
    }
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self finishedRequest:connection.currentRequest];
}
- (void) connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [self finishedRequest:connection.currentRequest];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//    NSString *dataString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
//    NBLog(kNBLogNetwork, @"received data string: %@", dataString);
    NSError *error = [[NSError alloc] init];
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:&error
                                        ];
    //TODO: check for json errors
    [error release];
    if (activateRequest == connection.currentRequest)
    {
        NSString *blockToken = [responseDictionary objectForKey:kBlockTokenKey];
        if (trialNodeId != nil)
        {
            self.connectionData = [[[NBConnectionData alloc] initWithNodeId:trialNodeId blockToken:blockToken] autorelease];
        }
    }

    [self finishedRequest:connection.currentRequest];
}

@end
