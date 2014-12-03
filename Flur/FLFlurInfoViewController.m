//
//  FLFlurInfoViewController.m
//  Flur
//
//  Created by Netanel Rubin on 11/23/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

@import MapKit;


#import "FLFlurInfoViewController.h"
#import "UILabel+MultiColor.h"
#import "FLFlurAnnotation.h"
#import "flur.h"
#import "FLMasterNavigationController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@interface FLFlurInfoViewController ()

@property (nonatomic, strong) UIButton *viewAlbumButton;
@property (nonatomic, strong) UIButton *contributeButton;

@property (nonatomic, strong) UIView *flurInfoContainer;

@property (nonatomic, strong) UIView *mapViewContainer;
@property (nonatomic, strong, readwrite) MKMapView *mapView;

@property (nonatomic, strong) UILabel *flurCreated;
@property (nonatomic, strong) UILabel *yourContribution;
@property (nonatomic, strong) UILabel *totalContributions;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic) CLLocationCoordinate2D coord;
@property (nonatomic) NSInteger buttonHeight;

@property (nonatomic, strong) Flur *flur;
@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) FLFlurAnnotation *annotation;

@property (nonatomic, strong, readwrite) CLLocationManager *locationManager;
@property (nonatomic) BOOL contributeView;

@property (nonatomic, strong) NSLayoutConstraint *contributeButtonHeight;
@property (nonatomic, strong) NSLayoutConstraint *viewAlbumButtonHeight;



@end

@implementation FLFlurInfoViewController

- (instancetype) initWithData:(NSMutableDictionary *) data {
    self = [super init];
    if (self) {
        self.flur = [data objectForKey:@"flur"];
        self.annotation = nil;
    }
    return self;
}

- (void) setData:(NSMutableDictionary *) data {
    
    if ([data objectForKey:@"contributeView"]) {
        self.contributeView = true;
        [self.mapView removeFromSuperview];
    }
    else {
        self.contributeView = false;
        
        self.contributeButtonHeight.constant = 0;
        self.mapView.alpha = 1;
        
        [self.view layoutIfNeeded];
    }
    
    self.flur = [data objectForKey:@"flur"];
   // NSLog(@"FLur: %@", self.flur);
    
    self.flurCreated.text = [NSString stringWithFormat:@"@%@ created this flur on %@", self.flur.creatorUsername, [self stringFromDate:self.flur.dateCreated]];
    [self.flurCreated setTextColor:RGB(13, 191, 255)
                             range:NSMakeRange(0, self.flur.creatorUsername.length+1)];
    
    int num = self.flur.totalContentCount.intValue;
    int digits = 1;

    while ((num = num/10) > 0.0) {
        digits++;
    }
    
    self.totalContributions.text = [NSString stringWithFormat:@"%@ other people have contributed to this flur.", self.flur.totalContentCount];
    [self.totalContributions setTextColor:RGB(238, 0, 255)
                                    range:NSMakeRange(0, digits)];
    
    /*if (self.annotation == nil) {
        self.annotation = [[FLFlurAnnotation alloc] init];

    }*/
    self.annotation = nil;
    self.annotation = [[FLFlurAnnotation alloc] initWithLat:self.flur.lat.doubleValue initWithLng:self.flur.lng.doubleValue];
    [self.mapView addAnnotation:self.annotation];
    
    //[self.mapView removeAnnotation:self.annotation];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(self.flur.lat.doubleValue,
                                                              self.flur.lng.doubleValue);
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = self.coord;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    
    NSLog(@"coord1: %f %f", self.coord.latitude, self.coord.longitude);
    [self.mapView addAnnotation:point];

    self.coord = CLLocationCoordinate2DMake(coord.latitude, coord.longitude);
    NSLog(@"coord2: %f %f", self.coord.latitude, self.coord.longitude);
    [self.mapView addAnnotation:point];


    

    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //----Setting up the Location Manager-----//
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    _locationManager.distanceFilter = 3;
    [_locationManager startUpdatingLocation];

    self.buttonHeight = 80;
    
    
    
    self.contributeButton = [[UIButton alloc] init];
    [self.contributeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.contributeButton.backgroundColor = RGB(100,100,100);
    self.contributeButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18];
    [self.contributeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contributeButton setTitle:@"Add Photo" forState:UIControlStateNormal];
    
    [self.view addSubview:self.contributeButton];
    
    self.contributeButtonHeight =[NSLayoutConstraint constraintWithItem:self.contributeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80];
    
    [self.view addConstraint:self.contributeButtonHeight];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.contributeButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.contributeButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.contributeButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    
    self.viewAlbumButton = [[UIButton alloc] init];
    [self.viewAlbumButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.viewAlbumButton.backgroundColor = [UIColor redColor];
    self.viewAlbumButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18];
    [self.viewAlbumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.viewAlbumButton setTitle:@"View Album" forState:UIControlStateNormal];
    
    [self.view addSubview:self.viewAlbumButton];
    
    self.viewAlbumButtonHeight = [NSLayoutConstraint constraintWithItem:self.viewAlbumButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80];
    
    [self.view addConstraint:self.viewAlbumButtonHeight];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.viewAlbumButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contributeButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.viewAlbumButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.viewAlbumButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    self.flurInfoContainer = [[UIView alloc] init];
    self.flurInfoContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.flurInfoContainer.backgroundColor = RGB(253, 253, 253);
    [self.view addSubview:self.flurInfoContainer];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.flurInfoContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.flurInfoContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.flurInfoContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    
    self.flurCreated = [[UILabel alloc] init];
    [self.flurCreated setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.flurCreated.text = [NSString stringWithFormat:@"@%@ created this flur on Aug 3, 2014.", self.flur.creatorUsername];
    self.flurCreated.font = [UIFont fontWithName:@"Avenir-Light" size:19];

    [self.flurCreated setNumberOfLines:0];

    [self.flurCreated setTextColor:RGB(13, 191, 255) range:NSMakeRange(0, self.flur.creatorUsername.length+1)];
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
    self.mapViewContainer.backgroundColor = RGBA(255, 255, 255, .4);
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.mapViewContainer.frame];
    self.mapView.delegate = self;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.mapView setZoomEnabled:YES];
    [self.mapView setPitchEnabled:YES];
    [self.mapView setShowsUserLocation:NO];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    
    self.mapView.alpha = 0;
    
    
    [self.mapViewContainer addSubview:self.mapView];
    
    [self.view addSubview:self.mapViewContainer];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.flurInfoContainer attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
     [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.viewAlbumButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    


    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
   // MKAnnotationView *ulv = [mapView viewForAnnotation:mapView.userLocation];
   // ulv.hidden = YES;
}

- (IBAction)returnToTableList:(id)sender {
    NSMutableDictionary *data;
    [FLMasterNavigationController switchToViewController:@"FLTableViewController" fromViewController:@"FLFlurInfoViewController" withData:data];
}

- (NSString *) stringFromDate:(NSDate *)dateAdded {
    
    NSDate *date = dateAdded;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MMM d, YYYY"];
    
    return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    //NSLog(@"WHOOOooooo: %@", [annotation class]);

    if([annotation isKindOfClass:[FLFlurAnnotation class]]) {
        //NSLog(@"THATS WATSUP");
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

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    self.coord = userLocation.coordinate;
    
    //[self.mapView addAnnotation:point];
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
