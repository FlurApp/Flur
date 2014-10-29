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
@property (nonatomic, readwrite) UIButton* backButton;
@property (nonatomic, readwrite) UIImageView* imageTaken;
@property (strong, nonatomic) UIImageView * spinner;


@property (nonatomic, strong) NSMutableArray* allPhotos;
@property (nonatomic, strong) NSMutableDictionary* dataToPass;
@property (nonatomic, strong) NSData *imageData;


@property (nonatomic) int count;




@end

@implementation FLCameraViewController {
    BOOL retake;
}

- (id)initWithData:(NSMutableDictionary *)data {
    self = [super init];
    if (self) {
        FLPin *pin = [data objectForKey:@"FLPin"];
        self.pin = pin;
        self.count = 0;
        self.allPhotos = [[NSMutableArray alloc] init];
        self.dataToPass = [[NSMutableDictionary alloc] init];
        [self.dataToPass setObject:pin forKey:@"FLPin"];


    }
    
    NSLog(@"PIN2: %@", self.pin);
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self view] setBackgroundColor:[UIColor blackColor]];
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];


    
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
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    
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
    
    
    return;
}

- (void)loadCameraButton {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[button layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[button layer] setBorderWidth:2.0];
    [button addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchDown];
    [self setCameraButton:button];
    
    [[self view] addSubview:self.cameraButton];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_cameraButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-50]];
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_cameraButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];

}

- (void)loadBackButton {
    
    UIButton *button = [[UIButton alloc] init];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(returnToMap:) forControlEvents:UIControlEventTouchDown];
    [self setBackButton:button];
    
    [[self view] addSubview:self.backButton];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_backButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:20]];
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_backButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-5]];
}

- (IBAction)returnToMap:(id)sender {
    
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
    _imageTaken.contentMode = UIViewContentModeScaleAspectFit;
    [_imageTaken setFrame:self.view.frame];
    
    _retakeButton = [[UIButton alloc] init];
    [_retakeButton setEnabled:TRUE];
    [_retakeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_retakeButton addTarget:self action:@selector(retakePicture:) forControlEvents:UIControlEventTouchDown];
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
    [_useButton addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchDown];
    [_useButton setImage:[UIImage imageNamed:@"uploadPhoto.png"] forState:UIControlStateNormal];
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
    
    [_cameraButton setHidden:YES];
    
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:.4];
    _retakeButton.alpha = 1;
    _useButton.alpha = 1;

    [UIView commitAnimations];
}

- (IBAction)uploadImage:(id)sender {
    [self loadPhotos];
    
    PFFile *imageFile = [PFFile fileWithName:@"t.gif" data:self.imageData];

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
                    
                    self.pin.contentCount++;
                    PFObject* flurPin = [PFObject objectWithoutDataWithClassName:@"FlurPin" objectId:self.pin.pinId];
                    [flurPin incrementKey:@"contentCount"];
                    [flurPin save];
                    
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
    [self loadSpinner];
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
            int i = 0;
            for (PFObject *object in objects) {
                i++;
                PFFile *imageFile = [object objectForKey:@"imageFile"];
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        [self.allPhotos addObject:data];
                    }
                    else {
                        NSLog(@"fack me");
                    }
                    
                    if (i == objects.count) {
                        NSLog(@"ready to go");
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
        NSLog(@"hey");
        NSLog(@"Pin %lu", (long)self.pin.contentCount);
        if (self.allPhotos.count != self.pin.contentCount) {
            [self.allPhotos addObject: self.imageData];
        }
        NSLog(@"out");
        [self.dataToPass setObject:self.allPhotos forKey:@"allPhotos"];
        NSLog(@"out2");


        
        // Check that there are no duplicates and that the uploaded image is there
        // [AppDelegate switchViewController:@"PhotoViewController" withData:self.dataToPass];
        [AppDelegate switchViewController:@"PhotoViewController" withData:self.dataToPass];

    }
 
}

-(IBAction)retakePicture:(id)sender {
    
    NSLog(@"retake picture");
    [_retakeButton removeFromSuperview];
    [_useButton removeFromSuperview];
    [_imageTaken removeFromSuperview];
    [_cameraButton setHidden:NO];
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
