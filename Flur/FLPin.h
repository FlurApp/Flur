//
//  Pin.h
//  Flur
//
//  Created by Netanel Rubin on 10/20/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface FLPin : NSObject

@property (nonatomic, strong) PFGeoPoint* coordinate;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* objectId;

- (instancetype) initWith: (PFObject *) object;
- (NSString *)description;

@end
