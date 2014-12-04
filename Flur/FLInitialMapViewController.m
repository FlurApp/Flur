//
//  FLInitialMapViewController.m
//  Flur
//
//  Created by Lily Hashemi on 10/4/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

@import MapKit;

#import <Parse/Parse.h>

#import "FLInitialMapViewController.h"
#import "FLFlurAnnotation.h"
#import "FLPin.h"
#import "LocalStorage.h"
#import "FLConstants.h"

@interface FLInitialMapViewController () {
    CLLocation *currentLocation;
}

@property (nonatomic, strong, readwrite) MKMapView *mapView;
@property (nonatomic, strong, readwrite) UIView *mapViewContainer;

@property (nonatomic, strong, readwrite) CLLocationManager *locationManager;

@property (nonatomic, strong, readwrite) UIPopoverController *contributePopover;

@property (nonatomic, strong, readwrite) UIButton *contributeButton;
@property (nonatomic, strong, readwrite) UIVisualEffectView *blurEffectView;
@property (nonatomic, strong, readwrite) UIVisualEffectView *addPinBlurEffectView;
@property (nonatomic, strong, readwrite) UITextField *promptTextField;


@property (nonatomic, strong, readwrite) NSMutableDictionary *allAnnotations;

@property (nonatomic, strong, readwrite) NSMutableArray *test;


@property (nonatomic, readwrite) BOOL haveLoadedFlurs;

@property (nonatomic, strong, readwrite) NSMutableArray *viewablePins;
@property (nonatomic, strong, readwrite) PFGeoPoint *PFCurrentLocation;

@property (nonatomic, strong) NSMutableArray *myContrPins;
@property (nonatomic, strong) UIView *whiteLayer;


@end

@implementation FLInitialMapViewController

- (instancetype) initWithData:(NSMutableDictionary *)data {
    self = [super init];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.haveLoadedFlurs = false;
    
    _viewablePins = [[NSMutableArray alloc] init];
    _PFCurrentLocation = [[PFGeoPoint alloc] init];
    _mapManager = [[FLMapManager alloc] init];
    _allAnnotations = [[NSMutableDictionary alloc] init];
    _test = [[NSMutableArray alloc] init];

    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    //----Setting up the Location Manager-----//
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;

    [self.locationManager requestAlwaysAuthorization];
    
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    _locationManager.distanceFilter = 3;
    [_locationManager startUpdatingLocation];
    
    //----loading Initial View----//
    self.whiteLayer = [[UIView alloc] init];
    [self.whiteLayer setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.whiteLayer.backgroundColor = RGBA(255, 255, 255, 0);
    
    [self loadMapView];

    [self setNeedsStatusBarAppearanceUpdate];


    
   }

-(void)viewDidAppear:(BOOL)animated {
   
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)
        self.mapView.showsUserLocation = YES;
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
    
    
    [self.mapViewContainer addSubview:self.mapView];
    
    [self.view addSubview:self.mapViewContainer];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
     
     [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
     
     [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void) updateOpenablePins {
    NSMutableArray *indexes = [self.mapManager getNewlyOpenablePins];
    [self updateAnnotations:indexes isNowOpenable:true];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKAnnotationView* annotationView = [mapView viewForAnnotation:userLocation];
    mapView.userLocation.title = @"";
    annotationView.canShowCallout = NO;
}

- (void) reloadMap {
    
    [self.allAnnotations removeAllObjects];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    
    [self.mapManager getViewablePins:^(NSMutableDictionary* allViewablePins) {
        for (id key in allViewablePins) {
            FLPin * pin = [allViewablePins objectForKey:key];
            FLFlurAnnotation *annotation = [[FLFlurAnnotation alloc] initWithPin:pin];
            [self.allAnnotations setObject:annotation forKey:pin.pinId];
            [self.mapView addAnnotation:annotation];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    NSLog(@"New location: %@", newLocation);
    
    [self.mapManager updateCurrentLocation:newLocation
                        andRefreshLocation:false];
    
    if ([self.mapManager shouldRefreshMap]) {
     
        [self.mapManager updateCurrentLocation:newLocation
                            andRefreshLocation:true];
        [self reloadMap];
    }
    else {
        
        [self.mapManager updateCurrentLocation:newLocation
                            andRefreshLocation:false];
        
        [self updateAnnotations:[self.mapManager getNewlyOpenablePins] isNowOpenable:true];
        [self updateAnnotations:[self.mapManager getNewlyNonOpenablePins] isNowOpenable:false];
    }
}

- (void) updateAnnotations:(NSMutableArray *)indexes isNowOpenable:(BOOL)isNowOpenable {
    for (NSString* pinId in indexes) {
        FLFlurAnnotation* f = [self.allAnnotations objectForKey:pinId];

        if (isNowOpenable) {
            [f showAnnotationAsOpenable:[self.mapView viewForAnnotation:f]];
        }
        else {
            [f showAnnotationAsNonOpenable:[self.mapView viewForAnnotation:f]];
        }
        
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    id<MKAnnotation> annotation = view.annotation;
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        view.selected = NO;
        return;
    }
}

- (void) didSelectAnnotationView_custom:(MKAnnotationView *)view
{

    FLFlurAnnotation* fa = view.annotation;
    NSLog(@"Clicked: %@", fa.pin.pinId);
    
    if (fa.pin.pinId) {
        
        NSString* id = fa.pin.pinId;
        FLPin* p = [[[self mapManager] openablePins] objectForKey: id];
        if (p) {
            NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
            [data setObject:p forKey:@"FLPin"];
            [data setObject:p.pinId forKey:@"pinId"];
            [data setObject:@"true" forKey:@"contributeView"];
            [data setObject:[(PFUser *)p.createdBy username] forKey:@"creatorUsername"];
            [data setObject:p.dateCreated forKey:@"dateCreated"];
            [data setObject:[NSNumber numberWithInteger:p.totalContentCount] forKey:@"totalContentCount"];
            
            NSString *haveContributedTo = p.haveContributedTo ? @"true" : @"false";
            [data setObject:haveContributedTo forKey:@"haveContributedTo"];

            [self.delegate showContributePage:data];
        }
    }
    return;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[FLFlurAnnotation class]]) {
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

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField insertText:@" "];
    [textField setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:20]];
    [textField setTextColor:[UIColor whiteColor]];
}


-(void)textFieldDidEndEditing:(UITextField *)textField {
    [textField setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:20]];
    [textField setTextColor:[UIColor whiteColor]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void) addFlur:(NSString*)prompt {
    NSLog(@"adding flur");
    [self.mapManager addFlur:prompt];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void) showWhiteLayer {
    [self.view addSubview:self.whiteLayer];
    self.whiteLayer.frame = self.view.frame;
    [UIView animateWithDuration:.2 animations:^{
        self.whiteLayer.backgroundColor = RGBA(255, 255, 255, .6);
    }];
}

- (void) hideWhiteLayer {
    [self.whiteLayer removeFromSuperview];
    self.whiteLayer.backgroundColor = RGBA(255, 255, 255, 0);
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        
        long dist;
        long minDist = HUGE_VALF;
        [self.delegate hideSettingsPage];
      
            
        // flur annotation
        FLFlurAnnotation * fa;
        
        // closest annotation holder
        FLFlurAnnotation * ca = nil;
        
        // tp = touch point, fp = flur point, cap = closest annotation point
        CGPoint tp, fp, cap;
        
        // for every openable pin
        for (NSString* pin in self.mapManager.openablePins) {
            
            // get the pin's annotation
            fa = [self.allAnnotations objectForKey:pin];
            
            // get the touch location
            tp = [touch locationInView:self.view];
            
            // convert coordinates to screen point b.c. getting frame/bounds doesnt work
            fp = [self.mapView convertCoordinate:fa.coordinate toPointToView:self.mapView];
            
            // calculate distance between
            long xDist = tp.x - fp.x;
            long yDist = tp.y - fp.y;
            dist = sqrt(xDist*xDist + yDist*yDist);
            
            if (dist < minDist) {
                minDist = dist;
                ca = fa;
                cap = fp;
            }
        }
        
        // if we got atleast one openable pin to check
        if (ca) {
            // draw rect around the closest annotation to the touch
            CGRect fap = CGRectMake(cap.x- (annotationTargetSize/2),
                                    cap.y- (annotationTargetSize/2),
                                    annotationTargetSize,
                                    annotationTargetSize);
            
            // if the closest target area contains our touch point
            // then select associated annotation
            if (CGRectContainsPoint(fap, tp)) {
                [self didSelectAnnotationView_custom:ca.annotationView];
            }
        }
    }
}

- (void) addNewFlur:(FLPin *)pin {
    FLFlurAnnotation *annotation = [[FLFlurAnnotation alloc] initWithPin:pin];
    [self.allAnnotations setObject:annotation forKey:pin.pinId];
    [self.mapView addAnnotation:annotation];
    
    [self.mapManager addNewFlur:pin];
}

- (void) justContributedToFlur:(NSString *) objectId {
    FLFlurAnnotation* annotation = (FLFlurAnnotation *)self.allAnnotations[@"objectId"];
    [annotation showAnnotationAsOpenable:[self.mapView viewForAnnotation:annotation]];

    [self.mapManager justContributedToFlur:objectId];

}

@end
