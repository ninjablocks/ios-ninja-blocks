//
//  NBDeviceSettingsTableViewCell.h
//  NBUseApp
//
//  Created by jz on 30/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NBDevice;
@interface NBDeviceSettingsTableViewCell : UITableViewCell

+ (NSString*) reuseIdentifier;

@property (strong, nonatomic) IBOutlet UISwitch *activitySwitch;
@property (strong, nonatomic) IBOutlet UILabel *deviceNameLabel;

- (void) setupWithDevice:(NBDevice*)device;


@end
