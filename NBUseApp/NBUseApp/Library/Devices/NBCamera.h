//
//  NBCamera.h
//  nbTest
//
//  Created by jz on 26/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDevice.h"

@interface NBCamera : NBDevice

- (id) initWithPort:(NSString *)port;

@property (strong, nonatomic) NSData *snapshotData;

@end
