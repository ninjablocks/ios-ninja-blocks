//
//  NBSettingsViewController.h
//  NBUseApp
//
//  Created by jz on 11/12/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NBDeviceManager.h"

@interface NBSettingsViewController : UIViewController <NBDeviceManagerMessageDelegate>


- (IBAction)didClickLogout:(id)sender;

@property (strong, nonatomic) IBOutlet UITextView *messageTextView;

@end
