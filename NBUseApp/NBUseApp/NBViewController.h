//
//  NBViewController.h
//  NBUseApp
//
//  Created by jz on 27/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NBDeviceManager.h"

@interface NBViewController : UIViewController <NBDeviceManagerDataDelegate>


@property (strong, nonatomic) IBOutlet UIView *viewComms;

@property (strong, nonatomic) IBOutlet UIView *viewCommsSend;
@property (strong, nonatomic) IBOutlet UIView *viewCommsReceive;

@property (strong, nonatomic) IBOutlet UIView *viewCommsCommandReceive;

@end
