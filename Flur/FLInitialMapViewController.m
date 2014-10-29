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
#import "FLButton.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface FLInitialMapViewController () {
    CLLocation *currentLocation;
}

@property (nonatomic, strong, readwrite) MKMapView *mapView;
@property (nonatomic, strong, readwrite) UIView *mapViewContainer;

@property (nonatomic, strong, readwrite) CLLocationManager *locationManager;

@property (nonatomic, strong, readwrite) UIPopoverController *contributePopover;

@property (nonatomic, strong, readwrite) UIButton *addFlurButton;
@property (nonatomic, strong, readwrite) FLButton *contributeButton;
@property (nonatomic, strong, readwrite) UIVisualEffectView *blurEffectView;


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
    [_locationManager requestAlwaysAuthorization];
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    _locationManager.distanceFilter = 3;
    [_locationManager startUpdatingLocation];
    
    //----loading Initial View----//
    [self loadMapView];
    [self loadTopBar];
    
    [self setNeedsStatusBarAppearanceUpdate];
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
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:50]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
     
     [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
     
     [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
}

- (void) loadTopBar {
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectZero];
    topBar.translatesAutoresizingMaskIntoConstraints = NO;
    //topBar.backgroundColor = RGB(166, 219, 245);
    //topBar.backgroundColor = RGB(86, 165, 204);
    //topBar.backgroundColor = [self colorWithHexString:@"3f72f5 "];
    topBar.backgroundColor = RGB(106, 147, 217);
   // topBar.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"texture1.jpg"]];


    [self.view addSubview:topBar];
 
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:70]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    


    // add flur button
    UIButton* addFlurButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [addFlurButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [addFlurButton addTarget:self action:@selector(addingFlur:) forControlEvents:UIControlEventTouchDown];
    
    [self setAddFlurButton:addFlurButton];
    [self.view addSubview: self.addFlurButton];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:addFlurButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topBar attribute:NSLayoutAttributeTop multiplier:1 constant:30]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:addFlurButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:topBar attribute:NSLayoutAttributeTrailing multiplier:1 constant:-15]];
    
    
    UIImage *flurImage = [UIImage imageNamed:@"flurfont.png"];
    UIImageView *flurImageContainer = [[UIImageView alloc] initWithImage:flurImage];
    flurImageContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [topBar addSubview:flurImageContainer];
    
    [topBar addConstraint:[NSLayoutConstraint constraintWithItem:flurImageContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:25]];
    
    [topBar addConstraint:[NSLayoutConstraint constraintWithItem:flurImageContainer attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:topBar attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [topBar addConstraint:[NSLayoutConstraint constraintWithItem:flurImageContainer
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:30.0]];
    [topBar addConstraint:[NSLayoutConstraint constraintWithItem:flurImageContainer
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
    NSLog(@"Location:%f, %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"moved");
    [self.mapManager updateCurrentLocation:newLocation
                        andRefreshLocation:false];
    
    if([self.mapManager shouldRefreshMap]) {
     
        [self.allAnnotations removeAllObjects];
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        [self.mapManager updateCurrentLocation:newLocation
                            andRefreshLocation:true];
        
        [self.mapManager getViewablePins:^(NSMutableDictionary* allNonOpenablePins) {
            NSLog(@"Num returned %lu", allNonOpenablePins.count);
            for (id key in allNonOpenablePins) {
                FLPin * pin = [allNonOpenablePins objectForKey:key];
                FLFlurAnnotation *annotation = [[FLFlurAnnotation alloc] initWithPin:pin
                                                                             isAnimated:false];
                [self.allAnnotations setObject:annotation forKey:pin.pinId];
                [self.mapView addAnnotation:annotation];
            }
            
            [self performSelector:@selector(updateOpenablePins) withObject:self afterDelay:2];
            
         
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
    for (NSString* pinId in indexes) {
        FLFlurAnnotation* f = [self.allAnnotations objectForKey:pinId];
        
        if (isNowOpenable) {
            f.isAnimated = true;
            
            [self.mapView viewForAnnotation:f].image = [UIImage imageNamed:@""];
            
            UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
            animatedImageView.tag = 10;
            animatedImageView.animationImages = [NSArray arrayWithObjects:
                                                 [UIImage imageNamed:@"frame_0.gif"],
                                                 [UIImage imageNamed:@"frame_1.gif"],
                                                 [UIImage imageNamed:@"frame_2.gif"],
                                                 [UIImage imageNamed:@"frame_3.gif"], nil];
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
            [self.mapView viewForAnnotation:f].image = [UIImage imageNamed:@"flur_152px@2x.png"];
            /*UIImageView* image = [[UIImageView alloc] initWithImage:[UIImage
                                                         imageNamed:@"flur_152px@2x.png"]];
            [[self.mapView viewForAnnotation:f] addSubview:image];*/

        }
        
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"clicked");
    id<MKAnnotation> annotation = view.annotation;
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return;
        // this is where you can find the annotation type is whether it is userlocation or not...
    }
    FLFlurAnnotation* fa = view.annotation;
    if(fa.pinId) {
        NSString* id = fa.pinId;
        FLPin* p = [[[self mapManager] openablePins] objectForKey: id];
        if(p) {
            [self showOverlay:p];
            [self.mapView deselectAnnotation:view.annotation animated:false];
        }
    }
    return;
}

- (void) showOverlay: (FLPin*) pin {
    
     UIBlurEffect *blurEffect;
     blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
     self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
     self.blurEffectView.alpha = 0;
    
    // Vibrancy effect
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [vibrancyEffectView setFrame:self.view.bounds];
    
    // Label for vibrant text
    UILabel *vibrantLabel = [[UILabel alloc] init];
    //[vibrantLabel setText:[pin returnPrompt]];
    [vibrantLabel setText:@"Hey there you should take a picture of yourself with a stranger and then some else."];

    [vibrantLabel setTextAlignment:NSTextAlignmentCenter];
    [vibrantLabel setNumberOfLines:0];
    [vibrantLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [vibrantLabel setFont:[UIFont systemFontOfSize:35.0f]];
//    [[vibrantLabel layer] setBorderWidth:2.0];
    [[vibrantLabel layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [vibrantLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [vibrantLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:33]];
    vibrantLabel.numberOfLines = 0;
    vibrantLabel.lineBreakMode = NSLineBreakByWordWrapping;
  
//    [vibrantLabel sizeToFit];
    
    
    // build button for contributing
    self.contributeButton = [[FLButton alloc] initWithPin:pin];
    [self.contributeButton setTitle:@"Contribute" forState:UIControlStateNormal];
    [[self.contributeButton titleLabel] setFont:[UIFont systemFontOfSize:30.0]];
    [self.contributeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[self.contributeButton layer] setCornerRadius:10];
    [[self.contributeButton layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[self.contributeButton layer] setBorderWidth:2.0];
    [self.contributeButton setEnabled:TRUE];
    [self.contributeButton setCenter: self.view.center];
    [self.contributeButton addTarget:self action:@selector(contributingToFlur:) forControlEvents:UIControlEventTouchDown];
    
    
    
    [self setContributeButton:self.contributeButton];
    
    [vibrantLabel sizeToFit];
    
    // add contribute button to vibrancy view
    [[vibrancyEffectView contentView] addSubview:self.contributeButton];
    
    //setting the layout for the contribute button
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:self.contributeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-200]];
    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:self.contributeButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-130]];
    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:self.contributeButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20]];
    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:self.contributeButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-20]];
    
    
    // Add label to the vibrancy view
    [[vibrancyEffectView contentView] addSubview:vibrantLabel];

    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:vibrantLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contributeButton attribute:NSLayoutAttributeTop multiplier:1 constant:-50]];
    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:vibrantLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeLeading multiplier:1 constant:20]];
    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:vibrantLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeTrailing multiplier:1 constant:-20]];
    
    
    // Add the vibrancy view to the blur view
    [[self.blurEffectView contentView] addSubview:vibrancyEffectView];
    
    // add blur view to view
    self.blurEffectView.frame = self.view.bounds;
    [self.view addSubview:self.blurEffectView];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(exitBlur:)];
    [self.blurEffectView addGestureRecognizer:singleFingerTap];

    
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:.2];
    self.blurEffectView.alpha = 1;
    [UIView commitAnimations];
    

    //[self.contributeButton addTarget:self action:@selector(contributeButtonNormal:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void) contributeButtonHighlight {
    self.contributeButton.backgroundColor = [UIColor redColor];
}

- (void) contributeButtonNormal {
    
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
                                             [UIImage imageNamed:@"frame_0.gif"],
                                             [UIImage imageNamed:@"frame_1.gif"],
                                             [UIImage imageNamed:@"frame_2.gif"],
                                             [UIImage imageNamed:@"frame_3.gif"], nil];
        animatedImageView.animationDuration = 1.0f;
        animatedImageView.animationRepeatCount = 0;
        [animatedImageView startAnimating];
        [animatedImageView setFrame: CGRectMake(0,0,25,25)];
        [annotationView addSubview:animatedImageView];
    }
}

- (IBAction)addingFlur:(id)sender {
    NSLog(@"adding flur");
    [self.mapManager addFlur];
}

/*- (IBAction)switchingView:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate switchController:@"PhotoViewController"];
}

- (void) switchController {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate switchController:@"PhotoViewController"];
}*/

- (IBAction)contributingToFlur:(id)sender {
    NSLog(@"clicked contribute");
    //self.contributeButton.backgroundColor = [UIColor redColor];
    //[self.contributeButton setTitle:@"hey" forState:UIControlStateNormal];
    
    FLButton *buttonClicked = (FLButton *)sender;
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    [data setObject:buttonClicked.pin forKey:@"FLPin"];
    [AppDelegate switchViewController:@"FLCameraViewController" withData:data];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)exitBlur:(UITapGestureRecognizer *)recognizer {
    // CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    [self.blurEffectView removeFromSuperview];
}

- (void) removeBlur {
    [self.blurEffectView removeFromSuperview];
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
