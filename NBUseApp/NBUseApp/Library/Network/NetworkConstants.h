//
//  NetworkConstants.h
//  nbTest
//
//  Created by jz on 20/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#ifndef nbTest_NetworkConstants_h
#define nbTest_NetworkConstants_h

#define STAGING
//#define DAN
//#define MARCUS

#define kNodeIdName @"nodeid"

#define kBaseURL    @"https://staging.ninja.is"
#define kLoginURL   @"https://staging.ninja.is/signin"

//TODO: replace APIAccessToken with OAuth
#ifdef MARCUS
#define kAPIAccessToken @"bae38593-fc2b-497c-bef0-27605a026197"
#define kBaseBlockURL   @"https://staging-api.ninja.is/rest/v0/block"
#define kBaseCameraURL  @"https://staging-stream.ninja.is/rest/v0/camera"
#else
#ifdef DAN
//#define kVirtualBlockToken @"6cd61aa2-3f54-423f-b27a-23d87c22e049"
#define kBaseBlockURL   @"http://10.0.1.18:3000/rest/v0/block"
#define kBaseCameraURL  @"http://10.0.1.18:3003/rest/v0/camera"
#else
#ifdef STAGING
#define kAPIAccessToken @"d1f203b6-0feb-4614-bc86-5fbf8f372205"
//#define kVirtualBlockToken @"de60bf3e-0c6e-42e8-afbb-884d7205bc19"
#define kBaseBlockURL   @"https://staging-api.ninja.is/rest/v0/block"
#define kBaseCameraURL  @"https://staging-stream.ninja.is/rest/v0/camera"
#else
#define kAPIAccessToken @"5c33a945-5d0a-43b5-a12b-3f6d0ab5fe80"
//#define kVirtualBlockToken @"b6e9c974-4781-48d1-815f-97cff024429e"
#define kBaseBlockURL @"https://api.ninja.is/rest/v0/block"
#define kBaseCameraURL @"https://stream.ninja.is/rest/v0/camera"
#endif
#endif
#endif

#define kNinjaTokenName @"X-Ninja-Token"

#define kAPIAccessTokenName @"user_access_token"


#define kContentTypeName @"Content-Type"
#define kContentTypeAppJson @"application/json"
#define kContentTypeAppJpeg @"image/jpeg"
#define kContentTypeAppPNG @"image/png"

#define kGUIDName @"GUID"
#define kPortName @"G"
#define kVendorIdName @"V" //vendor
#define kDeviceIdName @"D" //device
#define kDataName @"DA"

/// responses
#define kBlockTokenKey      @"token"
#define kResponseDeviceName @"DEVICE"
#define kResponseNodeName   @"NODE_ID"

#define kResponseLoginData  @"data"
#define kResponseCookieKey  @"ninja.sid"

#define kResponseResultKey   @"result"
#define kResponseErrorKey   @"error"
#define kResponseIdKey   @"id"

#define kResponseErrorValueNone  @"none"
#define kResponseErrorValueInvalid  @"Invalid Request"

#define kResponseResultSuccess  1
#define kResponseResultFailure  0

#define kResponseIdAuthError    401

#endif
