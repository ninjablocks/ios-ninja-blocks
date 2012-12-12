//
//  NBConnectionData.h
//  nbTest
//
//  Created by jz on 23/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBConnectionData : NSObject <NSCoding>

- (id) initWithUserEmail:(NSString*)userEmail
                  nodeId:(NSString*)nodeId
           blockToken:(NSString*)blockToken;

@property (readonly, nonatomic) NSString *userEmail;
@property (readonly, nonatomic) NSString *nodeId;
@property (readonly, nonatomic) NSString *blockToken;

@end
