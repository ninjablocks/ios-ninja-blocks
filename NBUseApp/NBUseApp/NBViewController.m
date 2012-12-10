//
//  NBViewController.m
//  NBUseApp
//
//  Created by jz on 27/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBViewController.h"

@interface NBViewController ()

@end

@implementation NBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupNavigationBar];
    
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
    [self.navigationController pushViewController:settingsViewController
                                         animated:true
     ];
}
@end
