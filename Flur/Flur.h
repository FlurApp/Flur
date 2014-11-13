//
//  Flur.h
//  Flur
//
//  Created by Netanel Rubin on 11/12/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Flur : NSManagedObject

- (instancetype) init;

@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSNumber * numContributions;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * prompt;
@property (nonatomic, retain) NSNumber * test;

@end
