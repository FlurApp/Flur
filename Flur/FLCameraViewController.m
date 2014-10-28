//
//  FLCameraViewController.m
//  Flur
//
//  Created by David Lee on 10/26/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import "FLCameraViewController.h"
#import "AppDelegate.h"
#import "FLButton.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface FLCameraViewController ()

@property (nonatomic, readwrite) FLPin* pin;

@property (nonatomic) AVCaptureDevice* device;
@property (nonatomic) AVCaptureSession* session;
@property (nonatomic, readwrite) AVCaptureOutput* captureOutput;
@property (nonatomic, readwrite) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, readwrite) UIButton* cameraButton;
@property (nonatomic, readwrite) UIButton* retakeButton;
@property (nonatomic, readwrite) UIButton* useButton;
@property (nonatomic, readwrite) UIImageView* imageTaken;

@property (nonatomic, strong) NSMutableArray* allPhotos;
@property (nonatomic, strong) NSMutableDictionary* dataToPass;

@property (nonatomic) int count;




@end

@implementation FLCameraViewController {
    BOOL retake;
    NSData *imageData;
}

- (id)initWithPin:(FLPin *)pin {
    self = [super init];
    if (self) {
        self.pin = pin;
        self.count = 0;
        self.dataToPass = [[NSMutableDictionary alloc] init];
        self.allPhotos = [[NSMutableArray alloc] init];
    }
    
    NSLog(@"PIN2: %@", self.pin);
    return self;
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
            imageData = data;
            [self configureImageView];
        }
    }];
    
}

- (void)configureImageView {
    
    [[self view] addSubview:[self imageTaken]];
    [_imageTaken setFrame:self.view.frame];
    
    _retakeButton = [[UIButton alloc] init];
    [_retakeButton setTitle:@"Retake" forState:UIControlStateNormal];
    [_retakeButton setEnabled:TRUE];
    [_retakeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_retakeButton addTarget:self action:@selector(retakePicture:) forControlEvents:UIControlEventTouchDown];
    
    [[self view] addSubview:_retakeButton];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_retakeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-50]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_retakeButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20]];
    
    _useButton = [[UIButton alloc] init];
    [_useButton setTitle:@"Use Photo" forState:UIControlStateNormal];
    [_useButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_useButton setEnabled:TRUE];
    [_useButton addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchDown];
    
    [[self view] addSubview:_useButton];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_useButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-50]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_useButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-20]];
    
}

- (IBAction)uploadImage:(id)sender {
    [self loadPhotos];
    
    PFFile *imageFile = [PFFile fileWithName:@"t.gif" data:imageData];

    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFObject *userPhoto = [PFObject objectWithClassName:@"Images"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            [userPhoto setObject:self.pin.pinId forKey:@"pinId"];
            
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
                else {
                    [self.dataToPass setObject:imageData forKey:@"uploadedPhoto"];
                    [self handOffToPhotoVC];
                }
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        //HUD.progress = (float)percentDone/100;
    }];
    
    
    //Now switch views to PhotoViewController for the Pin
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate switchController:@"PhotoViewController" withPin:[self pin]];
}

- (void) loadPhotos {
    
    // Create the query
    PFQuery *query = [PFQuery queryWithClassName:@"Images"];
    [query whereKey:@"pinId" equalTo:self.pin.pinId];
    [query orderByAscending:@"createdAt"];
    
    // Run query to download all relevant photos
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            // Iterate over all objects and download corresponding data
            for (PFObject *object in objects) {
                PFFile *imageFile = [object objectForKey:@"imageFile"];
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        [self.allPhotos addObject:data];
                    }
                    else {
                        NSLog(@"fuck me");
                    }
                    
                    if ([object isEqual:[objects lastObject]]) {
                        [self.dataToPass setObject:self.allPhotos forKey:@"downloadedPhotos"];
                        [self handOffToPhotoVC];
                    }
                }];
                
            }
        }
    }];
    
}
    
- (void) handOffToPhotoVC {
    self.count++;
    if (self.count == 2) {
        // Check that there are no duplicates and that the uploaded image is there
        [AppDelegate switchViewController:@"PhotoViewController" withData:self.dataToPass];
    }
}

-(IBAction)retakePicture:(id)sender {
    
    NSLog(@"retake picture");
    [_retakeButton removeFromSuperview];
    [_useButton removeFromSuperview];
    [_imageTaken removeFromSuperview];
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
