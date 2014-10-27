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
@property (nonatomic, strong, readwrite) UIButton *contributeButton;

@property (nonatomic, strong, readwrite) NSMutableDictionary *allAnnotations;

@property (nonatomic, strong, readwrite) NSMutableArray *test;


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
    _allAnnotations = [[NSMutableDictionary alloc] init];
    _test = [[NSMutableArray alloc] init];

    
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
 
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:50]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    UILabel* topBarTitle = [[UILabel alloc] init];
    topBarTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [topBar addSubview:topBarTitle];
    [topBarTitle setText:@"Flur"];
    [topBarTitle setTextColor:[UIColor whiteColor]];
    topBarTitle.backgroundColor = [UIColor clearColor];
    [topBarTitle setTextAlignment:UITextAlignmentCenter];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBarTitle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topBar attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:0]];
    
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
        // update location
        [self.mapManager updateCurrentLocation:newLocation
                            andRefreshLocation:true];
        
        [self.mapManager getViewablePins:^(NSMutableDictionary* allNonOpenablePins) {
            for (id key in allNonOpenablePins) {
                FLPin * pin = [allNonOpenablePins objectForKey:key];
                FLFlurAnnotation *annotation = [[FLFlurAnnotation alloc] initWithPin:pin
                                                                             isAnimated:false];
                [self.allAnnotations setObject:annotation forKey:pin.objectId];
                [self.mapView addAnnotation:annotation];
            }
            
            NSMutableArray *indexes = [self.mapManager getNewlyOpenablePins];
            [self updateAnnotations:indexes isNowOpenable:true];
        }];
    }
    else {
        [self.mapManager updateCurrentLocation:newLocation
                            andRefreshLocation:false];
        
        NSMutableArray *indexes1 = [self.mapManager getNewlyOpenablePins];
        [self updateAnnotations:indexes1 isNowOpenable:true];
        
        NSMutableArray *indexes2 = [self.mapManager getNewlyNonOpenablePins];
        [self updateAnnotations:indexes2 isNowOpenable:false];
    }
    
    
}

- (void) updateAnnotations:(NSMutableArray *)indexes isNowOpenable:(BOOL)isNowOpenable {
    for (NSString* objectId in indexes) {
        FLFlurAnnotation* f = [self.allAnnotations objectForKey:objectId];
        
        if (isNowOpenable) {
            f.isAnimated = true;
            
            [self.mapView viewForAnnotation:f].image = [UIImage imageNamed:@""];
            
            UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
            animatedImageView.tag = 10;
            animatedImageView.animationImages = [NSArray arrayWithObjects:
                                                 [UIImage imageNamed:@"frame_000.gif"],
                                                 [UIImage imageNamed:@"frame_001.gif"],
                                                 [UIImage imageNamed:@"frame_002.gif"],
                                                 [UIImage imageNamed:@"frame_003.gif"], nil];
            animatedImageView.animationDuration = 1.0f;
            animatedImageView.animationRepeatCount = 0;
            [animatedImageView startAnimating];
            [animatedImageView setFrame: CGRectMake(0,0,25,25)];
            
            
            [[self.mapView viewForAnnotation:f] addSubview:animatedImageView];

        }
        else {
            for (UIView *subView in [[self.mapView viewForAnnotation:f] subviews]) {
                if (subView.tag == 10) {
                    [subView removeFromSuperview];
                }
            }
            [self.mapView viewForAnnotation:f].image = [UIImage imageNamed:@"flur_25px.png"];
        }
        
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[appDelegate switchController:@"PhotoViewController"];
    FLFlurAnnotation* fa = view.annotation;
    NSString* id = fa.objectId;
    FLPin* p = [[[self mapManager] openablePins] objectForKey: id];
    [self showOverlay:p];
    return;
}

- (void) showOverlay: (FLPin*) pin {
    
     UIBlurEffect *blurEffect;
     blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
     
     UIVisualEffectView *blurEffectView;
     blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    // Vibrancy effect
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [vibrancyEffectView setFrame:self.view.bounds];
    
    // Label for vibrant text
    UILabel *vibrantLabel = [[UILabel alloc] init];
    [vibrantLabel setText:[pin returnPrompt]];
    [vibrantLabel setTextAlignment:NSTextAlignmentCenter];
    [vibrantLabel setNumberOfLines:0];
    [vibrantLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [vibrantLabel setFont:[UIFont systemFontOfSize:35.0f]];
//    [[vibrantLabel layer] setBorderWidth:2.0];
    [[vibrantLabel layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [vibrantLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  
//    [vibrantLabel sizeToFit];
    
    
    // build button for contributing
    UIButton *contributeButton = [[UIButton alloc] init];
    [contributeButton setTitle:@"Contribute" forState:UIControlStateNormal];
    [[contributeButton titleLabel] setFont:[UIFont systemFontOfSize:30.0]];
    [contributeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[contributeButton layer] setCornerRadius:10];
    [[contributeButton layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[contributeButton layer] setBorderWidth:2.0];
    [contributeButton setEnabled:TRUE];
    [contributeButton setCenter: self.view.center];
    [contributeButton addTarget:self action:@selector(contributingToFlur:) forControlEvents:UIControlEventTouchDown];
    
    [self setContributeButton:contributeButton];
    
    [vibrantLabel sizeToFit];
    
    // add contribute button to vibrancy view
    [[vibrancyEffectView contentView] addSubview:contributeButton];
    
    //setting the layout for the contribute button
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:contributeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-120]];
    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:contributeButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-50]];
    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:contributeButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20]];
    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:contributeButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-20]];
    
    
    // Add label to the vibrancy view
    [[vibrancyEffectView contentView] addSubview:vibrantLabel];
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:vibrantLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeTop multiplier:1 constant:150]];
    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:vibrantLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contributeButton attribute:NSLayoutAttributeTop multiplier:1 constant:-10]];
    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:vibrantLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeLeading multiplier:1 constant:10]];
    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:vibrantLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10]];
    
    
    // Add the vibrancy view to the blur view
    [[blurEffectView contentView] addSubview:vibrancyEffectView];
    
    // add blur view to view
    blurEffectView.frame = self.view.bounds;
    [self.view addSubview:blurEffectView];
    
     /*UIView *back = [[UIView alloc] initWithFrame:self.view.frame];
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
                                                            constant:0.0]];*/
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

- (void) createDisplayForPin: (MKAnnotationView *) annotationView isAnimated:(BOOL) isAnimated {
    if (isAnimated) {
        UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        animatedImageView.animationImages = [NSArray arrayWithObjects:
                                             [UIImage imageNamed:@"frame_000.gif"],
                                             [UIImage imageNamed:@"frame_001.gif"],
                                             [UIImage imageNamed:@"frame_002.gif"],
                                             [UIImage imageNamed:@"frame_003.gif"], nil];
        animatedImageView.animationDuration = 1.0f;
        animatedImageView.animationRepeatCount = 0;
        [animatedImageView startAnimating];
        [animatedImageView setFrame: CGRectMake(0,0,25,25)];
        [annotationView addSubview:animatedImageView];
    }
}

- (IBAction)addingFlur:(id)sender {
    [self.mapManager addFlur];
}

- (IBAction)switchingView:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate switchController:@"PhotoViewController"];
}

- (void) switchController {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate switchController:@"PhotoViewController"];
}

- (IBAction)contributingToFlur:(id)sender {
    NSLog(@"clicked contribute");
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
