//
//  NBDeviceSettingsTableViewCell.m
//  NBUseApp
//
//  Created by jz on 30/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDeviceSettingsTableViewCell.h"

#import "NBDevice.h"

@implementation NBDeviceSettingsTableViewCell

+ (NSString*) reuseIdentifier
{
    return @"DeviceSettingCell";
}


- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setupWithDevice:(NBDevice*)device
{
    self.deviceNameLabel.text = device.deviceName;
    [self.activitySwitch setOn:device.active];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
