//
//  FLFlurInfoViewController.m
//  Flur
//
//  Created by Netanel Rubin on 11/23/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

@import MapKit;


#import "FLFlurInfoViewController.h"
#import "UILabel+MultiColor.h"
#import "FLFlurAnnotation.h"
#import "flur.h"
#import "FLMasterNavigationController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


/*@interface InsetLabel : UILabel
@property (nonatomic)
@end*/

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

@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) FLFlurAnnotation *annotation;

@property (nonatomic, strong, readwrite) CLLocationManager *locationManager;
@property (nonatomic) BOOL contributeView;

@property (nonatomic, strong) NSLayoutConstraint *contributeButtonHeight;
@property (nonatomic, strong) NSLayoutConstraint *viewAlbumButtonHeight;
@property (nonatomic, strong) NSLayoutConstraint *yourContributionConstraint;


@end

@implementation FLFlurInfoViewController

- (instancetype) initWithData:(NSMutableDictionary *) data {
    self = [super init];
    if (self) {
        self.months = [[NSArray alloc] initWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
        self.annotation = nil;
    }
    return self;
}

- (void) setData:(NSMutableDictionary *) data {
    NSLog(@"data: %@", data);
    NSString* creatorUsername = [data objectForKey:@"creatorUsername"];
    
    NSDate *date = [data objectForKey:@"dateCreated"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MMM d, YYYY"];
    
    NSString* dateCreated = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    
    self.flurCreated.text = [NSString stringWithFormat:@"@%@ created this flur on %@.", creatorUsername,
                             dateCreated];
    
    [self.flurCreated setTextColor:RGB(13, 191, 255)
                             range:NSMakeRange(0, creatorUsername.length+1)];
    
    NSNumber *num = [data objectForKey:@"totalContentCount"];
    NSInteger totalContentCount = num.integerValue;
    
    self.totalContributions.text = [NSString stringWithFormat:@"%lu other people have contributed to this flur.", totalContentCount];
    [self.totalContributions setTextColor:RGB(238, 0, 255)
                                    range:NSMakeRange(0, [self numDigits:totalContentCount])];

    
    if ([data objectForKey:@"contributeView"]) {
        self.contributeView = true;
        self.mapView.alpha = 0;
        
        self.yourContributionConstraint.constant = 0;
        self.yourContribution.text = @"";
        self.contributeButtonHeight.constant = 80;

        if ([[data objectForKey:@"haveContributedTo"] isEqual:@"true"]) {
            self.viewAlbumButtonHeight.constant = 80;
            [self.viewAlbumButton setTitle:@"View Album" forState:UIControlStateNormal];
            
            [self.viewAlbumButton.layer setCornerRadius:0];
            [self.viewAlbumButton.layer setShadowColor:[UIColor blackColor].CGColor];
            [self.viewAlbumButton.layer setShadowOpacity:.3];
            [self.viewAlbumButton.layer setShadowOffset:CGSizeMake(0.0f, -2.0f)];
        }
        else {
            self.viewAlbumButtonHeight.constant = 0;
            [self.viewAlbumButton setTitle:@"" forState:UIControlStateNormal];
            
            [self.contributeButton.layer setCornerRadius:0];
            [self.contributeButton.layer setShadowColor:[UIColor blackColor].CGColor];
            [self.contributeButton.layer setShadowOpacity:.3];
            [self.contributeButton.layer setShadowOffset:CGSizeMake(0.0f, -2.0f)];

        }
        
        [self.view layoutIfNeeded];
    }
    else {
        self.contributeView = false;
        self.yourContributionConstraint.constant = 0;

        self.mapView.alpha = 1;
        
        num = [data objectForKey:@"myContentPosition"];
        NSInteger myContentPosition = num.integerValue;
        
        date = [data objectForKey:@"dateAdded"];
        NSString* dateAdded = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
        
        self.yourContribution.text = [NSString stringWithFormat:@"You were the %lu person to contribute to this flur on %@.", myContentPosition, dateAdded];
        [self.yourContribution setTextColor:RGB(232,72,49)
                                        range:NSMakeRange(13, [self numDigits:myContentPosition])];
        self.yourContributionConstraint.constant = 10;

        self.contributeButtonHeight.constant = 0;
        self.viewAlbumButtonHeight.constant = 0;

        
        [self.viewAlbumButton.layer setCornerRadius:0];
        [self.viewAlbumButton.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.viewAlbumButton.layer setShadowOpacity:.3];
        [self.viewAlbumButton.layer setShadowOffset:CGSizeMake(0.0f, -2.0f)];
        [self.view layoutIfNeeded];
    }
    
    
    /*if (self.annotation == nil) {
        self.annotation = [[FLFlurAnnotation alloc] init];

    }*/
    /*self.annotation = nil;
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
    [self.mapView addAnnotation:point];*/


    

    
    
}

- (int) numDigits:(NSInteger) number {
    int digits = 1;
    
    while ((number = number/10) > 0.0) {
        digits++;
    }
    return digits;

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
    
    self.contributeButton.backgroundColor = RGBA(13,191,255, .95);
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
    
    self.viewAlbumButton.backgroundColor = RGBA(232,72,49,.95);
    self.viewAlbumButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18];
    [self.viewAlbumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.viewAlbumButton setTitle:@"View Album" forState:UIControlStateNormal];
    
    [self.view addSubview:self.viewAlbumButton];
    
    self.viewAlbumButtonHeight = [NSLayoutConstraint constraintWithItem:self.viewAlbumButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80];
    
    [self.view addConstraint:self.viewAlbumButtonHeight];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.viewAlbumButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contributeButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.viewAlbumButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.viewAlbumButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    
    [self.viewAlbumButton.layer setCornerRadius:0];
    [self.viewAlbumButton.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.viewAlbumButton.layer setShadowOpacity:.3];
    [self.viewAlbumButton.layer setShadowOffset:CGSizeMake(0.0f, -2.0f)];

    
    
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
    [self.view sendSubviewToBack:self.mapViewContainer];

    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    
    
    self.flurInfoContainer = [[UIView alloc] init];
    self.flurInfoContainer.translatesAutoresizingMaskIntoConstraints = NO;
    //self.flurInfoContainer.backgroundColor = RGB(253, 253, 253);
    self.flurInfoContainer.backgroundColor = RGBA(253,253,253,.9);

    [self.view addSubview:self.flurInfoContainer];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.flurInfoContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.flurInfoContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.flurInfoContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    [self.flurInfoContainer.layer setCornerRadius:0];
    [self.flurInfoContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.flurInfoContainer.layer setShadowOpacity:.2];
    [self.flurInfoContainer.layer setShadowOffset:CGSizeMake(0.0f, 2.0f)];
    
    self.flurCreated = [[UILabel alloc] init];
    [self.flurCreated setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.flurCreated.font = [UIFont fontWithName:@"Avenir-Light" size:17];

    [self.flurCreated setNumberOfLines:0];
    
    [self.flurInfoContainer addSubview:self.flurCreated];
    
    
    [self.flurInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.flurCreated attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.flurInfoContainer attribute:NSLayoutAttributeTop multiplier:1.0 constant:15]];
    
    [self.flurInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.flurCreated attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.flurInfoContainer attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15]];
    
    [self.flurInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.flurCreated attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.flurInfoContainer attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-15]];
    
    
    self.yourContribution = [[UILabel alloc] init];
    [self.yourContribution setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.yourContribution.font = [UIFont fontWithName:@"Avenir-Light" size:17];
    [self.yourContribution setNumberOfLines:0];
    
    [self.flurInfoContainer addSubview:self.yourContribution];
    
        self.yourContributionConstraint =[NSLayoutConstraint constraintWithItem:self.yourContribution attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.flurCreated attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10] ;
    
    [self.flurInfoContainer addConstraint:self.yourContributionConstraint];
    

    [self.flurInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.yourContribution attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.flurInfoContainer attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15]];
    
    [self.flurInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.yourContribution attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.flurInfoContainer attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-15]];
    
    
    self.totalContributions = [[UILabel alloc] init];
    [self.totalContributions setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.totalContributions.font = [UIFont fontWithName:@"Avenir-Light" size:17];
    //self.totalContributions.text = @"asdf jedfa asdf asdf asdf asdf asdf f fdsa ff d fasdf";

    [self.totalContributions setNumberOfLines:0];
    
    [self.flurInfoContainer addSubview:self.totalContributions];
    
    
    [self.flurInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.totalContributions attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.yourContribution attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
    
    [self.flurInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.totalContributions attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.flurInfoContainer attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15]];
    
    [self.flurInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.totalContributions attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.flurInfoContainer attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-15]];

    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.flurInfoContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.totalContributions attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15]];
    
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(exitPage:)];
    [self.flurInfoContainer addGestureRecognizer:singleFingerTap];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(exitPage:)];
    tgr.numberOfTapsRequired = 1;
    tgr.numberOfTouchesRequired = 1;
    [self.mapViewContainer addGestureRecognizer:tgr];


    
    
    // Do any additional setup after loading the view.
}

- (void) exitPage:(UITapGestureRecognizer *)recognizer {
    if (self.contributeView)
        [self.delegate hideContributePage];
    else
        [self.delegate hideInfoPage];
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
    [dateFormatter setDateFormat:@"MM"];
    NSInteger curMonth = [[dateFormatter stringFromDate:date] integerValue] - 1;
    
    [dateFormatter setDateFormat:@"dd"];
    NSString *curDay = [NSString stringWithFormat:@"%ld", [[dateFormatter stringFromDate:date] integerValue]];
    
    [dateFormatter setDateFormat:@"YYYY"];
    NSString *curYear = [dateFormatter stringFromDate:date];
    
    
    return [NSString stringWithFormat:@"%@ %@, %@", self.months[curMonth], curDay, curYear];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    NSLog(@"WHOOOooooo: %@", [annotation class]);

    if([annotation isKindOfClass:[FLFlurAnnotation class]]) {
        NSLog(@"THATS WATSUP");
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
