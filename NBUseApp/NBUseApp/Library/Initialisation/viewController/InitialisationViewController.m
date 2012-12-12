//
//  InitialisationViewController.m
//  nbTest
//
//  Created by jz on 22/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "InitialisationViewController.h"


typedef enum {
    stateInit
    , stateLogin
    , stateRetrievingConnectionData
    , stateValidatingConnectionData
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
        currentState = stateInit;
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
    if (self.autoLogin)
    {
        [networkInitialiser performSelectorOnMainThread:@selector(restoreConnectionData)
                                             withObject:nil
                                          waitUntilDone:false
         ];
    }
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) clearUserData
{
    currentState = stateInit;
    [self clearConnectionData];
}

- (IBAction) didClickClearUserData:(id)sender
{
    [self clearUserData];
}

- (void) clearConnectionData
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
}

- (void) retryAlertingUserWithMessage:(NSString*)msg
{
    self.connectButton.enabled = true;
    currentState = stateInit;
    [self clearConnectionData];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"NinjaBlock Connection"
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil
                              ] autorelease];
    [alertView show];
}

- (void) didFailLogin
{
    [self retryAlertingUserWithMessage:@"Invalid username and/or password."];
}

- (void) didFailActivation:(NSString*)alertMessage
{
    [self retryAlertingUserWithMessage:alertMessage];
}

- (void) didFailValidation
{
    [self retryAlertingUserWithMessage:@"Failed to validate token."];
}

- (void) didValidateConnectionData:(NBConnectionData*)connectionData
{
    self.connectButton.enabled = true;
    currentState = stateValidConnectionData;
    [self.delegate didFinishInitialisationWithData:connectionData];
}

@end
