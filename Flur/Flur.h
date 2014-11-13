//
//  Flur.h
//  Pods
//
//  Created by Netanel Rubin on 11/12/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Flur : NSManagedObject

@property (nonatomic, retain) NSString * prompt;
@property (nonatomic, retain) NSNumber * numContributions;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSNumber * test;

@end
