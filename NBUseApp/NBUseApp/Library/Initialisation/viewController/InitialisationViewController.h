//
//  InitialisationViewController.h
//  nbTest
//
//  Created by jz on 22/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NBNetworkInitialiser.h"


@protocol InitialisationDelegate <NSObject>

- (void) didFinishInitialisationWithData:(NBConnectionData*)connectionData;

@end

@interface InitialisationViewController : UIViewController <NBNetworkInitDelegate>


- (IBAction) didClickClearUserData:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *userIdTextField;
@property (strong, nonatomic) IBOutlet UIButton *connectButton;

//@property (strong, nonatomic) IBOutlet UIViewController *successViewController;
@property (assign, nonatomic) id<InitialisationDelegate> delegate;
@end
