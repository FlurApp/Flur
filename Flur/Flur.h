//
//  Flur.h
//  Flur
//
//  Created by Netanel Rubin on 12/2/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Flur : NSManagedObject

@property (nonatomic, retain) NSString * creatorUsername;
@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSNumber * totalContentCount;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * prompt;
@property (nonatomic, retain) NSNumber * myContentPosition;

@end
