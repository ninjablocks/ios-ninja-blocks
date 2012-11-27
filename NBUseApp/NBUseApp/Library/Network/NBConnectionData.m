//
//  NBConnectionData.m
//  nbTest
//
//  Created by jz on 23/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBConnectionData.h"

@implementation NBConnectionData

- (id) initWithNodeId:(NSString*)nodeId blockToken:(NSString*)blockToken
{
    self = [super init];
    if (self)
    {
        _nodeId = [nodeId retain];
        _blockToken = [blockToken retain];
    }
    return self;
}

- (void) dealloc
{
    [_nodeId release];
    [_blockToken release];
    [super dealloc];
}

#define kConnDataNodeIdKey      @"kConnDataNodeIdKey"
#define kConnDataBlockTokenKey  @"kConnDataBlockTokenKey"

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _nodeId = [[aDecoder decodeObjectForKey:kConnDataNodeIdKey] retain];
        _blockToken = [[aDecoder decodeObjectForKey:kConnDataBlockTokenKey] retain];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.nodeId forKey:kConnDataNodeIdKey];
    [aCoder encodeObject:self.blockToken forKey:kConnDataBlockTokenKey];
}


@end
