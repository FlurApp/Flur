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

#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2
#define RIGHT_PANEL_TAG 3

@interface MainViewController : UIViewController <FLInitialMapViewControllerDelegate>

@property (nonatomic, strong) FLInitialMapViewController *centerViewController;
@property (nonatomic, strong) FLSettingsViewController *leftPanelViewController;
@property (nonatomic, strong) FLTableViewController *rightPanelViewController;

@property (nonatomic, assign) BOOL showingLeftPanel;
@property (nonatomic, assign) BOOL showingRightPanel;


@end