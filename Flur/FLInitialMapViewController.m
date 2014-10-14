//
//  FLInitialMapViewController.m
//  Flur
//
//  Created by Lily Hashemi on 10/4/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

@import MapKit;
#import "FLInitialMapViewController.h"
#import "FLFlurAnnotation.h"
#import <Parse/Parse.h>

@interface FLInitialMapViewController () {
    CLLocation *currentLocation;
}

@property (nonatomic, strong, readwrite) MKMapView *mapView;
@property (nonatomic, strong, readwrite) CLLocationManager *locationManager;

@property (nonatomic, strong, readwrite) NSMutableArray *mapAnnotations;
@property (nonatomic, strong, readwrite) UIPopoverController *contributePopover;

@property (nonatomic, strong, readwrite) UIButton *addButton;

@property (nonatomic, readwrite) BOOL haveLoadedFlurs;




@end


@implementation FLInitialMapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.haveLoadedFlurs = false;
    
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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

// Find all flurs nearby based on the users position
- (void)findNearbyFlurs {
   
    CGFloat kilometers = 2; // Must edit
    
    PFQuery *query = [PFQuery queryWithClassName:@"FlurPin"];
    [query setLimit:10];
    [query whereKey:@"location"
       nearGeoPoint:[PFGeoPoint geoPointWithLatitude:_locationManager.location.coordinate.latitude
                                           longitude:_locationManager.location.coordinate.longitude]
                                    withinKilometers:kilometers];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"Num entries %lu", [objects count]);
        if (!error) {
            for (PFObject *object in objects) {
                PFGeoPoint * curLocation = [PFGeoPoint geoPointWithLocation:_locationManager.location];
                double dist = [curLocation distanceInKilometersTo: object[@"location"]];
                NSLog(@"Dist from pin: %f", dist);
                FLFlurAnnotation *annotation = [[FLFlurAnnotation alloc] initWithObject:object];
                [self.mapView addAnnotation:annotation];
            }
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if (!self.haveLoadedFlurs) {
        self.haveLoadedFlurs = true;
        [self findNearbyFlurs];
        //[self findNearbyFlurs];
    }
    
    
    NSLog(@"didUpdateToLocation: %@", newLocation);
    
    if (currentLocation != nil) {
        //longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        //latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
}

- (IBAction)addingFlur:(id)sender {
    
    CLLocation *location = _locationManager.location;
    CLLocationCoordinate2D coordinate = [location coordinate];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                  longitude:coordinate.longitude];
    
    PFObject *flurPin = [PFObject objectWithClassName:@"FlurPin"];
    [flurPin setObject:geoPoint forKey:@"location"];
    [flurPin setObject:@"codemang" forKey:@"username"];

    [flurPin saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) { }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
