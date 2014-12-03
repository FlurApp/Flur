//
//  FLCameraViewController.m
//  Flur
//
//  Created by David Lee on 10/26/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <Parse/Parse.h>

#import <AVFoundation/AVFoundation.h>
#import "FLPin.h"
#import "FLCameraViewController.h"
#import "FLPhotoManager.h"
#import "LocalStorage.h"
#import "Flur.h"
#import "FLConstants.h"

#define back TRUE
#define front FALSE

@interface FLCameraViewController ()

@property (nonatomic, readwrite) FLPin* pin;

@property (nonatomic) AVCaptureDevice* frontDevice;
@property (nonatomic) AVCaptureDevice* backDevice;
@property (nonatomic) AVCaptureSession* session;
@property (nonatomic, readwrite) AVCaptureOutput* captureOutput;
@property (nonatomic, readwrite) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic) AVCaptureDeviceInput *captureInput;

@property (nonatomic, readwrite) UIButton* cameraButton;
@property (nonatomic, readwrite) UIButton* retakeButton;
@property (nonatomic, readwrite) UIButton* useButton;
@property (nonatomic, readwrite) UIButton* backButton;
@property (nonatomic, readwrite) UIImageView* imageTaken;
@property (strong, nonatomic) UIImageView * spinner;


@property (nonatomic, strong) NSMutableArray* allPhotos;
@property (nonatomic, strong) NSMutableDictionary* dataToPass;
@property (nonatomic, strong) NSData *imageData;

@property (nonatomic, strong) FLPhotoManager *photoManager;

@property (nonatomic) BOOL frontBack;
@property (nonatomic, strong) UIButton *toggleCamButton;


// used for determining when both completion handlers finished
@property (nonatomic) int count;




@end

@implementation FLCameraViewController {
    BOOL retake;
}

- (void) setData:(NSMutableDictionary *)data {
    if (data) {
        FLPin *pin = [data objectForKey:@"FLPin"];
        self.pin = pin;
        self.count = 0;
        self.allPhotos = [[NSMutableArray alloc] init];
        self.dataToPass = [[NSMutableDictionary alloc] init];
        [self.dataToPass setObject:pin forKey:@"FLPin"];
        self.photoManager = [[FLPhotoManager alloc] init];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];

    self.session = [[AVCaptureSession alloc] init];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            self.backDevice = device;
        }
        else if ([device position] == AVCaptureDevicePositionFront) {
            self.frontDevice = device;
        }
    }
    
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    NSError *error;
    self.captureInput = [AVCaptureDeviceInput deviceInputWithDevice:self.backDevice error:&error];
    if (!self.captureInput) {
        // Handle the error appropriately.
    }
    [self.session addInput:self.captureInput];
    
    NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG };
    AVCaptureStillImageOutput *newStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [newStillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddOutput:newStillImageOutput]) {
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
    [self loadBackButton];
    [self loadToggleCamButton];
    
    // used later to toggle front and back cameras
    [self setFrontBack:back];
    
    return;
}

- (void) loadToggleCamButton {
    
    UIButton *button = [[UIButton alloc] init];
    
    [button addTarget:self action:@selector(toggleCamera:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(growButtonAnimation:) forControlEvents:UIControlEventTouchDown];
    
    [button setImage:[UIImage imageNamed:@"switchCam.png"] forState:UIControlStateNormal];
    
    [button setImageEdgeInsets:UIEdgeInsetsMake(10,10,10,10)];
    [self setToggleCamButton:button];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[self view] addSubview:self.toggleCamButton];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.toggleCamButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:10]];
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.toggleCamButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.toggleCamButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:55.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.toggleCamButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:55.0]];
}

- (IBAction)toggleCamera:(id)sender {
    
    [UIView animateWithDuration:.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.toggleCamButton.transform = CGAffineTransformMakeScale(1,1);
        
    } completion:^(BOOL finished) {

        [self.session beginConfiguration];

        AVCaptureDeviceInput *input;
        // if i have the back camera show the front
        if (self.frontBack) {
            
            NSError *error;
            input = [AVCaptureDeviceInput deviceInputWithDevice:self.frontDevice error:&error];
            if (!input) {
                NSLog(@"bad");
                // Handle the error appropriately.
            }
        }
        
        // else i have the front camera show the back
        else {
            
            NSError *error;
            input = [AVCaptureDeviceInput deviceInputWithDevice:self.backDevice error:&error];
            if (!input) {
                NSLog(@"bad");
                // Handle the error appropriately.
            }
        }
        
        [self.session removeInput:self.captureInput];
        self.captureInput = input;
        [self.session addInput:input];

        // commit the configuration and toggle the frontback bool
        [self.session commitConfiguration];
        self.frontBack = !self.frontBack;
    
    }];
}

- (void)loadCameraButton {

    UIButton *button = [[UIButton alloc]init];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];

    [button addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
    //[button addTarget:self action:@selector(growButtonAnimation:) forControlEvents:UIControlEventTouchDown];
    
    [self setCameraButton:button];
    [self.cameraButton setImage:[UIImage imageNamed:@"camera-100plus.png"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(4,4,4,4)];
    
    [[self view] addSubview:self.cameraButton];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-64]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:54.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:54.0]];
}

- (void)loadBackButton {
    
    UIButton *button = [[UIButton alloc] init];

    
    [button addTarget:self action:@selector(returnToMap:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(growButtonAnimation:) forControlEvents:UIControlEventTouchDown];

    
    [button setImage:[UIImage imageNamed:@"less_then-100.png"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(4,4,4,4)];

    [self setBackButton:button];
    
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[self view] addSubview:self.backButton];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:16]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.0]];
}

- (void) growButtonAnimation: (UIButton*) button {
    
    [UIView animateWithDuration:.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        button.transform = CGAffineTransformMakeScale(1.5,1.5);

    } completion:^(BOOL finished) {
    
        return;
    }];
}


- (IBAction)returnToMap:(id)sender {
    [UIView animateWithDuration:.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backButton.transform = CGAffineTransformMakeScale(1,1);
        
    } completion:^(BOOL finished) {
        [_delegate hideCameraPage];
    }];
}

- (IBAction)takePicture:(id)sender {
    
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
    
    [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != NULL) {
            NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [[UIImage alloc] initWithData:data];
            _imageTaken = [[UIImageView alloc] initWithImage:image];
            self.imageData = data;
            [self configureImageView];
        }
    }];
}

- (void)configureImageView {
    
    [[self view] addSubview:[self imageTaken]];
    _imageTaken.contentMode = UIViewContentModeScaleAspectFill;
    [_imageTaken setFrame:self.view.frame];
    
    _retakeButton = [[UIButton alloc] init];
    [_retakeButton setEnabled:TRUE];
    [_retakeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_retakeButton addTarget:self action:@selector(retakePicture:) forControlEvents:UIControlEventTouchUpInside];
    [_retakeButton setImage:[UIImage imageNamed:@"retake.png"] forState:UIControlStateNormal];
    _retakeButton.alpha = 0;

    
    [[self view] addSubview:_retakeButton];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_retakeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-50]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_retakeButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_retakeButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:30.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_retakeButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:30.0]];
    
    _useButton = [[UIButton alloc] init];
    [_useButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_useButton setEnabled:TRUE];
    [_useButton addTarget:self action:@selector(uploadImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_useButton setImage:[UIImage imageNamed:@"right_arrow.png"] forState:UIControlStateNormal];
    _useButton.alpha = 0;
    
    [[self view] addSubview:_useButton];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_useButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-50]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_useButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-20]];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_useButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:30.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_useButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:30.0]];
    
    [self.cameraButton setHidden:YES];
    [self.backButton setHidden:YES];
    [self.toggleCamButton setHidden:YES];
    
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:.4];
    _retakeButton.alpha = 1;
    _useButton.alpha = 1;

    [UIView commitAnimations];
}

- (IBAction)uploadImageButtonClick:(id)sender {
    [self loadSpinner];
    NSLog(@"Holler");
    [self.delegate haveContributedToFlur:self.pin.pinId];
    
    [self.photoManager loadPhotosWithPin:self.pin withCompletion:^(NSMutableArray *allPhotos) {
        self.allPhotos = allPhotos;
        [self handOffToPhotoVC];
    }];
    
    [self.photoManager uploadPhotoWithData:self.imageData withPin:self.pin withCompletion:^{
        [self handOffToPhotoVC];
    }];
}

- (void) handOffToPhotoVC {

    self.count++;
    if (self.count == 2) {
        NSLog(@"handOffToPhotoVC Running");
        NSLog(@"Pin %lu", (long)self.pin.contentCount);
        if (self.allPhotos.count != self.pin.contentCount) {
            [self.allPhotos addObject: self.imageData];
        }
        NSLog(@"out");
        [self.dataToPass setObject:self.allPhotos forKey:@"allPhotos"];
        NSLog(@"out2");

        [_delegate hideCameraPage];
        [_delegate showPhotoPage:self.dataToPass];

    }
}

-(IBAction)retakePicture:(id)sender {
    
    NSLog(@"retake picture");
    [self.retakeButton removeFromSuperview];
    [self.useButton removeFromSuperview];
    [self.imageTaken removeFromSuperview];
    [self.cameraButton setHidden:NO];
    [self.backButton setHidden:NO];
    [self.toggleCamButton setHidden:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadSpinner {
    
    UIBlurEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    UIVisualEffectView* blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.alpha = 1;
    
    // Vibrancy effect
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [vibrancyEffectView setFrame:self.view.bounds];
    
    
    
    
    // Add the vibrancy view to the blur view
    [[blurEffectView contentView] addSubview:vibrancyEffectView];
    
    // add blur view to view
    blurEffectView.frame = self.view.bounds;
    [self.view addSubview: blurEffectView];
    
    self.spinner = [[UIImageView alloc] init];
    self.spinner.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableArray* frameHolders = [[NSMutableArray alloc] init];
    for(int i=0; i<29; i++) {
        NSString* imageName;
        if (i < 10)
            imageName = [NSString stringWithFormat:@"frame_00%d.gif", i];
        else
            imageName = [NSString stringWithFormat:@"frame_0%d.gif", i];
        
        [frameHolders addObject:[UIImage imageNamed:imageName]];
    }
    
    self.spinner.animationImages = [[NSArray alloc] initWithArray:frameHolders];
    self.spinner.animationDuration = 1.0f;
    self.spinner.animationRepeatCount = 0;
    [self.spinner startAnimating];
    [self.view addSubview:self.spinner];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.spinner
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    // Center Horizontally
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.spinner
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.spinner
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:100.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.spinner
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:100.0]];
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
