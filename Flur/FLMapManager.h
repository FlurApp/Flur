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
- (NSMutableArray *) getViewablePins:(void (^) (NSMutableArray* allPins)) completion;
- (BOOL) isCloseEnough;
- (BOOL) shouldRefresh;
- (double) currentLat;
- (double) currentLng;
- (void) addFlur;
- (void) updateLocation: (CLLocation *) newLocation;

- (instancetype) init;

@end
