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

@interface NBNetworkInitialiser (blockFunctions)

- (void) registerBlock;
- (void) activateBlock;


@end

#define kDefaultsConnectionData @"kDefaultsConnectionDataKey"

@implementation NBNetworkInitialiser
{
//    NSString *userId;

    NSString *trialNodeId;
    
    NSMutableURLRequest *loginRequest;

    NSMutableURLRequest *activateRequest;
    NSMutableURLRequest *registerBlockRequest;
    
}


- (id) initWithDelegate:(id<NBNetworkInitDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void) loginWithUserName:(NSString*)userName password:(NSString*)password
{
    bool awaitingLogin = (loginRequest != nil);
    if (!awaitingLogin)
    {
        NBLog(kNBLogLogin, @"BEFORE: cookies = %@", [NSHTTPCookieStorage sharedHTTPCookieStorage]);
        NSString *urlString = kLoginURL;
        
        loginRequest = [[NSMutableURLRequest alloc]
                           initWithURL:[NSURL
                                        URLWithString:urlString]];
        
        [loginRequest setHTTPMethod:@"POST"];
        [loginRequest setValue:kContentTypeAppJson
               forHTTPHeaderField:kContentTypeName];
        
        NSString *loginData = [NetworkHelperFunctions jsonifyNames:@[@"email", @"password", @"rememberme", @"redirect"]
                                                            values:@[userName, password, @"false", @""]
                               ];
        
        [loginRequest setValue:[NSString stringWithFormat:@"%d", loginData.length]
       forHTTPHeaderField:@"Content-length"];
        
        [loginRequest setHTTPBody:[loginData dataUsingEncoding:NSUTF8StringEncoding]];

        [[[NSURLConnection alloc]
          initWithRequest:loginRequest
          delegate:self] autorelease];
    }
}


#define kNodeIdSeparator @"xxx"

- (bool) hasDataForUserId:(NSString*)userId udid:(NSString*)udid
{
    bool result = false;
    NSString *nodeId = self.connectionData.nodeId;
    if ((userId.length > 0) && (nodeId != nil))
    {
        NSRange udidRange = [nodeId rangeOfString:udid options:NSBackwardsSearch];
        if (udidRange.location != NSNotFound)
        {
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
    }
    return result;
}

- (void) connectWithUserId:(NSString *)userId
{
    NSData *rawData = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsConnectionData];
    if (rawData != nil)
    {
        self.connectionData = [NSKeyedUnarchiver unarchiveObjectWithData:rawData];
    }
    NSString *deviceIdentifier;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)])
    {
        deviceIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    else
    {
        deviceIdentifier = [[UIDevice currentDevice] uniqueIdentifier];
    }
    deviceIdentifier = [deviceIdentifier stringByReplacingOccurrencesOfString:@"-"
                                                                   withString:@"x"
                        ];
    if (![self hasDataForUserId:userId udid:deviceIdentifier])
    {
        self.connectionData = nil;
        trialNodeId = [[NSString alloc] initWithString:deviceIdentifier]; //[[NSString alloc] initWithFormat:@"%@%@%@", userId, kNodeIdSeparator, deviceIdentifier];
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

@end


@implementation NBNetworkInitialiser (blockFunctions)

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
//    NSString *urlString = [NSString stringWithFormat:@"%@?%@=%@", kBaseBlockURL
//                           , kAPIAccessTokenName, kAPIAccessToken];
    NSString *urlString = [NSString stringWithFormat:@"%@", kBaseBlockURL];
    registerBlockRequest = [[NSMutableURLRequest alloc]
                                     initWithURL:[NSURL
                                                  URLWithString:urlString]];
    
    [registerBlockRequest setHTTPMethod:@"POST"];
    [registerBlockRequest setValue:kContentTypeAppJson
   forHTTPHeaderField:kContentTypeName];
    
    NSString *content = [NetworkHelperFunctions jsonifyName:kNodeIdName value:trialNodeId];
    
    [registerBlockRequest setValue:[NSString stringWithFormat:@"%d",
                       [content length]]
   forHTTPHeaderField:@"Content-length"];
    
    [registerBlockRequest setHTTPBody:[content
                          dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[[NSURLConnection alloc]
      initWithRequest:registerBlockRequest
      delegate:self] autorelease];
}

- (void) finishedRequest:(NSURLRequest*)request
{
    if (activateRequest == request)
    {
        [activateRequest release];
        activateRequest = nil;
    }
    else if (loginRequest == request)
    {
        NBLog(kNBLogLogin, @"AFTER: cookies = %@", [NSHTTPCookieStorage sharedHTTPCookieStorage]);
        [loginRequest release];
        loginRequest = nil;
        [self performSelector:@selector(connectWithUserId:)
                     onThread:[NSThread mainThread]
                   withObject:@""
                waitUntilDone:false
         ];
    }
    else if (registerBlockRequest == request)
    {
        [registerBlockRequest release];
        registerBlockRequest = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (loginRequest == connection.currentRequest)
    {
        NBLog(99, @"INIT: received login response: %@", response.URL);
    }
    if (registerBlockRequest == connection.currentRequest)
    {
        NBLog(99, @"INIT: received register response: %@", response.URL);
    }
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
    NSString *dataString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NBLog(99, @"INIT: received data string: %@", dataString);
    
    if (activateRequest == connection.currentRequest)
    {
        NSError *error = [[NSError alloc] init];
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:NSJSONReadingAllowFragments
                                                                             error:&error
                                            ];
        //TODO: check for json errors
        [error release];
        NSString *blockToken = [responseDictionary objectForKey:kBlockTokenKey];
        if (trialNodeId != nil)
        {
            self.connectionData = [[[NBConnectionData alloc] initWithNodeId:trialNodeId blockToken:blockToken] autorelease];
        }
    }

    [self finishedRequest:connection.currentRequest];
}

@end
