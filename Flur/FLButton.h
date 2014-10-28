//
//  FLButton.h
//  Flur
//
//  Created by Lily Hashemi on 10/27/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLPin.h"

@interface FLButton : UIButton

@property (nonatomic, readwrite) FLPin* pin;

-(id)initWithPin:(FLPin *)pin;

@end
