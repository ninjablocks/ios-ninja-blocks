//
//  NBCameraInterface.m
//  nbTest
//
//  Created by jz on 26/11/12.
//  Copyright (c) 2012 James Zaki. All rights reserved.
//

#import "NBCameraInterface.h"
#import "NBDeviceHWInterfaceSubclass.h"

#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>

#import "NBCamera.h"

@interface NBCameraInterface ()

@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) UIImage *stillImage;

@property (strong, nonatomic) AVCaptureSession *session;

@property (strong, nonatomic) NBCamera *camera;

@end

@interface NBCameraInterface (hwFunctions)

- (void) setupAVInputOutput;

@end

@implementation NBCameraInterface

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setupAVInputOutput];
    }
    return self;
}

- (void) dealloc
{
    //[motionManager release];
    [super dealloc];
}

- (void) addDevices
{
    self.camera = [[[NBCamera alloc] init] autorelease];
    [self.camera setDeviceHWInterface:self];
    [_devices addObject:self.camera];
}
@end

@implementation NBCameraInterface (hwFunctions)

- (void) receivedImage:(UIImage*)image
{
    [self.camera setSnapshotData:UIImagePNGRepresentation(image)];
    [self.camera setCurrentValue:@"1"]; //trigger update
}


- (void) setupAVInputOutput
{
    //add input
    self.session = [[[AVCaptureSession alloc] init] autorelease];
    self.session.sessionPreset = AVCaptureSessionPreset352x288;
    
    AVCaptureDevice *device = [AVCaptureDevice
                               defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = [[[NSError alloc] init] autorelease];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput
                                   deviceInputWithDevice:device error:&error];
    
    [self.session addInput:input];
    
    //add output
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    
    NSLog(@"videoSettings: %@", [output videoSettings]);
    NSDictionary *videoSetting
    = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                  forKey:(NSString*)kCVPixelBufferPixelFormatTypeKey];
    [output setVideoSettings:videoSetting];
    NSLog(@"videoSettings: %@", [output videoSettings]);
    
    [self.session addOutput:output];
    
    dispatch_queue_t serial_queue = dispatch_queue_create("myQueue", NULL);
    [output setSampleBufferDelegate:self queue:serial_queue];
    
}

- (void)setRequestingAction:(bool)requestingAction
{
    if (_requestingAction != requestingAction)
    {
        if (requestingAction)
        {
            [self.session startRunning];
        }
        _requestingAction = requestingAction;
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    CFShow(sampleBuffer);
    UIImage *capturedImage = [self imageFromSampleBuffer:sampleBuffer];
    [self receivedImage:capturedImage];
    //NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:sampleBuffer];
    
    [self.session stopRunning];
    
    //TODO: [self.cameraDelegate receivedImage:capturedImage];
    
}

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    OSType type = CVPixelBufferGetPixelFormatType(imageBuffer);
    NSLog(@"%lx", type);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst
                                                 );
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

@end



@implementation NBCameraInterface (commandFunctions)

- (void) getSnapshot
{
    [self setRequestingAction:true];
}

@end
