//
//  FirstViewController.h
//  nbTest
//
//  Created by jz on 15/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NBDeviceManager;

@interface FirstViewController : UIViewController

- (IBAction) clickedJiggleTest:(id)sender;
- (IBAction) touchDownPushButton:(id)sender;
- (IBAction) touchUpPushButton:(id)sender;

- (IBAction) clickedCamera:(id)sender;
- (IBAction) clickedSendData:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) NBDeviceManager *deviceManager;

@end
