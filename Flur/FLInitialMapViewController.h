//
//  FLInitialMapViewController.h
//  Flur
//
//  Created by Lily Hashemi on 10/4/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
@import MapKit;

#import "FLTableViewController.h"
#import "FLSettingsViewController.h"
#import "FLContributeViewController.h"

@protocol FLInitialMapViewControllerDelegate <NSObject>

@optional
- (void)hideSettingsPage;

@end



@interface FLInitialMapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate, UITextFieldDelegate>

@property (nonatomic, assign) id<FLInitialMapViewControllerDelegate> delegate;

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIButton *tableListButton;

- (instancetype) initWithData:(NSMutableDictionary *)data;
- (void) showWhiteLayer;
- (void) hideWhiteLayer;

- (void) addFlur:(NSString*)prompt;


@property (nonatomic, strong) FLContributeViewController *contributeController;

@end
