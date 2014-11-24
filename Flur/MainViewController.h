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

#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2

@interface MainViewController : UIViewController <FLInitialMapViewControllerDelegate>

@property (nonatomic, strong) FLInitialMapViewController *centerViewController;
@property (nonatomic, strong) FLTableViewController *leftPanelViewController;
@property (nonatomic, assign) BOOL showingLeftPanel;

@end
