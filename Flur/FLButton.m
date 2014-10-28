//
//  FLButton.m
//  Flur
//
//  Created by Lily Hashemi on 10/27/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import "FLButton.h"
#import "FLPin.h"

@implementation FLButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithPin:(FLPin *)pin {
    if (self = [super init]) {
        [self setPin:pin];
    }
    
    return self;
}

@end
