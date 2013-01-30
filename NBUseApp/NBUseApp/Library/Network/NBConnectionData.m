//
//  NBConnectionData.m
//  nbTest
//
//  Created by jz on 23/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDefinitions.h"

#import "NBConnectionData.h"
#import "NetworkConstants.h"

@implementation NBConnectionData

+ (NSString*) loginURLForServerIndex:(int)serverIndex
{
    return [self loginURLForServerIndex:serverIndex
                         localIPAddress:@""
            ];
}
+ (NSString*) loginURLForServerIndex:(int)serverIndex
                      localIPAddress:(NSString*)localIPAddress
{
    NSString *loginURL = nil;
    switch (serverIndex) {
        case kServerIndexProduction:
            loginURL = kLoginURLProduction;
            break;
        case kServerIndexStaging:
            loginURL = kLoginURLStaging;
            break;
        case kServerIndexLocal:
            loginURL = [NSString stringWithFormat:kLoginURLLocal, localIPAddress];
            break;
        default:
            break;
    }
    return loginURL;
}

+ (NSString*) baseBlockURLForServerIndex:(int)serverIndex
{
    return [self baseBlockURLForServerIndex:serverIndex
                             localIPAddress:@""
            ];
}
+ (NSString*) baseBlockURLForServerIndex:(int)serverIndex
                          localIPAddress:(NSString*)localIPAddress
{
    NSString *baseBlockURL = nil;
    switch (serverIndex) {
        case kServerIndexProduction:
            baseBlockURL = kBaseBlockURLProduction;
            break;
        case kServerIndexStaging:
            baseBlockURL = kBaseBlockURLStaging;
            break;
        case kServerIndexLocal:
            baseBlockURL = [NSString stringWithFormat:kBaseBlockURLLocal, localIPAddress];
            break;
        default:
            break;
    }
    return baseBlockURL;
}

- (id) initWithServerIndex:(int)serverIndex
            localIPAddress:(NSString*)localIPAddress
                 userEmail:(NSString*)userEmail
                    nodeId:(NSString*)nodeId
                blockToken:(NSString*)blockToken
{
    self = [super init];
    if (self)
    {
        _localIPAddress = [localIPAddress copy];
        [self configureURLsWithServerIndex:serverIndex];
        _userEmail = [userEmail copy];
        _nodeId = [nodeId retain];
        _blockToken = [blockToken retain];
        NBLog(kNBLogInit, @"Initialising connection data: %@", self);
    }
    return self;
}

- (void) configureURLsWithServerIndex:(int)serverIndex
{
    switch (serverIndex) {
        case kServerIndexProduction:
            _baseBlockURL = [[NSString alloc] initWithString:kBaseBlockURLProduction];
            _baseCameraURL = [[NSString alloc] initWithString:kBaseCameraURLProduction];
            break;
        case kServerIndexStaging:
            _baseBlockURL = [[NSString alloc] initWithString:kBaseBlockURLStaging];
            _baseCameraURL = [[NSString alloc] initWithString:kBaseCameraURLStaging];
            break;
        case kServerIndexLocal:
            _baseBlockURL = [[NSString alloc] initWithFormat:kBaseBlockURLLocal, self.localIPAddress];
            _baseCameraURL = [[NSString alloc] initWithFormat:kBaseCameraURLLocal, self.localIPAddress];
            break;
        default:
            break;
    }
}

- (void) dealloc
{
    [_baseBlockURL release];
    [_baseCameraURL release];
    [_userEmail release];
    [_nodeId release];
    [_blockToken release];
    [super dealloc];
}

#define kConnDataBaseBlockURL   @"kConnDataBaseBlockURL"
#define kConnDataBaseCaneraURL  @"kConnDataBaseCaneraURL"
#define kConnDataUserEmailKey   @"kConnDataUserEmailKey"
#define kConnDataNodeIdKey      @"kConnDataNodeIdKey"
#define kConnDataBlockTokenKey  @"kConnDataBlockTokenKey"

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _baseBlockURL = [[aDecoder decodeObjectForKey:kConnDataBaseBlockURL] retain];
        _baseCameraURL = [[aDecoder decodeObjectForKey:kConnDataBaseCaneraURL] retain];
        _userEmail = [[aDecoder decodeObjectForKey:kConnDataUserEmailKey] retain];
        _nodeId = [[aDecoder decodeObjectForKey:kConnDataNodeIdKey] retain];
        _blockToken = [[aDecoder decodeObjectForKey:kConnDataBlockTokenKey] retain];
        NBLog(kNBLogInit, @"Decoding connection data: %@", self);
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.baseBlockURL forKey:kConnDataBaseBlockURL];
    [aCoder encodeObject:self.baseCameraURL forKey:kConnDataBaseCaneraURL];
    [aCoder encodeObject:self.userEmail forKey:kConnDataUserEmailKey];
    [aCoder encodeObject:self.nodeId forKey:kConnDataNodeIdKey];
    [aCoder encodeObject:self.blockToken forKey:kConnDataBlockTokenKey];
}

- (NSString*) description
{
    NSMutableString *description = [[[NSMutableString alloc] initWithFormat:@"userEmail: %@, nodeId: %@, blockToken: %@, baseBlockURL: %@, baseCameraURL: %@"
                                     , self.userEmail
                                     , self.nodeId
                                     , self.blockToken
                                     , self.baseBlockURL
                                     , self.baseCameraURL
                                     ] autorelease];
    return description;
}

@end
