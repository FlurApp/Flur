//
//  Flur.m
//  Flur
//
//  Created by Netanel Rubin on 11/12/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import "Flur.h"


@implementation Flur

@dynamic lat;
@dynamic lng;
@dynamic numContributions;
@dynamic objectId;
@dynamic prompt;
@dynamic test;

- (instancetype) init {
    NSLog(@"INIT");
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
