//
//  NBNetworkInitialiser.h
//  nbTest
//
//  Created by jz on 22/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ConnectionConstants.h"
@class NBConnectionData;
@protocol NBNetworkInitDelegate <NSObject>

//- (
- (void) didSetConnectionData:(NBConnectionData*)connectionData;

@end

@interface NBNetworkInitialiser : NSObject

- (id) initWithDelegate:(id<NBNetworkInitDelegate>)delegate;

- (void) loginWithUserName:(NSString*)userName password:(NSString*)password;

- (void) connectWithUserId:(NSString *)userId;


@property (assign, nonatomic) id<NBNetworkInitDelegate> delegate;
@property (strong, nonatomic) NBConnectionData *connectionData;

@end
