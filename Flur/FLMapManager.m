//
//  MapManager.m
//  Flur
//
//  Created by Netanel Rubin on 10/20/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import "FLMapManager.h"
#import "FLPin.h"
#import "FLConstants.h"
#import "LocalStorage.h"

@interface FLMapManager() {}

@property (nonatomic, strong) NSMutableDictionary *allFlursContributedTo;
@property (nonatomic, strong) NSMutableDictionary *allFlursFromServer;

@property (nonatomic) NSInteger synchInt;


@end

@implementation FLMapManager

- (instancetype) init {
    self = [super init];
    
    if (self) {
        self.currentLocation = [[PFGeoPoint alloc] init];
        self.refreshLocation = [[PFGeoPoint alloc] init];
        
        self.nonOpenablePins = [[NSMutableDictionary alloc] init];
        self.openablePins = [[NSMutableDictionary alloc] init];
        self.allFlursFromServer = [[NSMutableDictionary alloc] init];

        self.firstPinGrab = true;
        self.synchInt = 0;
        self.allFlursContributedTo = nil;
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
    
    // Clear any data that we have stored thus far.
    [self.nonOpenablePins removeAllObjects];
    [self.openablePins removeAllObjects];
    
    // If we haven't loaded the local copy of flurs we have contributed to, load it.
    if (self.allFlursContributedTo == nil) {
        [LocalStorage getFlursInDict:^(NSMutableDictionary *data) {
            self.allFlursContributedTo = data;
            [self sendPinsToVC:completion];
        }];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"FlurPin"];
    [query includeKey:@"createdBy"];
    [query setLimit:10];
    [query whereKey: @"location"
       nearGeoPoint: [PFGeoPoint geoPointWithLatitude: [self currentLat]
                                           longitude: [self currentLng]]
   withinKilometers: viewablePinRadius];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (int i=0; i<objects.count; i++) {
                FLPin* pin = [[FLPin alloc] initWith: objects[i]];
                NSLog(@"Adding pin: %@", pin);
                
                [self.allFlursFromServer setObject:pin forKey:pin.pinId];
                
                if ([self.currentLocation distanceInKilometersTo: pin.coordinate] < closeToPinDistance)
                    [self.openablePins setObject:pin forKey: pin.pinId];
                else
                    [self.nonOpenablePins setObject:pin forKey: pin.pinId];
            }
            
            [self sendPinsToVC:completion];
            // completion(self.nonOpenablePins);
        }
        else {
            
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle:@"Cannot Connect" message:(@"No Internet Connection") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
        }
    }];
}

- (void) sendPinsToVC:(void (^) (NSMutableDictionary* allNonOpenablePins)) completion {
    self.synchInt++;
    
    if (self.synchInt == 2) {
        for (id key in self.allFlursFromServer) {
            if ([self.allFlursContributedTo objectForKey:key] != nil) {
                ((FLPin *)[self.allFlursFromServer objectForKey:key]).haveContributedTo = true;
            }
        }
        completion(self.allFlursFromServer);
    }
}

- (double) currentLat {
    return self.currentLocation.latitude;
}

- (double) currentLng {
    return self.currentLocation.longitude;
}

- (BOOL) shouldRefreshMap {
    
    if (self.firstPinGrab) {
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
    [flurPin setObject: [PFUser currentUser]forKey:@"createdBy"];
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

- (void) justContributedToFlur:(NSString *) objectId {
    NSLog(@"Have Contributed 3");
    NSLog(@"ObjectId: %@",objectId);
    NSLog(@"Pin1: %@", (FLPin*)self.openablePins[objectId]);
    ((FLPin*)self.openablePins[objectId]).haveContributedTo = true;


}

@end
