//
//  NBSettingsViewController.m
//  NBUseApp
//
//  Created by jz on 11/12/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBSettingsViewController.h"

#import "NBDeviceManager.h"

@interface NBSettingsViewController ()

@end

@implementation NBSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NBDeviceManager sharedManager] setMessageDelegate:self];
    
}

- (void) viewDidUnload
{
    [[NBDeviceManager sharedManager] setMessageDelegate:nil];
}

- (void) dealloc
{
    [[NBDeviceManager sharedManager] setMessageDelegate:nil];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) concatenateMessage:(NSString*)message
{
    NSString *fullTextViewText = [NSString stringWithFormat:@"%@\n%@", self.messageTextView.text, message];
    [self.messageTextView performSelectorOnMainThread:@selector(setText:)
                                           withObject:fullTextViewText
                                        waitUntilDone:false
     ];
}

- (void) didSendDevice:(NBDevice*)device
{
    NSString *message = [NSString stringWithFormat:@"Sent single device: %@\n", device];
    [self concatenateMessage:message];
}
- (void) didSendDeviceArray:(NSArray*)devices
{
    NSMutableString *message = [NSMutableString stringWithFormat:@"Sent %@devices in poll:\n", (([devices count]>0)?@"":@"NO ")];
    for (NBDevice *device in devices)
    {
        [message appendFormat:@"Poll value: %@. Device: %@\n", device.pollValue, device];
    }

    [self concatenateMessage:message];
}

- (void) didReceiveCommand:(NSString*)command
{
    NSString *message = [NSString stringWithFormat:@"Received command: %@\n", command];
    [self concatenateMessage:message];
}



- (IBAction)didClickLogout:(id)sender
{
    [[NBDeviceManager sharedManager] logout];
}


@end
