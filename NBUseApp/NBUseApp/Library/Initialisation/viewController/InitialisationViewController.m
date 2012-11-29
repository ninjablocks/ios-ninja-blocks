//
//  InitialisationViewController.m
//  nbTest
//
//  Created by jz on 22/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "InitialisationViewController.h"


typedef enum {
    stateNoConnectionData
    , stateRetrievingConnectionData
    , stateValidConnectionData
} ConnectionState;

@interface InitialisationViewController ()
{
    ConnectionState currentState;
    NBNetworkInitialiser *networkInitialiser;
    
}

@end


@implementation InitialisationViewController
{
    NSString *userId;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentState = stateNoConnectionData;
        networkInitialiser = [[NBNetworkInitialiser alloc] initWithDelegate:self];
    }
    return self;
}

#define NBDefaultsUserIdKey @"NBDefaultsUserIdKey"

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.connectButton addTarget:self
                           action:@selector(connect)
                 forControlEvents:UIControlEventTouchUpInside
     ];
    
    userId = [[NSUserDefaults standardUserDefaults] objectForKey:NBDefaultsUserIdKey];
    if (userId != nil) {
        self.userIdTextField.text = userId;
    }
}


- (IBAction) didClickClearUserData:(id)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NBDefaultsUserIdKey];
    [networkInitialiser setConnectionData:nil];
}

//automatically or by button press
- (void) connect
{
    self.connectButton.enabled = false;
    
    userId = self.userIdTextField.text;
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:NBDefaultsUserIdKey];
    currentState = stateRetrievingConnectionData;
    
    [networkInitialiser loginWithUserName:userId
                                 password:self.pwordTextField.text
     ];
//    [networkInitialiser connectWithUserId:userId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didSetConnectionData:(NBConnectionData*)connectionData
{
    self.connectButton.enabled = true;
    if (connectionData != nil)
    {
        currentState = stateValidConnectionData;
        [self.delegate didFinishInitialisationWithData:connectionData];
    }
    else
    {
        currentState = stateNoConnectionData;
        [[UIAlertView alloc] initWithTitle:@"NinjaBlock Connection"
                                   message:[NSString stringWithFormat:@"Could not get valid token for userId %@", userId]
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil
         ];
    }
}

@end
