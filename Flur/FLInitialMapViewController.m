//
//  FLInitialMapViewController.m
//  Flur
//
//  Created by Lily Hashemi on 10/4/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
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

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

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

    //[PFUser logOut];

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
        
//        // get contributed pins
//        [LocalStorage getFlurs:^(NSMutableDictionary *allFlurs) {
//            self.myContrPins = allFlurs[@"allFlurs"];
//            for (FLPin* pin in self.myContrPins) {
//                if ([[pin pinId] isEqualToString: pinId]) {
//                    UIImageView* animatedImageView = [[UIImageView alloc] init];
//                    animatedImageView.tag = 10;
//                    [animatedImageView setImage:[UIImage imageNamed:@"contrPin.png"]];
//                    [animatedImageView setFrame: CGRectMake(-15,-15,30,30)];
//                    [[self.mapView viewForAnnotation:f] addSubview:animatedImageView];
//                    return;
//                }
//                    
//            }
//            
//        }];

        if (isNowOpenable) {
            f.isAnimated = true;
            for (UIView *subView in [[self.mapView viewForAnnotation:f] subviews]) {
                if (subView.tag == 10) {
                    [subView removeFromSuperview];
                }
            }
            
            UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
            animatedImageView.tag = 10;
            animatedImageView.animationImages = [NSArray arrayWithObjects:
                                                 [UIImage imageNamed:@"14.png"],
                                                 [UIImage imageNamed:@"14.png"],
                                                 [UIImage imageNamed:@"14.png"],
                                                 [UIImage imageNamed:@"14.png"],
                                                 [UIImage imageNamed:@"14.png"],
                                                 [UIImage imageNamed:@"13.png"],
                                                 [UIImage imageNamed:@"12.png"],
                                                 [UIImage imageNamed:@"11.png"],
                                                 [UIImage imageNamed:@"10.png"],
                                                 [UIImage imageNamed:@"9.png"],
                                                 [UIImage imageNamed:@"8.png"],
                                                 [UIImage imageNamed:@"7.png"],
                                                 [UIImage imageNamed:@"6.png"],
                                                 [UIImage imageNamed:@"5.png"],
                                                 [UIImage imageNamed:@"4.png"],
                                                 [UIImage imageNamed:@"3.png"],
                                                 [UIImage imageNamed:@"2.png"],
                                                 [UIImage imageNamed:@"1.png"],
                                                 [UIImage imageNamed:@"0.png"],
                                                 [UIImage imageNamed:@"0.png"],
                                                 [UIImage imageNamed:@"0.png"],
                                                 [UIImage imageNamed:@"0.png"],
                                                 [UIImage imageNamed:@"0.png"],
                                                 [UIImage imageNamed:@"1.png"],
                                                 [UIImage imageNamed:@"2.png"],
                                                 [UIImage imageNamed:@"3.png"],
                                                 [UIImage imageNamed:@"4.png"],
                                                 [UIImage imageNamed:@"5.png"],
                                                 [UIImage imageNamed:@"6.png"],
                                                 [UIImage imageNamed:@"7.png"],
                                                 [UIImage imageNamed:@"8.png"],
                                                 [UIImage imageNamed:@"9.png"],
                                                 [UIImage imageNamed:@"10.png"],
                                                 [UIImage imageNamed:@"11.png"],
                                                 [UIImage imageNamed:@"12.png"],
                                                 [UIImage imageNamed:@"13.png"], nil];
            animatedImageView.animationDuration = 1.3f;
            animatedImageView.animationRepeatCount = 0;
            [animatedImageView startAnimating];
            [animatedImageView setFrame: CGRectMake(-15,-15,30,30)];
            
            
            [[self.mapView viewForAnnotation:f] addSubview:animatedImageView];

        }
        else {
            for (UIView *subView in [[self.mapView viewForAnnotation:f] subviews]) {
                if (subView.tag == 10) {
                    [subView removeFromSuperview];
                }
            }
            UIImageView* animatedImageView = [[UIImageView alloc] init];
            animatedImageView.tag = 10;
            [animatedImageView setImage:[UIImage imageNamed:@"14.png"]];
            
            [animatedImageView setFrame: CGRectMake(-15,-15,30,30)];
            
            
            [[self.mapView viewForAnnotation:f] addSubview:animatedImageView];
            //[self.mapView viewForAnnotation:f].image = [UIImage imageNamed:@"14.png"];
            /*UIImageView* image = [[UIImageView alloc] initWithImage:[UIImage
                                                         imageNamed:@"flur_152px@2x.png"]];
            [[self.mapView viewForAnnotation:f] addSubview:image];*/

        }
        
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    id<MKAnnotation> annotation = view.annotation;
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        view.selected = NO;
        return;
        // this is where you can find the annotation type is whether it is userlocation or not...
    }
    FLFlurAnnotation* fa = view.annotation;
    if(fa.pinId) {
        NSString* id = fa.pinId;
        FLPin* p = [[[self mapManager] openablePins] objectForKey: id];
        if(p) {
            //[self showOverlay:p];
            NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
            [data setObject:p forKey:@"FLPin"];
            /*[FLMasterNavigationController switchToViewController:@"FLContributeViewController"
                            fromViewController:@"FLInitialMapViewController"
                                                        withData:data];*/
            
            
            
            [self.mapView deselectAnnotation:view.annotation animated:false];
        }
    }
    return;
}

//- (void) showOverlay:(FLPin*) pin {
//    
//     UIBlurEffect *blurEffect;
//     blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    
//     self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//     self.blurEffectView.alpha = 0;
//    
//    // Vibrancy effect
//    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
//    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
//    [vibrancyEffectView setFrame:self.view.bounds];
//    
//    // Label for vibrant text
//    UILabel *vibrantLabel = [[UILabel alloc] init];
//    [vibrantLabel setText:[pin prompt]];
//
//    [vibrantLabel setTextAlignment:NSTextAlignmentCenter];
//    [vibrantLabel setNumberOfLines:0];
//    [vibrantLabel setLineBreakMode:NSLineBreakByWordWrapping];
//    [vibrantLabel setFont:[UIFont systemFontOfSize:35.0f]];
////    [[vibrantLabel layer] setBorderWidth:2.0];
//    [[vibrantLabel layer] setBorderColor:[[UIColor whiteColor] CGColor]];
//    [vibrantLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [vibrantLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:33]];
//    vibrantLabel.numberOfLines = 0;
//    vibrantLabel.lineBreakMode = NSLineBreakByWordWrapping;
//  
////    [vibrantLabel sizeToFit];
//    
//    
//    // build button for contributing
//    self.contributeButton = [[FLButton alloc] initWithPin:pin];
//    [self.contributeButton setTitle:@"Contribute" forState:UIControlStateNormal];
//    [[self.contributeButton titleLabel] setFont:[UIFont systemFontOfSize:30.0]];
//    [self.contributeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [[self.contributeButton layer] setCornerRadius:10];
//    [[self.contributeButton layer] setBorderColor:[[UIColor whiteColor] CGColor]];
//    [[self.contributeButton layer] setBorderWidth:2.0];
//    [self.contributeButton setEnabled:TRUE];
//    [self.contributeButton setCenter: self.view.center];
//    [self.contributeButton addTarget:self action:@selector(contributingToFlur:) forControlEvents:UIControlEventTouchDown];
//    self.contributeButton.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:33];
//    
//    [self setContributeButton:self.contributeButton];
//    
//    [vibrantLabel sizeToFit];
//    
//    // add contribute button to vibrancy view
//    [[vibrancyEffectView contentView] addSubview:self.contributeButton];
//    
//    //setting the layout for the contribute button
//    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:self.contributeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-200]];
//    
//    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:self.contributeButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-130]];
//    
//    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:self.contributeButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20]];
//    
//    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:self.contributeButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-20]];
//    
//    
//    // Add label to the vibrancy view
//    [[vibrancyEffectView contentView] addSubview:vibrantLabel];
//
//    
//    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:vibrantLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contributeButton attribute:NSLayoutAttributeTop multiplier:1 constant:-50]];
//    
//    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:vibrantLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeLeading multiplier:1 constant:20]];
//    
//    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:vibrantLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeTrailing multiplier:1 constant:-20]];
//    
//    
//    // Add the vibrancy view to the blur view
//    [[self.blurEffectView contentView] addSubview:vibrancyEffectView];
//    
//    // add blur view to view
//    self.blurEffectView.frame = self.view.bounds;
//    [self.view addSubview:self.blurEffectView];
//    
//    UITapGestureRecognizer *singleFingerTap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(exitBlur:)];
//    [self.blurEffectView addGestureRecognizer:singleFingerTap];
//
//    
//    [UIView beginAnimations:@"fade in" context:nil];
//    [UIView setAnimationDuration:.2];
//    self.blurEffectView.alpha = 1;
//    [UIView commitAnimations];
//    
//}

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

//- (void) createDisplayForPin: (MKAnnotationView *) annotationView isAnimated:(BOOL) isAnimated {
//    if (isAnimated) {
//        UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//        animatedImageView.animationImages = [NSArray arrayWithObjects:
//                                             [UIImage imageNamed:@"14.png"],
//                                             [UIImage imageNamed:@"14.png"],
//                                             [UIImage imageNamed:@"14.png"],
//                                             [UIImage imageNamed:@"14.png"],
//                                             [UIImage imageNamed:@"14.png"],
//                                             [UIImage imageNamed:@"13.png"],
//                                             [UIImage imageNamed:@"12.png"],
//                                             [UIImage imageNamed:@"11.png"],
//                                             [UIImage imageNamed:@"10.png"],
//                                             [UIImage imageNamed:@"9.png"],
//                                             [UIImage imageNamed:@"8.png"],
//                                             [UIImage imageNamed:@"7.png"],
//                                             [UIImage imageNamed:@"6.png"],
//                                             [UIImage imageNamed:@"5.png"],
//                                             [UIImage imageNamed:@"4.png"],
//                                             [UIImage imageNamed:@"3.png"],
//                                             [UIImage imageNamed:@"2.png"],
//                                             [UIImage imageNamed:@"1.png"],
//                                             [UIImage imageNamed:@"0.png"],
//                                             [UIImage imageNamed:@"0.png"],
//                                             [UIImage imageNamed:@"0.png"],
//                                             [UIImage imageNamed:@"0.png"],
//                                             [UIImage imageNamed:@"0.png"],
//                                             [UIImage imageNamed:@"1.png"],
//                                             [UIImage imageNamed:@"2.png"],
//                                             [UIImage imageNamed:@"3.png"],
//                                             [UIImage imageNamed:@"4.png"],
//                                             [UIImage imageNamed:@"5.png"],
//                                             [UIImage imageNamed:@"6.png"],
//                                             [UIImage imageNamed:@"7.png"],
//                                             [UIImage imageNamed:@"8.png"],
//                                             [UIImage imageNamed:@"9.png"],
//                                             [UIImage imageNamed:@"10.png"],
//                                             [UIImage imageNamed:@"11.png"],
//                                             [UIImage imageNamed:@"12.png"],
//                                             [UIImage imageNamed:@"13.png"], nil];
//        animatedImageView.animationDuration = 1.0f;
//        animatedImageView.animationRepeatCount = 0;
//        [animatedImageView startAnimating];
//        [animatedImageView setFrame: CGRectMake(0,0,25,25)];
//        animatedImageView.backgroundColor = [UIColor blackColor];
//        [annotationView addSubview:animatedImageView];
//    }
//}

- (void)showAddPromptToNewFlurOverlay {
    UIBlurEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    _addPinBlurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _addPinBlurEffectView.alpha = 0;
    [_addPinBlurEffectView setOpaque:1];
    
    //Vibrancy effect
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [vibrancyEffectView setFrame:self.view.bounds];
    [vibrancyEffectView setOpaque:1];
    
    //Label for Prompting User
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"What Do You Want To See?"]; //work on what the prompt for prompting should be
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setNumberOfLines:0];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:33]];
    [[label layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [[vibrancyEffectView contentView] addSubview:label];
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeTop multiplier:1 constant:150]];
    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeLeading multiplier:1 constant:10]];
    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10]];
    
    UITextField *textField = [[UITextField alloc] init];
    [textField setTextAlignment:NSTextAlignmentLeft];
    [textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[textField layer] setBorderWidth:2.0];
    [[textField layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[textField layer] setCornerRadius:3.0];
    [textField setDelegate:self];
    [self setPromptTextField:textField];
    
    [[vibrancyEffectView contentView] addSubview:self.promptTextField];
    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeBottom multiplier:1.0 constant:40]];
    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeLeading multiplier:1.0 constant:30]];
    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-30]];
    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35]];
    
    UIButton *submitButton = [[UIButton alloc] init];
    [submitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [submitButton setEnabled:TRUE];
    [submitButton setCenter:[[vibrancyEffectView contentView] center]];
    [submitButton addTarget:self action:@selector(creatingFlur:) forControlEvents:UIControlEventTouchDown];
    [submitButton setImage:[UIImage imageNamed:@"white-120px.png"] forState:UIControlStateNormal];
    
    [[vibrancyEffectView contentView] addSubview:submitButton];
    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:submitButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:textField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:70]];
    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:submitButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeLeading multiplier:1.0 constant:45]];
    
    [[vibrancyEffectView contentView] addConstraint:[NSLayoutConstraint constraintWithItem:submitButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[vibrancyEffectView contentView] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-45]];
    
    [[_addPinBlurEffectView contentView] addSubview:vibrancyEffectView];
    _addPinBlurEffectView.frame = self.view.bounds;
    [self.view addSubview:self.addPinBlurEffectView];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(exitEnterPromptBlur:)];
    [self.addPinBlurEffectView addGestureRecognizer:singleFingerTap];
    
    
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:.2];
    self.addPinBlurEffectView.alpha = 1;
    [UIView commitAnimations];
    
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
    [self showAddPromptToNewFlurOverlay];
}


- (IBAction)contributingToFlur:(id)sender {
    NSLog(@"clicked contribute");
    
    FLButton *buttonClicked = (FLButton *)sender;
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    [data setObject:buttonClicked.pin forKey:@"FLPin"];
    [FLMasterNavigationController switchToViewController:@"FLCameraViewController"
                                      fromViewController:@"FLInitialMapViewController"
                                                withData:data];
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
    if (self.menuButton.tag == 0) {
        [self btnMovePanelRight:self.menuButton];
    }
}

@end
