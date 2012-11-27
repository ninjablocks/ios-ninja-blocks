//
//  NBCameraInterface.h
//  nbTest
//
//  Created by jz on 26/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBDeviceHWInterface.h"

#import <AVFoundation/AVFoundation.h>

@interface NBCameraInterface : NBDeviceHWInterface <AVCaptureVideoDataOutputSampleBufferDelegate>

@end

@interface NBCameraInterface (commandFunctions)

- (void) getSnapshot;

@end

