//
//  MainViewController.h
//  Flur
//
//  Created by David Lee on 11/23/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLInitialMapViewController.h"
#import "FLTableViewController.h"
#import "FLSettingsViewController.h"
#import "FLFlurInfoViewController.h"
#import "FLTopBarViewController.h"

#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2
#define RIGHT_PANEL_TAG 3

@interface MainViewController : UIViewController <FLInitialMapViewControllerDelegate, FLTableViewControllerDelegate, FLSettingsViewControllerDelegate>

@property (nonatomic, strong) FLInitialMapViewController *mapView;
@property (nonatomic, strong) FLSettingsViewController *settingsView;
@property (nonatomic, strong) FLTableViewController *tableView;
@property (nonatomic, strong) FLFlurInfoViewController *flurInfoView;
@property (nonatomic, strong) FLTopBarViewController *topBarView;



@property (nonatomic, assign) BOOL showingLeftPanel;
@property (nonatomic, assign) BOOL showingRightPanel;

- (instancetype) initWithData:(NSMutableDictionary *)data;


@end
