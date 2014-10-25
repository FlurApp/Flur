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
#import "FLMapManager.h"
#import "FLPin.h"
#import "AppDelegate.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface FLInitialMapViewController () {
    CLLocation *currentLocation;
}

@property (nonatomic, strong, readwrite) MKMapView *mapView;
@property (nonatomic, strong, readwrite) UIView *mapViewContainer;

@property (nonatomic, strong, readwrite) CLLocationManager *locationManager;

@property (nonatomic, strong, readwrite) NSMutableArray *mapAnnotations;
@property (nonatomic, strong, readwrite) UIPopoverController *contributePopover;

@property (nonatomic, strong, readwrite) UIButton *addButton;
@property (nonatomic, strong, readwrite) UIButton *addButton2;


@property (nonatomic, readwrite) BOOL haveLoadedFlurs;

@property (nonatomic, strong, readwrite) NSMutableArray *viewablePins;
@property (nonatomic, strong, readwrite) PFGeoPoint *PFCurrentLocation;

@property (nonatomic, strong) FLMapManager* mapManager;



@end


@implementation FLInitialMapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.haveLoadedFlurs = false;
    
    _viewablePins = [[NSMutableArray alloc] init];
    _PFCurrentLocation = [[PFGeoPoint alloc] init];
    _mapManager = [[FLMapManager alloc] init];
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    //----Setting up the Location Manager-----//
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager requestAlwaysAuthorization];
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    _locationManager.distanceFilter = 500;
    [_locationManager startUpdatingLocation];
    
    //----loading Initial View----//
    [self loadMapView];
    [self loadTopBar];
    
    
    // Add button
    _addButton = [[UIButton alloc] init];
    [_addButton setTitle:@"Add a Flur" forState:UIControlStateNormal];
    [_addButton setBackgroundColor:[UIColor blueColor]];
    [_addButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_addButton addTarget:self action:@selector(switchingView:) forControlEvents:UIControlEventTouchDown];
    [[self view] addSubview:_addButton];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_addButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:100]];
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_addButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10]];
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_addButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-10]];
    
    /*_addButton2 = [[UIButton alloc] init];
    [_addButton2 setTitle:@"switch views" forState:UIControlStateNormal];
    [_addButton2 setBackgroundColor:[UIColor redColor]];
    [_addButton2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_addButton2 addTarget:self action:@selector(switchingView:) forControlEvents:UIControlEventTouchDown];
    [[self view] addSubview:_addButton2];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_addButton2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_addButton2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:10]];
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_addButton2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];*/

    

    
    

    
    
    
}

- (void)loadMapView {
    self.mapViewContainer = [[UIView alloc] initWithFrame:CGRectZero];
    self.mapViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
  
    self.mapView = [[MKMapView alloc] initWithFrame:self.mapViewContainer.frame];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.mapView setZoomEnabled:YES];
    [self.mapView setPitchEnabled:YES];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    
    
    
    //[[self view] setTranslatesAutoresizingMaskIntoConstraints:NO];
     //[self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.mapViewContainer addSubview:self.mapView];
    

    
    [self.view addSubview:self.mapViewContainer];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:50]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
     
     [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
     
     [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
}

- (void) loadTopBar {
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectZero];
    topBar.translatesAutoresizingMaskIntoConstraints = NO;
    topBar.backgroundColor = [self colorWithHexString:@"3F72F5"];
    [self.view addSubview:topBar];
 
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:50]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    UILabel* topBarTitle = [[UILabel alloc] init];
    topBarTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [topBar addSubview:topBarTitle];
    [topBarTitle setText:@"Flur"];
    [topBarTitle setTextColor:[UIColor whiteColor]];
    topBarTitle.backgroundColor = [UIColor clearColor];
    [topBarTitle setTextAlignment:UITextAlignmentCenter];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBarTitle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBarTitle attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:topBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBarTitle attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:topBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBarTitle attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:topBar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if([self.mapManager shouldRefreshMap]) {
        
        // update the location of last refresh (which is now current location)
        self.mapManager.refreshLocation.latitude = newLocation.coordinate.latitude;
        self.mapManager.refreshLocation.longitude = newLocation.coordinate.longitude;
        
        // update location
        [self.mapManager updateCurrentLocation:newLocation
                            andRefreshLocation:true];
        
        //self.viewablePins = [self.mapManager getViewablePins];
        [self.mapManager getViewablePins:^(NSMutableDictionary* allNonOpenablePins) {
            NSLog(@"All Pins %@", allNonOpenablePins);
            for (FLPin* pin in allNonOpenablePins) {
                FLFlurAnnotation *annotation = [[FLFlurAnnotation alloc] initWithObject:pin];
                NSLog(@"pin %@", pin);

                [self.mapView addAnnotation:annotation];
            }
            // findNewlyOpenable()

        }];
    }
    else {
        // findNewlyOpenable()
        // findNewlyUnopenable()
    }
    
    
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"hey");
    
}

- (void) showOverlay {
     UIVisualEffectView* t = [[UIVisualEffectView alloc] init];
     
     UIVisualEffect *blurEffect;
     blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
     
     UIVisualEffectView *visualEffectView;
     visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
     
     visualEffectView.frame = self.view.bounds;
     [self.view addSubview:visualEffectView];
     
     UIView *back = [[UIView alloc] initWithFrame:self.view.frame];
     [back setTranslatesAutoresizingMaskIntoConstraints:NO];
     back.backgroundColor = RGB(200,200,200);
     back.layer.cornerRadius = 7;
     back.layer.masksToBounds = YES;
     
     [self.view addSubview:back];
     
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:back attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeWidth
                                                          multiplier:0.5
                                                            constant:0]];
     
     // Height constraint, half of parent view height
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:back
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeHeight
                                                          multiplier:0.5
                                                            constant:0]];
     
     // Center horizontally
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:back
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0
                                                            constant:0.0]];
     
     // Center vertically
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:back
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.0
                                                            constant:0.0]];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if([annotation isKindOfClass:[FLFlurAnnotation class]]) {
        FLFlurAnnotation *myLocation = (FLFlurAnnotation *)annotation;
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MyCustomAnnotation"];
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

- (IBAction)addingFlur:(id)sender {
    [self.mapManager addFlur];
}

- (IBAction)switchingView:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate switchController:@"PhotoViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (UIColor*) colorWithHexString:(NSString*)hex {
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
