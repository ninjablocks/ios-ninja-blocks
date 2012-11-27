//
//  NBCommand.h
//  nbTest
//
//  Created by jz on 26/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NBDevice.h"

#define kCommandDataValueKey @"DA"
//#define kCommand_othervalues @"_"

@interface NBCommand : NSObject

- (id) initWithAddress:(NBDeviceAddress)address dataValue:(NSString*)dataValue;

@property (readonly, nonatomic) NBDeviceAddress address;
@property (readonly, nonatomic) NSDictionary *commandData;

@end
