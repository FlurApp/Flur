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
        self.viewablePins = [[NSMutableArray alloc] init];
        self.currentLocation = [[PFGeoPoint alloc] init];
        self.refreshLocation = [[PFGeoPoint alloc] init];
    }
    
    return self;
}

- (NSMutableArray *) getViewablePins {
    
    PFQuery *query = [PFQuery queryWithClassName:@"FlurPi"];
    [query setLimit:10];
    [query whereKey: @"location"
       nearGeoPoint: [PFGeoPoint geoPointWithLatitude: [self currentLat]
                                           longitude: [self currentLng]]
   withinKilometers: viewablePinRadius];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (int i=0; i<objects.count; i++) {
                FLPin* pin = [[FLPin alloc] initWith: objects[i]];
                [self.viewablePins addObject: pin];
            }
        }
    }];

    return self.viewablePins;
}

- (double) currentLat {
    return self.currentLocation.latitude;
}

- (double) currentLng {
    return self.currentLocation.longitude;
}

- (BOOL) isCloseEnough {
    for (PFGeoPoint* pin in self.viewablePins) {
        if ([self.currentLocation distanceInKilometersTo: pin] < closeToPinDistance) {
            // WHAT
        }
    }
    return TRUE;
}

- (BOOL) shouldRefresh {
    if ([self.currentLocation distanceInKilometersTo: self.refreshLocation] > viewablePinRadius) {
        return true;
    }
    return false;
}

- (void) addFlur {
    PFObject *flurPin = [PFObject objectWithClassName:@"FlurPin"];
    [flurPin setObject:self.currentLocation forKey:@"location"];
    [flurPin setObject:@"codemang" forKey:@"username"];
    
    [flurPin saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) { }
    }];
}

@end
