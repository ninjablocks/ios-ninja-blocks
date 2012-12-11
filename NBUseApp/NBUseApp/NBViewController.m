//
//  NBViewController.m
//  NBUseApp
//
//  Created by jz on 27/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBViewController.h"

#import "NBSettingsViewController.h"
#import "NBDeviceSettingsViewController.h"

@implementation NBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupNavigationBar];
    
    [[NSBundle mainBundle] loadNibNamed:@"CommsLights"
                                  owner:self
                                options:nil
     ];
    CGRect commsFrame = self.viewComms.frame;
    commsFrame.origin.x = self.view.frame.size.width - commsFrame.size.width;
    commsFrame.origin.y = self.view.frame.size.height - commsFrame.size.height;
    [self.viewComms setFrame:commsFrame];
    [self.view addSubview:self.viewComms];
}

- (void) setupNavigationBar
{
    UIBarButtonItem *settingsButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                     target:self
                                                                                     action:@selector(didClickSettings:)
                                        ] autorelease];
    self.navigationItem.rightBarButtonItem = settingsButton;
    [self.navigationItem setTitle:@"Ninja Blocks"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didClickSettings:(id)sender
{
    NBSettingsViewController *settingsViewController = [[[NBSettingsViewController alloc] initWithNibName:@"NBSettingsViewController"
                                                                                                  bundle:nil
                                                         ] autorelease];
    NBDeviceSettingsViewController *deviceSettingsViewController = [[[NBDeviceSettingsViewController alloc] initWithNibName:@"NBDeviceSettingsViewController"
                                                                                                   bundle:nil
                                                         ] autorelease];
    UITabBarController *tabBarViewController = [[[UITabBarController alloc] init] autorelease];
    [tabBarViewController setViewControllers:@[settingsViewController, deviceSettingsViewController]];
    [self.navigationController pushViewController:tabBarViewController
                                         animated:true
     ];
}


- (void) setDeviceManager:(NBDeviceManager *)deviceManager
{
    [_deviceManager release];
    _deviceManager = [deviceManager retain];
    [self.deviceManager setDataDelegate:self];
}

#define kLightPulseDelay    0.2
- (void) pulseView:(UIView*)view withColour:(UIColor*)colour
{
    [view setBackgroundColor:[UIColor darkGrayColor]];
    [view performSelector:@selector(setBackgroundColor:)
               withObject:colour
               afterDelay:0.01
     ];
    [view performSelector:@selector(setBackgroundColor:)
               withObject:[UIColor darkGrayColor]
               afterDelay:kLightPulseDelay
     ];
}

- (void) didSendData
{
    [self pulseView:self.viewCommsSend
         withColour:[UIColor greenColor]
     ];
}
- (void) didReceiveData
{
    [self pulseView:self.viewCommsReceive
         withColour:[UIColor redColor]
     ];
}

- (void) didReceiveCommand
{
    [self pulseView:self.viewCommsCommandReceive
         withColour:[UIColor orangeColor]
     ];
}

@end
