//
//  MapManager.m
//  Flur
//
//  Created by Netanel Rubin on 10/20/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import "FLMapManager.h"
#import "FLPin.h"

@implementation FLMapManager

- (instancetype) init {
    self = [super init];
    
    if (self) {
        self.currentLocation = [[PFGeoPoint alloc] init];
        self.refreshLocation = [[PFGeoPoint alloc] init];
        self.nonOpenablePins = [[NSMutableDictionary alloc] init];
        self.openablePins = [[NSMutableDictionary alloc] init];
        self.firstPinGrab = true;
    }
    
    return self;
}

- (void) updateCurrentLocation: (CLLocation *) newLocation andRefreshLocation: (BOOL) shouldRefresh {
    self.currentLocation.latitude = newLocation.coordinate.latitude;
    self.currentLocation.longitude = newLocation.coordinate.longitude;
    
    if (shouldRefresh) {
        self.refreshLocation.latitude = newLocation.coordinate.latitude;
        self.refreshLocation.longitude = newLocation.coordinate.longitude;
    }
}

- (void) getViewablePins:(void (^) (NSMutableDictionary* allNonOpenablePins)) completion {
    
    [self.nonOpenablePins removeAllObjects];
    [self.openablePins removeAllObjects];
    
    PFQuery *query = [PFQuery queryWithClassName:@"FlurPin"];
    [query setLimit:10];
    [query whereKey: @"location"
       nearGeoPoint: [PFGeoPoint geoPointWithLatitude: [self currentLat]
                                           longitude: [self currentLng]]
   withinKilometers: viewablePinRadius];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (int i=0; i<objects.count; i++) {
                FLPin* pin = [[FLPin alloc] initWith: objects[i]];
                    [self.nonOpenablePins setObject:pin forKey: pin.pinId];
            }
            completion(self.nonOpenablePins);
        }
        else
            NSLog(@"fuck");
    }];
}

- (double) currentLat {
    return self.currentLocation.latitude;
}

- (double) currentLng {
    return self.currentLocation.longitude;
}

- (BOOL) shouldRefreshMap {
    
    if(self.firstPinGrab) {
        self.firstPinGrab = false;
        return true;
    }
    else if ([self.currentLocation distanceInKilometersTo: self.refreshLocation] > refreshRadius) {
        return true;
    }
    return false;
}

- (void) addFlur: (NSString *)prompt {
    PFObject *flurPin = [PFObject objectWithClassName:@"FlurPin"];
    [flurPin setObject:self.currentLocation forKey:@"location"];
    [flurPin setObject:@"default" forKey:@"username"];
    [flurPin setObject:prompt forKey: @"prompt"];
    [flurPin setObject:@0 forKey:@"contentCount"];
    
    [flurPin saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) { }
    }];
    
}

- (NSMutableArray*) getNewlyOpenablePins {
    
    NSMutableArray *pinsOpenable = [[NSMutableArray alloc] init];
  


    for (id key in self.nonOpenablePins) {

        FLPin * pin = [self.nonOpenablePins objectForKey:key];

        if ([self.currentLocation distanceInKilometersTo: pin.coordinate] < closeToPinDistance) {
            [pinsOpenable addObject: pin.pinId];
            [self.openablePins setObject:pin forKey:pin.pinId];
        }
    }
    
    [self.nonOpenablePins removeObjectsForKeys:pinsOpenable];
    return pinsOpenable;
}



- (NSMutableArray*) getNewlyNonOpenablePins {
    NSMutableArray *pinsNonOpenable = [[NSMutableArray alloc] init];
    
    for (id key in self.openablePins) {
        
        FLPin * pin = [self.openablePins objectForKey:key];
        if ([self.currentLocation distanceInKilometersTo: pin.coordinate] >= closeToPinDistance) {
            [pinsNonOpenable addObject: pin.pinId];
            [self.nonOpenablePins setObject:pin forKey:pin.pinId];
        }
    }
    
    [self.openablePins removeObjectsForKeys:pinsNonOpenable];
    return pinsNonOpenable;
}

@end
