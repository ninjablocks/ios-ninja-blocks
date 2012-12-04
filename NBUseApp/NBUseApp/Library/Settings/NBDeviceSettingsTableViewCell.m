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

- (void) setDevice:(NBDevice*)device
{
    [_device release];
    _device = [device retain];
    [self setupDevice];
}

- (void) setupDevice
{
    self.deviceNameLabel.text = self.device.deviceName;
    [self.activitySwitch setOn:(self.device.available && self.device.active)];
    [self.activitySwitch setEnabled:self.device.available];
    [self.activitySwitch addTarget:self
                            action:@selector(changedDeviceActivity)
                  forControlEvents:UIControlEventValueChanged
     ];
}

- (void) changedDeviceActivity:(id)sender
{
    [self.device setActive:self.activitySwitch.isOn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
