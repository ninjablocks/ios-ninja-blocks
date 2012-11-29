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

@interface FirstViewController () {

}

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

//TODO: remove. Testing only
- (IBAction) clickedJiggleTest:(id)sender
{
    [self.deviceManager jiggleTest];
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
    NBDevice *cameraDevice = [[[NBDevice alloc] initWithAddress:(NBDeviceAddress) {kVendorNinjaBlocks, kNBDIDWebcam, @"0"}
                                                initialValue:@"1"
                            ] autorelease];
    [self.deviceManager.networkHandler reportDeviceData:cameraDevice];
}

- (IBAction) clickedSendData:(id)sender
{
    [self.deviceManager triggerCameraData];
    [self.deviceManager ledData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
