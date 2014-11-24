//
//  FLFlurInfoViewController.m
//  Flur
//
//  Created by Netanel Rubin on 11/23/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import "FLFlurInfoViewController.h"
#import "UILabel+MultiColor.h"
#import "FLFlurAnnotation.h"
#import "FLPin.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@interface FLFlurInfoViewController ()

@property (nonatomic, strong) UIButton *viewAlbum;
@property (nonatomic, strong) UIView *flurInfoContainer;

@property (nonatomic, strong) UIView *mapViewContainer;
@property (nonatomic, strong, readwrite) MKMapView *mapView;

@property (nonatomic, strong) UILabel *flurCreated;
@property (nonatomic, strong) UILabel *yourContribution;
@property (nonatomic, strong) UILabel *totalContributions;



@property (nonatomic) NSInteger topBarHeight;
@property (nonatomic) NSInteger flurInfoHeight;
@property (nonatomic) NSInteger mapHeight;
@property (nonatomic) NSInteger buttonHeight;

@property (nonatomic, strong) FLPin *pin;





@end

@implementation FLFlurInfoViewController

- (instancetype) initWithData:(NSMutableDictionary *) data {
    self = [super init];
    if (self) {
        self.pin = [data objectForKey:@"pin"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topBarHeight = 80;
    self.buttonHeight = 80;
    self.flurInfoHeight = self.mapHeight = (self.view.frame.size.height - self.topBarHeight - self.buttonHeight)/2;
    
    NSLog(@"Height %lu", self.flurInfoHeight);
    
    self.flurInfoContainer = [[UIView alloc] init];
    self.flurInfoContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.flurInfoContainer.backgroundColor = RGB(253, 253, 253);
    [self.view addSubview:self.flurInfoContainer];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.flurInfoContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.topBarHeight]];
//    
//    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.flurInfoContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.flurInfoHeight]];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.flurInfoContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.flurInfoContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    
    
    self.flurCreated = [[UILabel alloc] init];
    [self.flurCreated setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.flurCreated.text = @"@davmlee created this flur on Aug 3, 2014.";
    self.flurCreated.font = [UIFont fontWithName:@"Avenir-Light" size:19];

    [self.flurCreated setNumberOfLines:0];

    [self.flurCreated setTextColor:RGB(13, 191, 255) range:NSMakeRange(0, 8)];
    [self.flurInfoContainer addSubview:self.flurCreated];
    
    
      [self.flurInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.flurCreated attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.flurInfoContainer attribute:NSLayoutAttributeTop multiplier:1.0 constant:15]];
    
    [self.flurInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.flurCreated attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.flurInfoContainer attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15]];
    
    [self.flurInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.flurCreated attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.flurInfoContainer attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-15]];
    
    
    self.yourContribution = [[UILabel alloc] init];
    [self.yourContribution setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.yourContribution.text = @"You were the 7th person to contribute to this flur.";
    self.yourContribution.font = [UIFont fontWithName:@"Avenir-Light" size:19];
    
    [self.yourContribution setNumberOfLines:0];
    
    [self.yourContribution setTextColor:RGB(232,72,49) range:NSMakeRange(13, 3)];
    [self.flurInfoContainer addSubview:self.yourContribution];
    
    
    [self.flurInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.yourContribution attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.flurCreated attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15]];
    
    [self.flurInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.yourContribution attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.flurInfoContainer attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15]];
    
    [self.flurInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.yourContribution attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.flurInfoContainer attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-15]];
    
    
    
    self.totalContributions = [[UILabel alloc] init];
    [self.totalContributions setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.totalContributions.text = @"9 other people have contributed to this flur.";
    self.totalContributions.font = [UIFont fontWithName:@"Avenir-Light" size:19];
    
    [self.totalContributions setNumberOfLines:0];
    
    [self.totalContributions setTextColor:RGB(238, 0, 255) range:NSMakeRange(0, 1)];
    [self.flurInfoContainer addSubview:self.totalContributions];
    
    
    [self.flurInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.totalContributions attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.yourContribution attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15]];
    
    [self.flurInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.totalContributions attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.flurInfoContainer attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15]];
    
    [self.flurInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.totalContributions attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.flurInfoContainer attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-15]];

    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.flurInfoContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.totalContributions attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15]];
    
    
    self.mapViewContainer = [[UIView alloc] initWithFrame:CGRectZero];
    self.mapViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.mapViewContainer.frame];
    self.mapView.delegate = self;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.mapView setZoomEnabled:YES];
    [self.mapView setPitchEnabled:YES];
    [self.mapView setShowsUserLocation:NO];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    
    
    [self.mapViewContainer addSubview:self.mapView];
    
    [self.view addSubview:self.mapViewContainer];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.flurInfoContainer attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
     [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.buttonHeight]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    FLFlurAnnotation *annotation = [[FLFlurAnnotation alloc] initWithPin:self.pin
                                                              isAnimated:false];
    [self.mapView addAnnotation:annotation];

    
    self.viewAlbum = [[UIButton alloc] init];
    [self.viewAlbum setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.viewAlbum.backgroundColor = RGB(100,100,100);
    self.viewAlbum.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18];
    [self.viewAlbum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.viewAlbum setTitle:@"View Album" forState:UIControlStateNormal];
    
    [self.view addSubview:self.viewAlbum];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.viewAlbum attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.viewAlbum attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.viewAlbum attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.viewAlbum attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if([annotation isKindOfClass:[FLFlurAnnotation class]]) {
        FLFlurAnnotation *myLocation = (FLFlurAnnotation *)annotation;
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MyCustomAnnotation"];
        if (annotation == mapView.userLocation) {
            myLocation.annotationView.enabled = false;
        }
        if (annotationView == nil) {
            annotationView = myLocation.annotationView;
        }
        else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    else
        return nil;
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *ulv = [mapView viewForAnnotation:mapView.userLocation];
    ulv.hidden = YES;
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