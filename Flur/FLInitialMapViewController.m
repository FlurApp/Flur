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
#import "FLMasterNavigationController.h"
#import "FLFlurAnnotation.h"
#import "FLMapManager.h"
#import "FLPin.h"
#import "FLButton.h"
#import "LocalStorage.h"
#import "FLConstants.h"

@interface FLInitialMapViewController () {
    CLLocation *currentLocation;
}

@property (nonatomic, strong, readwrite) MKMapView *mapView;
@property (nonatomic, strong, readwrite) UIView *mapViewContainer;

@property (nonatomic, strong, readwrite) CLLocationManager *locationManager;

@property (nonatomic, strong, readwrite) UIPopoverController *contributePopover;

@property (nonatomic, strong, readwrite) FLButton *contributeButton;
@property (nonatomic, strong, readwrite) UIVisualEffectView *blurEffectView;
@property (nonatomic, strong, readwrite) UIVisualEffectView *addPinBlurEffectView;
@property (nonatomic, strong, readwrite) UITextField *promptTextField;


@property (nonatomic, strong, readwrite) NSMutableDictionary *allAnnotations;

@property (nonatomic, strong, readwrite) NSMutableArray *test;


@property (nonatomic, readwrite) BOOL haveLoadedFlurs;

@property (nonatomic, strong, readwrite) NSMutableArray *viewablePins;
@property (nonatomic, strong, readwrite) PFGeoPoint *PFCurrentLocation;

@property (nonatomic, strong) FLMapManager* mapManager;

@property (nonatomic, strong) NSMutableArray *myContrPins;

@end

@implementation FLInitialMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
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
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    _locationManager.distanceFilter = 3;
    [_locationManager startUpdatingLocation];
    
    //----loading Initial View----//
    [self loadMapView];
    [self loadTopBar];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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

- (void) loadTopBar {
    UIView *topBarContainer = [[UIView alloc] init];
    topBarContainer.translatesAutoresizingMaskIntoConstraints = NO;
    topBarContainer.backgroundColor = [UIColor redColor];

    [self.view addSubview:topBarContainer];
 
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBarContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBarContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:80]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBarContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBarContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = topBarContainer.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[RGBA(186,108,224, 1) CGColor], (id)[RGBA(179, 88, 224, 1) CGColor], nil];
    
//    [gradient setShadowOffset:CGSizeMake(1, 1)];
//    [gradient setShadowColor:[[UIColor blackColor] CGColor]];
//    [gradient setShadowOpacity:0.5];

    
    [topBarContainer.layer insertSublayer:gradient atIndex:0];
    
    CAGradientLayer *shadow = [CAGradientLayer layer];
    shadow.frame = CGRectMake(0, topBarContainer.frame.origin.y + topBarContainer.frame.size.height, self.view.frame.size.width, 3);
    shadow.colors = [NSArray arrayWithObjects:(id)[RGBA(100,100,100,.9) CGColor], (id)[RGBA(255,255,255,0) CGColor], nil];
    [topBarContainer.layer insertSublayer:shadow atIndex:1];


    

    // add flur button
    self.tableListButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.tableListButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.tableListButton.tag = 1;
    [self.tableListButton addTarget:self action:@selector(btnMovePanelLeft:)
              forControlEvents:UIControlEventTouchUpInside];
    //[self.tableListButton addTarget:self action:@selector(addingFlur:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview: self.tableListButton];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.tableListButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topBarContainer attribute:NSLayoutAttributeTop multiplier:1 constant:33]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.tableListButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:topBarContainer attribute:NSLayoutAttributeTrailing multiplier:1 constant:-17]];
    
    // make menu button
    self.menuButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.menuButton = [[UIButton alloc] init];
    self.menuButton.tag = 1;
    [self.menuButton addTarget:self action:@selector(btnMovePanelRight:)
                                    forControlEvents:UIControlEventTouchUpInside];
    self.menuButton.backgroundColor = [UIColor clearColor];
    
    // create image for menu button
    UIImage* hamburger = [UIImage imageNamed:@"menu-32.png"];
    CGRect rect = CGRectMake(0,0,75,75);
    UIGraphicsBeginImageContext(rect.size);
    [hamburger drawInRect:rect];
    UIImage *hamburgerResized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(hamburgerResized);
    UIImage *menuImg = [UIImage imageWithData:imageData];
    
    // set image for menu button
    [self.menuButton setImage:menuImg forState:UIControlStateNormal];
    [self.menuButton setContentMode:UIViewContentModeCenter];
    [self.menuButton setImageEdgeInsets:UIEdgeInsetsMake(25,25,25,25)];
    
    // add menu button to view
    [self.menuButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[self view] addSubview:self.menuButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topBarContainer attribute:NSLayoutAttributeTop multiplier:1.0 constant:8]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:topBarContainer attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-8]];
    
    
    UIImage *flurImage = [UIImage imageNamed:@"flurfont.png"];
    UIImageView *flurImageContainer = [[UIImageView alloc] initWithImage:flurImage];
    flurImageContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [topBarContainer addSubview:flurImageContainer];
    
    [topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:flurImageContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topBarContainer attribute:NSLayoutAttributeTop multiplier:1.0 constant:25]];
    
    [topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:flurImageContainer attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:topBarContainer attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:flurImageContainer
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:30.0]];
    [topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:flurImageContainer
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:60.0]];

    
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

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self.mapManager updateCurrentLocation:newLocation
                        andRefreshLocation:false];
    
    if([self.mapManager shouldRefreshMap]) {
     
        [self.allAnnotations removeAllObjects];
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        [self.mapManager updateCurrentLocation:newLocation
                            andRefreshLocation:true];
        
        [self.mapManager getViewablePins:^(NSMutableDictionary* allNonOpenablePins) {
            for (id key in allNonOpenablePins) {
                FLPin * pin = [allNonOpenablePins objectForKey:key];
                FLFlurAnnotation *annotation = [[FLFlurAnnotation alloc] initWithPin:pin];
                [self.allAnnotations setObject:annotation forKey:pin.pinId];
                [self.mapView addAnnotation:annotation];
            }
        }];
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
    if(fa.pin.pinId) {
        NSString* id = fa.pin.pinId;
        FLPin* p = [[[self mapManager] openablePins] objectForKey: id];
       //  NSLog(@"now");
        if(p) {
            // NSLog(@"hello");
            NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
            [data setObject:p forKey:@"FLPin"];

            // add contribute view (it handles the status bar too)
            self.contributeController = [[FLContributeViewController alloc] initWithData:data];
            UIView *contrView = self.contributeController.view;
            [self.view addSubview: contrView];
            
           // NSLog(@"finally");
        }
    }
    return;
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

- (IBAction)creatingFlur:(id)sender {
    
    NSString *prompt = [self.promptTextField text];
    NSLog(@"Creating flur with prompt: %@", prompt);
    [self.mapManager addFlur:prompt];
    [self.addPinBlurEffectView removeFromSuperview];
    
    //PUT CODE IN FOR REFRESHING THE VIEW///
    [self updateOpenablePins];
    
}

- (IBAction)addingFlur:(id)sender {
    NSLog(@"adding flur");
    // [self showAddPromptToNewFlurOverlay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)exitBlur:(UITapGestureRecognizer *)recognizer {
    [self.blurEffectView removeFromSuperview];
}

- (void)exitEnterPromptBlur:(UITapGestureRecognizer *)recognizer {
    
    if ([self.promptTextField isFirstResponder]) {
        [self.promptTextField resignFirstResponder];
    }
    else {
        [self.addPinBlurEffectView removeFromSuperview];
    }
}

- (void) removeBlur {
    [self.blurEffectView removeFromSuperview];
}

- (IBAction)btnMovePanelRight:(id)sender
{
    
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            [_delegate movePanelToOriginalPosition];
            break;
        }
            
        case 1: {
            [_delegate movePanelRight];
            break;
        }
            
        default:
            break;
    }
}

- (IBAction)btnMovePanelLeft:(id)sender
{
    
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            [_delegate movePanelToOriginalPosition];
            break;
        }
            
        case 1: {
            [_delegate movePanelLeft];
            break;
        }
            
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        
        long dist;
        long minDist = HUGE_VALF;
        
        // If we are in the hamburger/side view - any touch on map panel moves us back
        if (self.menuButton.tag == 0) {
            [self btnMovePanelRight:self.menuButton];
        }
        else {
            
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
}

@end
