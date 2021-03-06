//
//  Pin.h
//  Flur
//
//  Created by Netanel Rubin on 10/20/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface FLPin : NSObject

@property (nonatomic, strong) PFGeoPoint* coordinate;
@property (nonatomic, strong) PFUser* createdBy;

@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* pinId;
@property (nonatomic, strong) NSString* prompt;

@property (nonatomic) NSInteger totalContentCount;
@property (nonatomic) BOOL haveContributedTo;
@property (nonatomic) BOOL openable;



@property (nonatomic, strong) NSDate* dateCreated;

- (instancetype) initWith: (PFObject *) object;
- (NSString *)description;

@end
