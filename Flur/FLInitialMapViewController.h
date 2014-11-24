//
//  FLInitialMapViewController.h
//  Flur
//
//  Created by Lily Hashemi on 10/4/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
@import MapKit;

#import "FLTableViewController.h"

@protocol FLInitialMapViewControllerDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;

@end
@interface FLInitialMapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate, UITextFieldDelegate, FLTableViewControllerDelegate>

@property (nonatomic, assign) id<FLInitialMapViewControllerDelegate> delegate;

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIButton *tableListButton;


@end
