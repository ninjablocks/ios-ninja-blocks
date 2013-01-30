//
//  NBConnectionData.h
//  nbTest
//
//  Created by jz on 23/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kServerIndexProduction      0
#define kServerIndexStaging         1
#define kServerIndexLocal           2

@interface NBConnectionData : NSObject <NSCoding>

- (id) initWithServerIndex:(int)serverIndex
            localIPAddress:(NSString*)localIPAddress
                 userEmail:(NSString*)userEmail
                    nodeId:(NSString*)nodeId
                blockToken:(NSString*)blockToken;

+ (NSString*) loginURLForServerIndex:(int)serverIndex;
+ (NSString*) loginURLForServerIndex:(int)serverIndex
                      localIPAddress:(NSString*)localIPAddress;

+ (NSString*) baseBlockURLForServerIndex:(int)serverIndex;
+ (NSString*) baseBlockURLForServerIndex:(int)serverIndex
                          localIPAddress:(NSString*)localIPAddress;

@property (readonly, nonatomic) NSNumber *serverIndex;
@property (readonly, nonatomic) NSString *localIPAddress;

@property (readonly, nonatomic) NSString *baseBlockURL;
@property (readonly, nonatomic) NSString *baseCameraURL;
@property (readonly, nonatomic) NSString *userEmail;
@property (readonly, nonatomic) NSString *nodeId;
@property (readonly, nonatomic) NSString *blockToken;

@end
