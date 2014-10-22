//
//  MapManager.h
//  Flur
//
//  Created by Netanel Rubin on 10/20/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#define viewablePinRadius 2
#define closeToPinDistance .2


@interface FLMapManager : NSObject

@property (nonatomic, strong) PFGeoPoint *currentLocation;
@property (nonatomic, strong) PFGeoPoint *refreshLocation;
@property (nonatomic, strong) NSMutableArray *viewablePins;

//- (NSMutableArray*) getViewablePins;
- (void) getViewablePins:(void (^) (NSMutableArray* allPins)) completion;
- (NSMutableArray *) isCloseEnoughToOpen;
- (BOOL) shouldRefreshMap;
//- (BOOL) shouldCheckOpenablePins;
- (double) currentLat;
- (double) currentLng;
- (void) addFlur;
- (void) updateCurrentLocation: (CLLocation *) newLocation andRefreshLocation: (BOOL) shouldRefresh;

- (instancetype) init;

@end
