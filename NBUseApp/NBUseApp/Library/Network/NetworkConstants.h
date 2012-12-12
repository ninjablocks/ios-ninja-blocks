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

#ifdef STAGING
#define kBaseURL    @"https://staging.ninja.is"
#define kLoginURL   @"https://staging.ninja.is/signin"
#define kBaseBlockURL   @"https://staging-api.ninja.is/rest/v0/block"
#define kBaseCameraURL  @"https://staging-stream.ninja.is/rest/v0/camera"
#else
#define kBaseURL    @"https://a.ninja.is"
#define kLoginURL   @"https://a.ninja.is/signin"
#define kBaseBlockURL @"https://api.ninja.is/rest/v0/block"
#define kBaseCameraURL @"https://stream.ninja.is/rest/v0/camera"
#endif

#define kNinjaTokenName @"X-Ninja-Token"

#define kNodeIdName @"nodeid"


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

#define kResponseIdAuthError                401
#define kResponseIdAlreadyActivatedError    409


#endif
