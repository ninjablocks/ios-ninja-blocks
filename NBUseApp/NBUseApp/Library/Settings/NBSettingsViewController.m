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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didClickLogout:(id)sender
{
    [[NBDeviceManager sharedManager] logout];
}


@end
