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
#import "FLPin.h"

@protocol FLInitialMapViewControllerDelegate <NSObject>

@optional
- (void)hideSettingsPage;
- (void) showContributePage:(NSMutableDictionary *)data;

@end



@interface FLInitialMapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate, UITextFieldDelegate>

@property (nonatomic, assign) id<FLInitialMapViewControllerDelegate> delegate;

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIButton *tableListButton;

- (instancetype) initWithData:(NSMutableDictionary *)data;
- (void) showWhiteLayer;
- (void) hideWhiteLayer;

- (void) addFlur:(NSString*)prompt;
- (void) justContributedToFlur:(NSString *) objectId;

- (void) addNewFlur:(FLPin *)pin;

@end
