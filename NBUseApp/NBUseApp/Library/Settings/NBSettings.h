//
//  NBSettings.h
//  NBUseApp
//
//  Created by jz on 6/12/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NBDevice;
@interface NBSettings : NSObject

- (void) didUpdateSettingDevice:(NBDevice*)device;

- (void) saveSettings;

@end
