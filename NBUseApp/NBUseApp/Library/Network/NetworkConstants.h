//
//  NetworkConstants.h
//  nbTest
//
//  Created by jz on 20/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#ifndef nbTest_NetworkConstants_h
#define nbTest_NetworkConstants_h


#define kLoginURLProduction        @"https://a.ninja.is/signin"
#define kBaseBlockURLProduction    @"https://api.ninja.is/rest/v0/block"
#define kBaseCameraURLProduction   @"https://stream.ninja.is/rest/v0/camera"

#define kLoginURLStaging         @"https://staging.ninja.is/signin"
#define kBaseBlockURLStaging     @"https://staging-api.ninja.is/rest/v0/block"
#define kBaseCameraURLStaging    @"https://staging-stream.ninja.is/rest/v0/camera"

#define kLoginURLLocal      @"http://%@:3000/signin"
#define kBaseBlockURLLocal  @"http://%@:3000/rest/v0/block"
#define kBaseCameraURLLocal @"http://%@:3003/rest/v0/camera"

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
