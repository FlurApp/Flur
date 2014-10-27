//
//  FLCameraViewController.m
//  Flur
//
//  Created by David Lee on 10/26/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import "FLCameraViewController.h"
#import <Parse/Parse.h>

@interface FLCameraViewController ()

@property (nonatomic) AVCaptureDevice* device;
@property (nonatomic) AVCaptureSession* session;
@property (nonatomic, readwrite) AVCaptureOutput* captureOutput;
@property (nonatomic, readwrite) AVCaptureStillImageOutput *stillImageOutput;

@end

@implementation FLCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    self.session = [[AVCaptureSession alloc] init];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            self.device = device;
            NSLog(@"FOND THAT SHIT");
        }
    }
    
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (!input) {
        // Handle the error appropriately.
    }
    [self.session addInput:input];
    
    NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG };
    AVCaptureStillImageOutput *newStillImageOutput = [AVCaptureStillImageOutput new];
    [newStillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddOutput:newStillImageOutput]) {
        [self.session addOutput:newStillImageOutput];
        self.stillImageOutput = newStillImageOutput;
    }
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in newStillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:videoConnection
     completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
         if (imageDataSampleBuffer != NULL) {
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
             UIImage *image = [[UIImage alloc] initWithData:imageData];
             
         }
     }];
    
    return;
}

- (void) uploadImage:(NSData*) data {
     PFFile *imageFile = [PFFile fileWithName:@"test.gif" data: data];
          
     // Save PFFile
     [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
         if (!error) {
             PFObject *userPhoto = [PFObject objectWithClassName:@"Images"];
             [userPhoto setObject:imageFile forKey:@"imageFile"];
             [userPhoto setObject:@"testID" forKey:@"pinId"];
             
             
             [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                 if (!error) {
                     NSLog(@"GOOD");
                 }
                 else{
                     // Log details of the failure
                     NSLog(@"Error: %@ %@", error, [error userInfo]);
                 }
             }];
         }
         else{
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     } progressBlock:^(int percentDone) {
         NSLog(@"Working");
         // Update your progress spinner here. percentDone will be between 0 and 100.
         //HUD.progress = (float)percentDone/100;
     }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
