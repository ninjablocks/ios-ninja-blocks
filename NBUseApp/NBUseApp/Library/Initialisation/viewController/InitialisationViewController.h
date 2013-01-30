//
//  InitialisationViewController.h
//  nbTest
//
//  Created by jz on 22/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NBNetworkInitialiser.h"

@class NBConnectionData;
@protocol InitialisationDelegate <NSObject>

- (void) didFinishInitialisationWithData:(NBConnectionData*)connectionData;

@end

@interface InitialisationViewController : UIViewController <NBNetworkInitDelegate>

- (void) clearUserData;

- (IBAction)didChangeServerSegment:(id)sender;
- (IBAction) didClickClearUserData:(id)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *serverSegmentedControl;
@property (strong, nonatomic) IBOutlet UILabel *ipAddressLabel;
@property (strong, nonatomic) IBOutlet UITextField *ipAddressTextField;
@property (strong, nonatomic) IBOutlet UITextField *userIdTextField;
@property (strong, nonatomic) IBOutlet UITextField *pwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *connectButton;
@property (assign, nonatomic) bool autoLogin;

//@property (strong, nonatomic) IBOutlet UIViewController *successViewController;
@property (assign, nonatomic) id<InitialisationDelegate> delegate;
@end
