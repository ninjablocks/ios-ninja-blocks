//
//  NBConnectionData.m
//  nbTest
//
//  Created by jz on 23/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDefinitions.h"

#import "NBConnectionData.h"

@implementation NBConnectionData

- (id) initWithUserEmail:(NSString*)userEmail
                  nodeId:(NSString*)nodeId
              blockToken:(NSString*)blockToken
{
    self = [super init];
    if (self)
    {
        _userEmail = [userEmail copy];
        _nodeId = [nodeId retain];
        _blockToken = [blockToken retain];
        NBLog(kNBLogInit, @"Initialising connection data: %@", self);
    }
    return self;
}

- (void) dealloc
{
    [_userEmail release];
    [_nodeId release];
    [_blockToken release];
    [super dealloc];
}

#define kConnDataUserEmailKey   @"kConnDataUserEmailKey"
#define kConnDataNodeIdKey      @"kConnDataNodeIdKey"
#define kConnDataBlockTokenKey  @"kConnDataBlockTokenKey"

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _userEmail = [[aDecoder decodeObjectForKey:kConnDataUserEmailKey] retain];
        _nodeId = [[aDecoder decodeObjectForKey:kConnDataNodeIdKey] retain];
        _blockToken = [[aDecoder decodeObjectForKey:kConnDataBlockTokenKey] retain];
        NBLog(kNBLogInit, @"Decoding connection data: %@", self);
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userEmail forKey:kConnDataUserEmailKey];
    [aCoder encodeObject:self.nodeId forKey:kConnDataNodeIdKey];
    [aCoder encodeObject:self.blockToken forKey:kConnDataBlockTokenKey];
}

- (NSString*) description
{
    NSMutableString *description = [[[NSMutableString alloc] initWithFormat:@"userEmail: %@, nodeId: %@, blockToken: %@"
                                     , self.userEmail
                                     , self.nodeId
                                     , self.blockToken
                                     ] autorelease];
    return description;
}

@end
