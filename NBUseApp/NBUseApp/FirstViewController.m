//
//  FirstViewController.m
//  nbTest
//
//  Created by jz on 15/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "FirstViewController.h"

#import "NBDeviceManager.h"

#import "NBNetworkHandler.h"

#import "NBDevice.h"
#import "NBDeviceIds.h"

#import "NBSettingsViewController.h"

@interface FirstViewController () {

}

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Ninja Blocks", @"Ninja Blocks");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *settingsButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                     target:self
                                                                                     action:@selector(didClickSettings:)
                                        ] autorelease];
    self.navigationItem.rightBarButtonItem = settingsButton;
}

//TODO: remove. Testing only
- (IBAction) clickedJiggleTest:(id)sender
{
    [self.deviceManager jiggleTest];
}

- (void) didClickSettings:(id)sender
{
    NBSettingsViewController *settingsViewController = [[[NBSettingsViewController alloc] initWithNibName:@"NBSettingsViewController"
                                                                                                  bundle:nil
                                                        ] autorelease];
    [self.navigationController pushViewController:settingsViewController
                                         animated:true
     ];
}

- (IBAction) clickedFakeAuthError:(id)sender
{
    NBDevice *ledDevice = [[[NBDevice alloc] initWithAddress:(NBDeviceAddress) {kVendorNinjaBlocks, kNBDIDLEDUser, @"0"}
                                                   initialValue:@"1"
                               ] autorelease];
    [self.deviceManager.networkHandler reportBadAuthData:ledDevice];
}

- (IBAction) touchDownPushButton:(id)sender
{
//    NSInteger buttonTag = ((UIButton*)sender).tag;
//    [self.deviceManager.sensorHandler pushButtonPort:buttonTag
//                        didChangeState:true];
}
- (IBAction) touchUpPushButton:(id)sender
{
//    NSInteger buttonTag = ((UIButton*)sender).tag;
//    [self.deviceManager.sensorHandler pushButtonPort:buttonTag
//                        didChangeState:false];
}

- (IBAction) clickedCamera:(id)sender
{
    // Testing only.
    NBDevice *cameraDevice = [[[NBDevice alloc] initWithAddress:(NBDeviceAddress) {kVendorNinjaBlocks, kNBDIDWebcam, @"0"}
                                                initialValue:@"1"
                            ] autorelease];
    [self.deviceManager.networkHandler reportDeviceData:cameraDevice];
}

- (IBAction) clickedSendData:(id)sender
{
    // Testing only.
    [self.deviceManager triggerCameraData];
    [self.deviceManager ledData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
