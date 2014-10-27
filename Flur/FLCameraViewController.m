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

@property (nonatomic, readwrite) UIButton* cameraButton;
@property (nonatomic, readwrite) UIButton* retakeButton;
@property (nonatomic, readwrite) UIButton* useButton;

@property (nonatomic, readwrite) UIImageView* imageTaken;

@end

@implementation FLCameraViewController {
    BOOL retake;
    NSData *imageData;
}

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
    AVCaptureStillImageOutput *newStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [newStillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddOutput:newStillImageOutput]) {
        NSLog(@"adding output:");
        [self.session addOutput:newStillImageOutput];
        self.stillImageOutput = newStillImageOutput;
    }
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    captureVideoPreviewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:captureVideoPreviewLayer];
    
    CALayer *viewLayer = [self.view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [self.view bounds];
    [captureVideoPreviewLayer setFrame:bounds];
    
    [self.session startRunning];
    
    retake = false;
    [self loadCameraButton];
    [self.cameraButton bringSubviewToFront:self.view];
    
    return;
}

- (void)loadCameraButton {
    
    NSLog(@"loadcamera button");
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [button setBackgroundColor:[UIColor blackColor]];
    [[button layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[button layer] setBorderWidth:2.0];
    [button addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchDown];
    [self setCameraButton:button];
    
    [[self view] addSubview:self.cameraButton];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_cameraButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-100]];
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_cameraButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:150]];
//    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_cameraButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-200]];
    
    

}

- (IBAction)takePicture:(id)sender {
    
    NSLog(@"take picture");
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    if (videoConnection == nil) {
        NSLog(@"no video connection");
    }
    
    [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != NULL) {
            NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [[UIImage alloc] initWithData:data];
            _imageTaken = [[UIImageView alloc] initWithImage:image];
            imageData = data;
            [self configureImageView];
        }
    }];
    
}

- (void)configureImageView {
    
    [[self view] addSubview:[self imageTaken]];
    [_imageTaken setFrame:self.view.frame];
    
    NSLog(@"CONFIGURE IMAGE VIEW");
    _retakeButton = [[UIButton alloc] init];
    [_retakeButton setTitle:@"Retake" forState:UIControlStateNormal];
    [_retakeButton setEnabled:TRUE];
    [_retakeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_retakeButton addTarget:self action:@selector(retakePicture:) forControlEvents:UIControlEventTouchDown];
    
    [[self imageTaken] addSubview:_retakeButton];
    
    [[self imageTaken] addConstraint:[NSLayoutConstraint constraintWithItem:_retakeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[self imageTaken] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-50]];
    
    [[self imageTaken] addConstraint:[NSLayoutConstraint constraintWithItem:_retakeButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[self imageTaken] attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20]];
    
    _useButton = [[UIButton alloc] init];
    [_useButton setTitle:@"Use Photo" forState:UIControlStateNormal];
    [_useButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_useButton setEnabled:TRUE];
    [_useButton addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchDown];
    
    [[self imageTaken] addSubview:_useButton];
    
    [[self imageTaken] addConstraint:[NSLayoutConstraint constraintWithItem:_useButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[self imageTaken] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-50]];
    
    [[self imageTaken] addConstraint:[NSLayoutConstraint constraintWithItem:_useButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[self imageTaken] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-20]];
    
    
}

- (IBAction)uploadImage:(id)sender {
    
    
    NSLog(@"uploadImage");
    
    PFFile *imageFile = [PFFile fileWithName:@"test.gif" data:imageData];
//     PFFile *imageFile = [PFFile fileWithName:@"test.gif" data:UIImagePNGRepresentation([UIImage imageNamed:@"frame_0.gif"])];

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

-(IBAction)retakePicture:(id)sender {
    
    NSLog(@"retake picture");
    [_imageTaken removeFromSuperview];
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
