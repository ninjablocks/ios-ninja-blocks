//
//  NBPollingSensor.m
//  NBUseApp
//
//  Created by jz on 27/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDefinitions.h"
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

- (void) setCurrentValue:(NSString *)currentValue
{
    [_currentValue release];
    _currentValue = [currentValue retain];
    NBLog(kNBLogReadings, @"Set %@   (%@)", NSStringFromClass([self class]), self.currentValue);
//    [self.deviceDelegate triggerSendOfDeviceData:self];
}


@end
