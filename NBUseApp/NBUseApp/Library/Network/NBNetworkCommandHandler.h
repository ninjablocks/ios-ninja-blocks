//
//  NBNetworkCommandHandler.h
//  nbTest
//
//  Created by jz on 23/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ConnectionConstants.h"

@class NBCommand;
@class NBConnectionData;
@protocol NBNetworkCommandHandlerDelegate <NSObject>

- (void) didReceiveCommand:(NBCommand*)deviceCommand;
- (void) didReceiveAuthenticationError;
- (void) didReceiveAlreadyAuthenticatedError;

@end

@interface NBNetworkCommandHandler : NSObject

- (id) initWithConnectionData:(NBConnectionData*)connectionData
                     delegate:(id<NBNetworkCommandHandlerDelegate>)delegate;

- (void) stopListening;

@property (assign, nonatomic) id<NBNetworkCommandHandlerDelegate> delegate;

@end
