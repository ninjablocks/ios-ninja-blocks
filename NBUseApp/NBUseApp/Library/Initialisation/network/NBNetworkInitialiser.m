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

@interface NBNetworkInitialiser (validationFunctions)

- (void) validateConnectionData;

@end

@interface NBNetworkInitialiser (blockFunctions)

- (void) registerBlock;
- (void) activateBlock;

- (void) didFailActivation;

@end


#define kDefaultsConnectionData @"kDefaultsConnectionDataKey"

@implementation NBNetworkInitialiser
{
//    NSString *userId;

    NSString *trialNodeId;
    
    NSMutableURLRequest *loginRequest;
    bool failedLogin;

    NSMutableURLRequest *activateRequest;
    NSMutableURLRequest *registerBlockRequest;
    NSMutableURLRequest *validationRequest;
    
    int bytesExpected;
    
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

- (bool) hasDataForUdid:(NSString*)udid
{
    bool result = false;
    NSString *nodeId = self.connectionData.nodeId;
    if ((nodeId != nil) && [nodeId isEqualToString:udid])
    {
        result = true;
    }
    return result;
}

- (bool) hasStoredConnectionData
{
    bool result = false;
    NSData *rawData = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsConnectionData];
    if (rawData != nil)
    {
        result = true;
    }
    return result;
}

- (void) didLoginSuccessfully
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
    if (![self hasDataForUdid:deviceIdentifier])
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
        
        //maybe TODO... [self validateConnectionData];
        [self.delegate didValidateConnectionData:_connectionData];
    }
}

@end

@implementation NBNetworkInitialiser (commenRequestFunctions)

- (void) finishedRequest:(NSURLRequest*)request
{
    NBLog(kNBLogLogin, @"INIT: finished (bytesExpected = %d)", bytesExpected);
    if (activateRequest == request)
    {
        NBLog(kNBLogLogin, @"activation");
        [activateRequest release];
        activateRequest = nil;
    }
    else if (loginRequest == request)
    {
        NBLog(kNBLogLogin, @"AFTER: cookies = %@", [NSHTTPCookieStorage sharedHTTPCookieStorage]);
        [loginRequest release];
        loginRequest = nil;
    }
    else if (registerBlockRequest == request)
    {
        NBLog(kNBLogLogin, @"registration");
        [registerBlockRequest release];
        registerBlockRequest = nil;
    }
    else if (validationRequest == request)
    {
        NBLog(kNBLogLogin, @"validation");
        [validationRequest release];
        validationRequest = nil;
    }
    NBLog(kNBLogLogin, @"INIT: finished finished");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (loginRequest == connection.currentRequest)
    {
        NBLog(kNBLogLogin, @"INIT: received login response: %@", response.URL);
    }
    else if (registerBlockRequest == connection.currentRequest)
    {
        NBLog(kNBLogLogin, @"INIT: received register response: %@", response.URL);
    }
    else if (validationRequest == connection.currentRequest)
    {
        NBLog(kNBLogLogin, @"INIT: received validation response: %@", response.URL);
    }
    bytesExpected = [response expectedContentLength];
    if (bytesExpected == 0)
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
    bytesExpected -= [data length];
    bool notExpectingMoreData = (bytesExpected <= 0);
    NSString *dataString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NBLog(kNBLogLogin, @"INIT: received data string: %@", dataString);
    if (loginRequest == connection.currentRequest)
    {
        NBLog(kNBLogLogin, @"login request");
        if ([NetworkHelperFunctions hasSuccessWithJsonData:data])
        {
            [self performSelector:@selector(didLoginSuccessfully)
                         onThread:[NSThread mainThread]
                       withObject:nil
                    waitUntilDone:false
             ];
        }
        else if (notExpectingMoreData)
        {
            [self.delegate didFailLogin];
        }
    }
    else if (activateRequest == connection.currentRequest)
    {
        NBLog(kNBLogLogin, @"activate request");
        NSError *error = [[NSError alloc] init];
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:NSJSONReadingAllowFragments
                                                                             error:&error
                                            ];
        [error release];
        NSNumber *resultNumber = [responseDictionary objectForKey:kResponseResultKey];
        NSString *blockToken = [responseDictionary objectForKey:kBlockTokenKey];
        if ((trialNodeId != nil) && (blockToken != nil))
        {
            self.connectionData = [[[NBConnectionData alloc] initWithNodeId:trialNodeId blockToken:blockToken] autorelease];
        }
        else if (resultNumber != nil)
        {
            if ([NetworkHelperFunctions hasErrorWithJsonData:data])
            {
                [self didFailActivation];
            }
        }
        else if (bytesExpected <= 0)
        {
            [self didFailActivation];
        }
    }
    else if ((validationRequest == connection.currentRequest) && notExpectingMoreData)
    {
        NBLog(kNBLogLogin, @"validation request");
        [self performSelectorOnMainThread:@selector(reportValidationResultWithData:)
                               withObject:data
                            waitUntilDone:true
         ];
    }
    
    if (notExpectingMoreData)
    {
        [self finishedRequest:connection.currentRequest];
    }
}

- (void) reportValidationResultWithData:(NSData*)data
{
    if ([NetworkHelperFunctions hasErrorWithJsonData:data])
    {
        [self.delegate didValidateConnectionData:self.connectionData];
    }
    else
    {
        [self.delegate didFailValidation];
    }
}

@end

@implementation NBNetworkInitialiser (validationFunctions)

- (void) validateConnectionData
{
    bool awaitingValidation = (validationRequest != nil);
    if (!awaitingValidation)
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/data"
                               , kBaseBlockURL, self.connectionData.nodeId
                               ];
        NBLog(kNBLogNetwork, @"url = %@", urlString);
        validationRequest = [[[NSMutableURLRequest alloc]
                                         initWithURL:[NSURL
                                                      URLWithString:urlString]] autorelease];
        
        [validationRequest setHTTPMethod:@"POST"];
        [validationRequest setValue:kContentTypeAppJson
       forHTTPHeaderField:kContentTypeName];
        
        [validationRequest setValue:self.connectionData.blockToken
       forHTTPHeaderField:kNinjaTokenName];

        NBDevice *deviceData = [[NBDevice alloc] initWithAddress:(NBDeviceAddress){0,0,@"0"}
                                                    initialValue:@"0"
                                ];
        NSString *content = [NetworkHelperFunctions jsonifyDeviceData:deviceData withNodeId:self.connectionData.nodeId];
        
        NBLog(kNBLogNetwork, @"content = %@", content);
        
        [validationRequest setValue:[NSString stringWithFormat:@"%d",
                           [content length]]
       forHTTPHeaderField:@"Content-length"];
        
        [validationRequest setHTTPBody:[content
                              dataUsingEncoding:NSUTF8StringEncoding]];
        
        [[[NSURLConnection alloc]
          initWithRequest:validationRequest
          delegate:self] autorelease];
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

- (void) didFailActivation
{
    //TODO: unregister block then re-register
    [self setConnectionData:nil];
    
    [self.delegate didFailActivation];
}


@end
