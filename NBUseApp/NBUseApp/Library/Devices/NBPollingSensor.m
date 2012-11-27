//
//  NBPollingSensor.m
//  NBUseApp
//
//  Created by jz on 27/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBPollingSensor.h"

#import "NBDeviceHWInterface.h"

@interface NBPollingSensor ()
{
    NSTimer *pollingTimer;
}
- (void) updateCurrentData:(NSTimer*)timer;

@end

@implementation NBPollingSensor

- (void) startPolling
{
    if (pollingTimer != nil)
    {
        [self stopPolling];
    }
    if (pollInterval > 0)
    {
        pollingTimer = [[NSTimer alloc] initWithFireDate:[NSDate date]
                                                interval:pollInterval
                                                  target:self
                                                selector:@selector(updateCurrentData:)
                                                userInfo:nil
                                                 repeats:true
                        ];
        [[NSRunLoop mainRunLoop] addTimer:pollingTimer
                                  forMode:NSDefaultRunLoopMode
         ];
    }
}

- (void) stopPolling
{
    [pollingTimer invalidate];
    [pollingTimer release];
    pollingTimer = nil;
}

- (void) updateCurrentData:(NSTimer*)timer
{
    [self.deviceHWInterface updateReading:self];
}


@end
