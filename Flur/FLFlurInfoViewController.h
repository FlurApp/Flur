//
//  FLFlurInfoViewController.h
//  Flur
//
//  Created by Netanel Rubin on 11/23/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;
@import CoreLocation;

@protocol FLFlurInfoViewControllerDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;


@required
- (void)hideContributePage;
- (void)hideInfoPage;

@end

@interface FLFlurInfoViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>

- (instancetype) initWithData:(NSMutableDictionary *)data;
@property (nonatomic, assign) id<FLFlurInfoViewControllerDelegate> delegate;
- (void) setData:(NSMutableDictionary *)data;


@end
