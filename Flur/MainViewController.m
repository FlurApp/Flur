//
//  MainViewController.m
//  Flur
//
//  Created by David Lee on 11/23/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "FLConstants.h"
#import "LocalStorage.h"
#import "FLCustomCellTableViewCell.h"

@interface MainViewController ()

@property (nonatomic) BOOL shouldSync;
@property (nonatomic) BOOL settingsVisible;
@property (nonatomic) BOOL tableVisible;

@end

@implementation MainViewController


#pragma mark -
#pragma mark View Did Load/Unload

- (instancetype) initWithData:(NSMutableDictionary *) data {
    self = [super init];
    
    if (self) {
        self.shouldSync = [data objectForKey:@"sync"] != nil;
        self.settingsVisible = false;
        self.tableVisible = false;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark View Will/Did Disappear

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark Setup View

- (void)setupView {
    
    
    /* -------------------------------------------
                Setup Settings View.
     -----------------------------------------------*/
    self.settingsView = [[FLSettingsViewController alloc] init];
    self.settingsView.delegate = self;
    
    // This is necessary for loading the profile pic from
    //  core data on a launch when user is already logged in.
    // setData method is also called when hiding login page.
    [self.settingsView setData];
    
    [self.view addSubview:self.settingsView.view];
    [self addChildViewController:self.settingsView];
    
    self.settingsView.view.frame = CGRectMake(-self.view.frame.size.width, 0,
                                              self.view.frame.size.width,
                                              self.view.frame.size.height);
    
    /* -------------------------------------------
     Setup Map View.
     -----------------------------------------------*/
    self.mapView = [[FLInitialMapViewController alloc] init];
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView.view];
    [self addChildViewController:self.mapView];
    self.mapView.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.mapView.view.layer.masksToBounds = NO;
    [self.mapView.view.layer setCornerRadius:0];
    [self.mapView.view.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.mapView.view.layer setShadowOpacity:.4];
    [self.mapView.view.layer setShadowOffset:CGSizeMake(0.0f, 3.0f)];
    
    
    /* ---------------------------------------
     Setup Top Bar View
     -----------------------------------------------*/
    self.topBarView = [[FLTopBarViewController alloc] init];
    self.topBarView.delegate = self;
    
    [self.view addSubview:self.topBarView.view];
    
    [self addChildViewController:self.topBarView];
    
    self.topBarView.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, TOP_BAR_HEIGHT);
    [self hideVC:self.topBarView];
    
    
    /* -------------------------------------------
                    Setup Table View.
     -----------------------------------------------*/
    self.tableView = [[FLTableViewController alloc] init];
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView.view];
    
    [self addChildViewController:self.tableView];
    
    self.tableView.view.frame = CGRectMake(-self.view.frame.size.width, TOP_BAR_HEIGHT,
                                           self.view.frame.size.width, self.view.frame.size.height - TOP_BAR_HEIGHT);
    
    
    
    /* -------------------------------------------
                Setup Flur Info View.
     -----------------------------------------------*/
    self.flurInfoView = [[FLFlurInfoViewController alloc] initWithData:nil];
    self.flurInfoView.delegate = self;
    
    [self.view addSubview:self.flurInfoView.view];
    
    [self addChildViewController:self.flurInfoView];
    
    self.flurInfoView.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width,
                                              self.view.frame.size.height - TOP_BAR_HEIGHT);
    
    
    /* -------------------------------------------
                Setup Add New Flur View.
     -----------------------------------------------*/
    self.dropFlurView = [[FLNewFlurViewController alloc] init];
    self.dropFlurView.delegate = self;
    
    [self.view addSubview:self.dropFlurView.view];
    [self addChildViewController:self.dropFlurView];
    self.dropFlurView.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width,
                                              self.view.frame.size.height - TOP_BAR_HEIGHT);
    
    /* -------------------------------------------
                Setup Camera View
     -----------------------------------------------*/
    self.cameraView = [[FLCameraViewController alloc] init];
    self.cameraView.delegate = self;
    
    [self.view addSubview:self.cameraView.view];
    [self addChildViewController:self.cameraView];
    self.cameraView.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width,
                                              self.view.frame.size.height);
    
    /* -------------------------------------------
                Setup login View
     -----------------------------------------------*/
    self.loginView = [[FLLoginViewController alloc] init];
    self.loginView.delegate = self;
    
    [self.view addSubview:self.loginView.view];
    [self addChildViewController:self.loginView];
    self.loginView.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width,
                                            self.view.frame.size.height);
    
    /* -------------------------------------------
                Setup signup View
     -----------------------------------------------*/
    self.signupView = [[FLSignupViewController alloc] init];
    self.signupView.delegate = self;
    
    [self.view addSubview:self.signupView.view];
    [self addChildViewController:self.signupView];
    self.signupView.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width,
                                           self.view.frame.size.height);
    
    
    
    
    /* -------------------------------------------
                Setup splash View
     -----------------------------------------------*/
    self.splashView = [[FLSplashViewController alloc] init];
    self.splashView.delegate = self;
    
    [self.view addSubview:self.splashView.view];
    [self addChildViewController:self.splashView];
    self.splashView.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width,
                                            self.view.frame.size.height);
    
    /* -------------------------------------------
                Setup photo view
     -----------------------------------------------*/
//    self.photoView = [[PhotoViewController alloc] init];
//    self.photoView.delegate = self;
//    
//    [self.view addSubview:self.photoView.view];
//    [self addChildViewController:self.photoView];
//    self.photoView.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width,
//                                            self.view.frame.size.height);
    
    
    /*if (self.shouldSync) {
        NSLog(@"syncing");
        [LocalStorage syncWithServer:^{
            [self.tableView getFlurs];
        }];
    }
    else {
        [LocalStorage getFlurs:^(NSMutableDictionary *data) {
            NSLog(@"hii");
            NSLog(@"wtf: %lu", data.count);
        }];
    }*/
//    [LocalStorage syncWithServer:^{
//        [self.tableView getFlurs];
//    }];
    
    
    // INITIAL CONTROL LOGIC
    PFUser *currentUser = [PFUser currentUser];
//    [LocalStorage deleteAllFlurs];
    if (currentUser) {
        self.topBarView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, TOP_BAR_HEIGHT);
        self.mapView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    }
    else {
        self.splashView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}

// Delegate function called by the Top Var View Controller
- (void) settingButtonPress {
    if (self.settingsVisible)
        [self hideSettingsPage];
    else
        [self showSettingsPage];
}

- (void) showSettingsPage {
    
    self.settingsVisible = true;
    [self.mapView showWhiteLayer];
    [self.settingsView didMoveToParentViewController:self];
    
    self.settingsView.view.frame =  CGRectMake(0, 0,
                                               self.view.frame.size.width,
                                               self.view.frame.size.height);

    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                         
             self.mapView.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0,
                                                  self.mapView.view.frame.size.width,
                                                  self.mapView.view.frame.size.height);
             
             self.topBarView.view.frame = CGRectMake(self.view.frame.size.width-PANEL_WIDTH, 0,
                                                     self.topBarView.view.frame.size.width,
                                                     self.topBarView.view.frame.size.height);

    } completion:^(BOOL finished) { }];
}

- (void) hideSettingsPage {
    self.settingsVisible = false;
    [self.mapView hideWhiteLayer];
    [self.mapView didMoveToParentViewController:self];

    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
             self.mapView.view.frame = CGRectMake(0, 0, self.mapView.view.frame.size.width,
                                                  self.mapView.view.frame.size.height);
             
             self.topBarView.view.frame =  CGRectMake(0, 0, self.topBarView.view.frame.size.width,
                                                      self.topBarView.view.frame.size.height);
             
    } completion:^(BOOL finished) {
        self.settingsView.view.frame =  CGRectMake(-self.view.frame.size.width, 0,
                                                   self.view.frame.size.width,
                                                   self.view.frame.size.height);
    }];
}

- (void) showTablePage:(int)fromPhotoAlbum {
    self.tableVisible = true;
    [self.tableView didMoveToParentViewController:self];
    
    self.tableView.view.frame = CGRectMake(self.view.frame.size.width*fromPhotoAlbum, TOP_BAR_HEIGHT,
                                           self.view.frame.size.width, self.view.frame.size.height - TOP_BAR_HEIGHT);

    [self.view sendSubviewToBack:self.tableView.view];

    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.mapView.view.frame = CGRectMake(-self.view.frame.size.width, 0,
                                             self.view.frame.size.width,
                                             self.view.frame.size.height);
        
        self.tableView.view.frame = CGRectMake(0, TOP_BAR_HEIGHT,
                                               self.view.frame.size.width, self.view.frame.size.height - TOP_BAR_HEIGHT);
        
    } completion:^(BOOL finished) { }];
    
}

- (void) hideTablePage {
    self.tableVisible = false;
    [self.mapView didMoveToParentViewController:self];
    [FLCustomCellTableViewCell closeCurrentlyOpenCell];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.mapView.view.frame = CGRectMake(0, 0,
                                             self.view.frame.size.width,
                                             self.view.frame.size.height);
        
        self.tableView.view.frame = CGRectMake(-self.view.frame.size.width, TOP_BAR_HEIGHT,
                                               self.view.frame.size.width, self.view.frame.size.height - TOP_BAR_HEIGHT);

        
    } completion:^(BOOL finished) {

    }];
}

- (void) showInfoPage:(NSMutableDictionary *)data {
    [self.topBarView showInfoPageBar];
    [self.flurInfoView setData:data];
    self.flurInfoView.view.frame = CGRectMake(0, self.view.frame.size.height,
                                              self.flurInfoView.view.frame.size.width,
                                              self.flurInfoView.view.frame.size.height);
    
    [self.view bringSubviewToFront:self.flurInfoView.view];
    
    [UIView animateWithDuration:.3 delay:.2 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            self.flurInfoView.view.frame = CGRectMake(0, TOP_BAR_HEIGHT,
                                                    self.flurInfoView.view.frame.size.width,
                                                    self.flurInfoView.view.frame.size.height);
    } completion:^(BOOL finished) { }];
    
}

- (void) hideInfoPage {
    [self.topBarView showTableBar];
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.flurInfoView.view.frame = CGRectMake(0, self.view.frame.size.height,
                                                  self.flurInfoView.view.frame.size.width,
                                                  self.flurInfoView.view.frame.size.height);
    } completion:^(BOOL finished) { }];
}

- (void) showContributePage:(NSMutableDictionary *)data {
    [self.flurInfoView setData:data];
    [self.topBarView showContributeBar];
    self.flurInfoView.view.frame = CGRectMake(0, self.view.frame.size.height,
                                              self.flurInfoView.view.frame.size.width,
                                              self.flurInfoView.view.frame.size.height);
    [self.view bringSubviewToFront:self.flurInfoView.view];
    
    [UIView animateWithDuration:.3 delay:.2 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.flurInfoView.view.frame = CGRectMake(0, TOP_BAR_HEIGHT,
                                                  self.flurInfoView.view.frame.size.width,
                                                  self.flurInfoView.view.frame.size.height);
    } completion:^(BOOL finished) { }];
}

- (UIView *) getMapView {
    [self.mapView didMoveToParentViewController:self];
    return self.mapView.view;
}

- (UIView *)getSettingsView {
    [self.settingsView didMoveToParentViewController:self];
    return self.settingsView.view;
}

- (UIView *)getTableView {
    [self.tableView didMoveToParentViewController:self];
    return self.tableView.view;
}
/*
#pragma mark -
#pragma mark Swipe Gesture Setup/Actions

#pragma mark - setup

- (void)setupGestures
{
}

-(void)movePanel:(id)sender
{
}*/

- (void) showDropFlurPage {
    [self.topBarView showDropFlurBar];
    [self hideSettingsPage];
    [self.dropFlurView setup];
    [self.view bringSubviewToFront:self.dropFlurView.view];
    
    self.dropFlurView.view.frame = CGRectMake(0, self.view.frame.size.height,
                                              self.dropFlurView.view.frame.size.width,
                                              self.dropFlurView.view.frame.size.height);
    
    [UIView animateWithDuration:.3 delay:.2 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.dropFlurView.view.frame = CGRectMake(0, TOP_BAR_HEIGHT,
                                                  self.dropFlurView.view.frame.size.width,
                                                    self.dropFlurView.view.frame.size.height);
    } completion:^(BOOL finished) {
        [self.dropFlurView setFocus:YES];
    }];
}

- (void) hideDropFlurPage {
    [self.dropFlurView setFocus:NO];
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.dropFlurView.view.frame = CGRectMake(0, self.view.frame.size.height,
                                                  self.dropFlurView.view.frame.size.width,
                                                  self.dropFlurView.view.frame.size.height);
        [self.topBarView showMapBar];
    } completion:^(BOOL finished) {
    }];
}


- (void)addFlurToCamera: (NSMutableDictionary*)data {
    [self hideDropFlurPage];
    
    FLPin *pin = [[FLPin alloc] init];
    pin.coordinate = [self getCurrentLocation];
    pin.prompt = data[@"prompt"];
    
    NSMutableDictionary *dataToPass = [[NSMutableDictionary alloc] init];
    dataToPass[@"FLPin"] = pin;
    dataToPass[@"newFlur"] = @"true";
    [self.mapView setFlurAboutToBeAdded:data[@"prompt"]];
    
    [self showCameraPage:dataToPass];

}



-(void) showCameraPage:(NSMutableDictionary*)data {
    
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self.cameraView setData:data];
    
    self.cameraView.view.frame = CGRectMake(0, -self.view.frame.size.height,
                                              self.cameraView.view.frame.size.width,
                                              self.cameraView.view.frame.size.height);
    [self.view bringSubviewToFront:self.cameraView.view];
    
    [UIView animateWithDuration:.3 delay:.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.cameraView.view.frame = CGRectMake(0, -20,
                                                  self.cameraView.view.frame.size.width,
                                                  self.cameraView.view.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.07 delay:.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
            self.cameraView.view.frame = CGRectMake(0, -10,
                                                    self.cameraView.view.frame.size.width,
                                                    self.cameraView.view.frame.size.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.07 delay:.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
                self.cameraView.view.frame = CGRectMake(0, 0,
                                                        self.cameraView.view.frame.size.width,
                                                        self.cameraView.view.frame.size.height);
            } completion:^(BOOL finished) {}];
        }];

    }];
    
}

-(void) hideCameraPage {
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.cameraView.view.frame = CGRectMake(0, self.view.frame.size.height,
                                                  self.cameraView.view.frame.size.width,
                                                  self.cameraView.view.frame.size.height);
    } completion:^(BOOL finished) { }];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self.cameraView.blurEffectView removeFromSuperview];
}

- (void) hideContributePage {
    [self.topBarView showMapBar];

    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.flurInfoView.view.frame = CGRectMake(0, self.view.frame.size.height,
                                                  self.flurInfoView.view.frame.size.width,
                                                  self.flurInfoView.view.frame.size.height);
    } completion:^(BOOL finished) { }];
}

-(void)showSplashPage {
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.splashView.view.frame = CGRectMake(0, 0,
                                               self.splashView.view.frame.size.width,
                                               self.splashView.view.frame.size.height);
    } completion:^(BOOL finished) {}];
}

-(void)hideSplashPage {
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.splashView.view.frame = CGRectMake(-self.splashView.view.frame.size.width, 0,
                                                self.splashView.view.frame.size.width,
                                                self.splashView.view.frame.size.height);
    } completion:^(BOOL finished) { }];
}

-(void)showLoginPage:(NSMutableDictionary*)data {
    [self.loginView setData:data];
    self.loginView.view.frame = CGRectMake(self.view.frame.size.width, 0,
                                           self.loginView.view.frame.size.width,
                                           self.loginView.view.frame.size.height);
    self.loginView.view.alpha = 1;

    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.loginView.view.frame = CGRectMake(0, 0,
                                                self.loginView.view.frame.size.width,
                                                self.loginView.view.frame.size.height);
    } completion:^(BOOL finished) {}];
    
    //[self.loginView.usernameInput becomeFirstResponder];
}

-(void)showSignupPage:(NSMutableDictionary*)data {
    
    [self.signupView setData:data];
    self.signupView.view.frame = CGRectMake(self.view.frame.size.width, 0,
                                           self.signupView.view.frame.size.width,
                                           self.signupView.view.frame.size.height);
    self.signupView.view.alpha = 1;
    
    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.signupView.view.frame = CGRectMake(0, 0,
                                               self.signupView.view.frame.size.width,
                                               self.signupView.view.frame.size.height);
    } completion:^(BOOL finished) {}];
    
}

-(void)hideSignupPage {
    [UIView animateWithDuration:0 delay:.3 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.signupView.view.frame = CGRectMake(-self.loginView.view.frame.size.width, 0,
                                               self.loginView.view.frame.size.width,
                                               self.loginView.view.frame.size.height);
    } completion:^(BOOL finished) {
        [self.settingsView setData];
    }];
}

-(void)hideLoginPage {
    [LocalStorage syncWithServer:^{
        NSLog(@"Done syncing");
        [self.tableView getFlurs];
        [self.settingsView setData];
    }];
    
    
    [UIView animateWithDuration:0 delay:.3 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.loginView.view.frame = CGRectMake(-self.loginView.view.frame.size.width, 0,
                                                self.loginView.view.frame.size.width,
                                                self.loginView.view.frame.size.height);
    } completion:^(BOOL finished) { }];
}

-(void)showMapPage {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self.view bringSubviewToFront:self.mapView.view];
    [self.view bringSubviewToFront:self.topBarView.view];
    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.topBarView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, TOP_BAR_HEIGHT);
        self.mapView.view.frame = CGRectMake(0, 0,
                                               self.mapView.view.frame.size.width,
                                               self.mapView.view.frame.size.height);
    } completion:^(BOOL finished) {}];
    
}

-(void)showMapPageFromLogin {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[self settingsView] setData];
    
    if (self.mapView == nil) {
        self.mapView = [[FLInitialMapViewController alloc] init];
        self.mapView.delegate = self;
        
        [self.view addSubview:self.mapView.view];
        [self addChildViewController:self.mapView];
        self.mapView.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        self.mapView.view.layer.masksToBounds = NO;
        [self.mapView.view.layer setCornerRadius:0];
        [self.mapView.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.mapView.view.layer setShadowOpacity:.4];
        [self.mapView.view.layer setShadowOffset:CGSizeMake(0.0f, 3.0f)];
    }
    
    self.topBarView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, TOP_BAR_HEIGHT);
    self.mapView.view.frame = CGRectMake(0, 0,
                                         self.mapView.view.frame.size.width,
                                         self.mapView.view.frame.size.height);

    self.topBarView.view.alpha = 0;
    self.mapView.view.alpha = 0;
    
    [self.view sendSubviewToBack:self.loginView.view];
    [self.view bringSubviewToFront:self.mapView.view];
    [self.view bringSubviewToFront:self.topBarView.view];
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.loginView.view.alpha = 0;
        self.mapView.view.alpha = 1;
        self.topBarView.view.alpha = 1;
        
    } completion:^(BOOL finished) {}];
    
}

-(void)hideMapPage {
    
    [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.mapView.view.frame = CGRectMake(self.mapView.view.frame.size.width, 0,
                                               self.mapView.view.frame.size.width,
                                               self.mapView.view.frame.size.height);
    } completion:^(BOOL finished) { }];
}

- (void) showPhotoPage:(NSMutableDictionary*)data {
    
    self.photoView = [[PhotoViewController alloc] init];
    self.photoView.delegate = self;
    [self.view addSubview:self.photoView.view];
    [self addChildViewController:self.photoView];
    [self.photoView setData:data];
    
    [self.view bringSubviewToFront:self.photoView.view];
    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.photoView.view.frame = CGRectMake(0, 0,
                                               self.photoView.view.frame.size.width,
                                               self.photoView.view.frame.size.height);
    } completion:^(BOOL finished) {}];
}

-(void)hidePhotoPage {
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.photoView.view.frame = CGRectMake(self.photoView.view.frame.size.width, 0,
                                               self.photoView.view.frame.size.width,
                                               self.photoView.view.frame.size.height);
    } completion:^(BOOL finished) {}];

    self.photoView = nil;
}

- (void) logout {
    self.splashView.view.alpha = 0;
    [self.view bringSubviewToFront:self.splashView.view];
    self.splashView.view.frame = CGRectMake(0, 0,
                                           self.splashView.view.frame.size.width,
                                           self.splashView.view.frame.size.height);
    
    [UIView animateWithDuration:.7 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.settingsView.view.alpha = 0;
        self.mapView.view.alpha = 0;
        self.topBarView.view.alpha = 0;
    } completion:^(BOOL finished) {
        self.settingsView.view.alpha = 1;
        self.mapView.view.alpha = 1;
        self.topBarView.view.alpha = 1;
        [self hideVC:self.mapView];
        [self hideVC:self.settingsView];
        [self hideVC:self.topBarView];
    }];
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.splashView.view.alpha = 1;
    } completion:^(BOOL finished) {
        
        // I AM NOW CRUSHING THE MAP ON LOGOUT
        self.mapView = nil;
    }];

    
}

- (void) haveContributedToFlur:(NSString *) objectId {
    [self.mapView justContributedToFlur:objectId];
    [self.tableView getFlurs];
}

- (void) setUpNewFlurPinWithObjectId:(NSString *)objectId {
    [self.mapView setUpNewFlurPinWithObjectId:objectId];
    [self.tableView getFlurs];
}

- (PFGeoPoint*) getCurrentLocation {
    return self.mapView.mapManager.currentLocation;
}

- (void) animateNewPin {
    [self performSelector:@selector(animateNewPinAfterDelay:) withObject:self afterDelay:.5];
}

- (IBAction) animateNewPinAfterDelay:(id)sender {
    [self.mapView addNewFlurAndAnimate];
}

- (void) hideVC:(UIViewController *) VC {
    VC.view.frame = CGRectMake(0, 1000, VC.view.frame.size.width, VC.view.frame.size.height);
}

#pragma mark -
#pragma mark Default System Code

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end