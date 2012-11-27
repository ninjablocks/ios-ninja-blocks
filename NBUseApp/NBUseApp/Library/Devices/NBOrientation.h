//
//  NBOrientation.h
//  nbTest
//
//  Created by jz on 27/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBPollingSensor.h"

typedef enum {
    notClear    = 0
    , xPositive = 1
    , xNegative = 2
    , yPositive = 3
    , yNegative = 4
    , zPositive = 5
    , zNegative = 6
} NBOrientationValue;

@interface NBOrientation : NBPollingSensor

- (id) initWithPort:(NSString *)port;

@end
