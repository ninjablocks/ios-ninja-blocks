//
//  NBPushButton.m
//  nbTest
//
//  Created by jz on 19/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBPushButton.h"

#import "NBDeviceIds.h"

@implementation NBPushButton

- (id) initWithPort:(NSString *)port
{
    return [super initWithAddress:(NBDeviceAddress){kVendorNinjaBlocks, kNBDIDPushButton, port}
                     initialValue:@"0"
            ];
}

@end
