//
//  MainViewController.m
//  Flur
//
//  Created by David Lee on 11/23/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "FLConstants.h"
#import "LocalStorage.h"

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
    self.settingsView.view.tag = LEFT_PANEL_TAG;
   
    
    [self.view addSubview:self.settingsView.view];
    [self addChildViewController:self.settingsView];
    
    self.settingsView.view.frame = CGRectMake(0, 0,
                                              self.view.frame.size.width,
                                              self.view.frame.size.height);
    
    /* -------------------------------------------
     Setup Map View.
     -----------------------------------------------*/
    self.mapView = [[FLInitialMapViewController alloc] init];
    self.mapView.view.tag = CENTER_TAG;
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView.view];
    [self addChildViewController:self.mapView];
    self.mapView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
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
    
    self.topBarView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, TOP_BAR_HEIGHT);
    
    
    /* -------------------------------------------
                    Setup Table View.
     -----------------------------------------------*/
    self.tableView = [[FLTableViewController alloc] init];
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView.view];
    
    [self addChildViewController:self.tableView];
    
    self.tableView.view.frame = CGRectMake(self.view.frame.size.width, TOP_BAR_HEIGHT,
                                           self.view.frame.size.width, self.view.frame.size.height);
    
    
    
    /* -------------------------------------------
                Setup Flur INfo View.
     -----------------------------------------------*/
    self.flurInfoView = [[FLFlurInfoViewController alloc] init];
    self.flurInfoView.delegate = self;
    
    [self.view addSubview:self.flurInfoView.view];
    
    [self addChildViewController:self.flurInfoView];
    
    self.flurInfoView.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    
    

    
    if (self.shouldSync) {
        NSLog(@"yessss");
        [LocalStorage syncWithServer:^{
            [self.tableView getFlurs];
        }];
    }
    else {
        [LocalStorage getFlurs:^(NSMutableDictionary *data) {
            NSLog(@"wtf");
        }];
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
             
    } completion:^(BOOL finished) { }];
}

- (void) tableButtonPress {
    if (self.tableVisible)
        [self hideTablePage];
    else
        [self showTablePage];

}

- (void) showTablePage {
    self.tableVisible = true;
    [self.tableView didMoveToParentViewController:self];

    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.mapView.view.frame = CGRectMake(-self.view.frame.size.width, 0,
                                             self.view.frame.size.width,
                                             self.view.frame.size.height);
        
        self.tableView.view.frame = CGRectMake(0, TOP_BAR_HEIGHT, self.view.frame.size.width,
                                               self.view.frame.size.height);
        
    } completion:^(BOOL finished) { }];
    
}

- (void) hideTablePage {
    self.tableVisible = false;
    [self.mapView didMoveToParentViewController:self];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.mapView.view.frame = CGRectMake(0, 0,
                                             self.view.frame.size.width,
                                             self.view.frame.size.height);
        
        self.tableView.view.frame = CGRectMake(self.view.frame.size.width, TOP_BAR_HEIGHT, self.view.frame.size.width,
                                               self.view.frame.size.height);
        
    } completion:^(BOOL finished) { }];
}


- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset
{
    /*if (value)
    {
        [_centerViewController.view.layer setCornerRadius:CORNER_RADIUS];
        [_centerViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_centerViewController.view.layer setShadowOpacity:0.0];
        [_centerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        
    }
    else
    {
        [_centerViewController.view.layer setCornerRadius:0.0f];
        [_centerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }*/
}

/*- (void)resetMainView
{

        
    _centerViewController.menuButton.tag = 1;
    self.showingLeftPanel = NO;
    _centerViewController.tableListButton.tag = 1;
    self.showingRightPanel = NO;
    
    [_centerViewController didMoveToParentViewController:self];

    
    // remove view shadows
    [self showCenterViewWithShadow:NO withOffset:0];
}*/

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
}

#pragma mark -
#pragma mark Delegate Actions
- (void) showInfoPage {
    _flurInfoVC.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                        _flurInfoVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                         }
                     }];
    
}

- (void)movePanelLeft // to show right panel
{

    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _centerViewController.view.frame = CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
                         _rightPanelViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             _centerViewController.menuButton.tag = 0;
                         }
                     }];

}

- (void)movePanelRight // to show left panel
{
    
    UIView *childView = [self getLeftView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _centerViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                         _leftPanelViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             _centerViewController.menuButton.tag = 0;
                         }
                     }];
}

- (void)movePanelToOriginalPosition
{
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _centerViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         
                         if (self.showingLeftPanel)
                             _leftPanelViewController.view.frame = CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
                         else
                             _rightPanelViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
                             
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             [self resetMainView];
                         }
                     }];
}*/

#pragma mark -
#pragma mark Default System Code

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end