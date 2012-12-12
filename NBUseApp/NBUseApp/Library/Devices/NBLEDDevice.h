//
//  NBLEDDevice.h
//  NBUseApp
//
//  Created by jz on 28/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDevice.h"

#define kLEDColourOff   @"000000"
#define kLEDColourWhite @"FFFFFF"

@interface NBLEDDevice : NBDevice

- (id) initWithPort:(NSString *)port;


@end
