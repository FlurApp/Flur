//
//  Pin.m
//  Flur
//
//  Created by Netanel Rubin on 10/20/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import "FLPin.h"

@implementation FLPin

- (instancetype) initWith: (PFObject *) object {
    self = [super init];
    
    if (self) {
        self.coordinate = object[@"location"];
        self.username = object[@"username"];
        self.pinId = [object objectId];
        self.prompt = object[@"prompt"];
    }
    
    return self;
}

- (NSString *)returnPrompt {
    return self.prompt;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Latitude: %f \n Longitude: %f\n", self.coordinate.latitude, self.coordinate.longitude];
}

@end
