//
//  MainViewController.m
//  Flur
//
//  Created by David Lee on 11/23/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#define CORNER_RADIUS 4
#define SLIDE_TIMING .20
#define PANEL_WIDTH 60


@interface MainViewController ()

@end

@implementation MainViewController


#pragma mark -
#pragma mark View Did Load/Unload

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

- (void)setupView
{
    // setup map view (center view)
    self.centerViewController = [[FLInitialMapViewController alloc] init];
    self.centerViewController.view.tag = CENTER_TAG;
    self.centerViewController.delegate = self;
    
    [self.view addSubview:self.centerViewController.view];
    [self addChildViewController:self.centerViewController];
    
    [self.centerViewController didMoveToParentViewController:self];
}

- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset
{
    if (value)
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
    }
}

- (void)resetMainView
{
    // remove left view and reset variables, if needed
    if (_leftPanelViewController != nil)
    {
        [self.leftPanelViewController.view removeFromSuperview];
        self.leftPanelViewController = nil;
        
        _centerViewController.menuButton.tag = 1;

        
        self.showingLeftPanel = NO;

    }
    
    if (_rightPanelViewController != nil)
    {
        [self.rightPanelViewController.view removeFromSuperview];
        self.rightPanelViewController = nil;
        
        _centerViewController.tableListButton.tag = 1;
        
        self.showingRightPanel = NO;
        
    }
    
    // remove view shadows
    [self showCenterViewWithShadow:NO withOffset:0];
}

- (UIView *)getLeftView
{
    // init view if it doesn't already exist
    if (_leftPanelViewController == nil)
    {
        // this is where you define the view for the left panel
        self.leftPanelViewController = [[FLSettingsViewController alloc] init];
        self.leftPanelViewController.view.tag = LEFT_PANEL_TAG;
        self.leftPanelViewController.delegate = _centerViewController;
        
        [self.view addSubview:self.leftPanelViewController.view];
        
        [self addChildViewController:_leftPanelViewController];
        [_leftPanelViewController didMoveToParentViewController:self];
        
        _leftPanelViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.showingLeftPanel = YES;
    
    // set up view shadows
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.leftPanelViewController.view;
    return view;
}



- (UIView *)getRightView
{
    // init view if it doesn't already exist
    if (_rightPanelViewController == nil)
    {
        // this is where you define the view for the left panel
        self.rightPanelViewController = [[FLTableViewController alloc] init];
        self.rightPanelViewController.view.tag = RIGHT_PANEL_TAG;
        self.rightPanelViewController.delegate = _centerViewController;
        
        [self.view addSubview:self.rightPanelViewController.view];
        
        [self addChildViewController:_rightPanelViewController];
        [_rightPanelViewController didMoveToParentViewController:self];
        
        _rightPanelViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.showingRightPanel = YES;
    
    // set up view shadows
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.rightPanelViewController.view;
    return view;
}

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

- (void)movePanelLeft // to show right panel
{
    UIView *childView = [self getRightView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _centerViewController.view.frame = CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
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
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             [self resetMainView];
                         }
                     }];
}

#pragma mark -
#pragma mark Default System Code

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end