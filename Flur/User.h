//
//  User.h
//  Flur
//
//  Created by Netanel Rubin on 11/5/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * passwordHash;
@property (nonatomic, retain) NSString * username;

@end
