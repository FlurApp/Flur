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
#define closeToPinDistance .002 //how close we are to open a pin


@interface FLMapManager : NSObject

@property (nonatomic, strong) PFGeoPoint *currentLocation;
@property (nonatomic, strong) PFGeoPoint *refreshLocation; //how we gauge that we can refresh all the pins and update map
@property (nonatomic, strong) NSMutableDictionary *openablePins; //close enough to open
@property (nonatomic, strong) NSMutableDictionary *nonOpenablePins; //you're too far away to open
@property (nonatomic) BOOL firstPinGrab;

//- (NSMutableArray*) getViewablePins;
- (void) getViewablePins:(void (^) (NSMutableDictionary* allNonOpenablePins)) completion;
- (BOOL) shouldRefreshMap;
//- (BOOL) shouldCheckOpenablePins;
- (double) currentLat;
- (double) currentLng;
- (void) addFlur;
- (void) updateCurrentLocation: (CLLocation *) newLocation andRefreshLocation: (BOOL) shouldRefresh;

- (NSMutableArray*) getNewlyOpenablePins;
- (NSMutableArray*) getNewlyNonOpenablePins;



- (instancetype) init;

@end
