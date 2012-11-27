//
//  NBOrientation.m
//  nbTest
//
//  Created by jz on 27/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBOrientation.h"

#import "NBDeviceIds.h"

@implementation NBOrientation

- (id) init
{
    return [self initWithPort:@"0"];
}

- (id) initWithPort:(NSString *)port
{
    return [super initWithAddress:(NBDeviceAddress){kVendorNinjaBlocks, kNBOrientation, port}
                     initialValue:@"0"
            ];
}

@end
