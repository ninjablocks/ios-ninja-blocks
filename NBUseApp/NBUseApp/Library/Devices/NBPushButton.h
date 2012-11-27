//
//  NBPushButton.h
//  nbTest
//
//  Created by jz on 19/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDevice.h"

@interface NBPushButton : NBDevice

- (id) initWithPort:(NSString *)port;

//TODO: implement in a persistant manner, eg persist instance, and have hooks for button up/down events

@end
