//
//  Pin.m
//  Flur
//
//  Created by Netanel Rubin on 10/20/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import "FLPin.h"

@implementation FLPin

- (instancetype) initWith: (PFObject *) object {
    self = [super init];
    
    if (self) {
        self.coordinate = object[@"location"];
        self.createdBy = object[@"createdBy"];
        self.username = [object[@"createdBy"] username];
        self.pinId = [object objectId];
        self.prompt = object[@"prompt"];
        self.contentCount = [object[@"contentCount"] integerValue];
        self.haveContributedTo = false;
        
        self.dateCreated = [object createdAt];
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Pin ID: %@   haveContributedTo : %f\n", self.pinId, self.coordinate.longitude];
}

@end
