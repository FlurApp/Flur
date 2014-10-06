//
//  FLInitialMapViewController.m
//  Flur
//
//  Created by Lily Hashemi on 10/4/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

@import MapKit;
#import "FLInitialMapViewController.h"

@interface FLInitialMapViewController ()

@property (nonatomic, strong, readwrite) MKMapView *mapView;
@property (nonatomic, strong, readwrite) CLLocationManager *locationManager;

@property (nonatomic, strong, readwrite) NSMutableArray *mapAnnotations;
@property (nonatomic, strong, readwrite) UIPopoverController *contributePopover;

@property (nonatomic, strong, readwrite) UIButton *addButton;

@end

@implementation FLInitialMapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    //----Setting up the Location Manager-----//
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager requestAlwaysAuthorization];
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    _locationManager.distanceFilter = 500;
    [_locationManager startUpdatingLocation];
    
    //----loading Map View----//
    [self loadMapView];
    _addButton = [[UIButton alloc] init];
    [_addButton setTitle:@"Add a Flur" forState:UIControlStateNormal];
    [_addButton setBackgroundColor:[UIColor blueColor]];
    [_addButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_addButton addTarget:self action:@selector(addingFlur:) forControlEvents:UIControlEventTouchDown];
    [[self view] addSubview:_addButton];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_addButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_mapView attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_addButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10]];
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_addButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-10]];
    
    
    self.mapAnnotations = [[NSMutableArray alloc] init];
}

- (void)loadMapView {
    _mapView = [[MKMapView alloc] init];
    [_mapView setDelegate:self];
    
    [_mapView setZoomEnabled:YES];
    [_mapView setPitchEnabled:YES];
    [_mapView setShowsUserLocation:YES];
    [_mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    
    [[self view] addSubview:_mapView];
    
    [[self view] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:1]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-50]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_mapView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:1.0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_mapView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:1.0]];
}

- (IBAction)addingFlur:(id)sender {
    NSLog(@"adding a flur");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
