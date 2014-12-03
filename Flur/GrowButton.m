//
//  GrowButton.m
//  Flur
//
//  Created by Netanel Rubin on 12/2/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import "GrowButton.h"

@implementation GrowButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.


- (void)drawRect:(CGRect)rect {
    // Drawing code
    NSLog(@"drawing");
    UIView *button = [[UIView alloc] initWithFrame:rect];
    button.backgroundColor = [UIColor yellowColor];

    
    /*UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera-100.png"]];
    [imgView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button addSubview:imgView];
    
    //imgView.backgroundColor = [UIColor yellowColor];
    
    [button addConstraint:[NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [button addConstraint:[NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [button addConstraint:[NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30]];
    
    [button addConstraint:[NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30]];*/
}


@end
