//
//  PhotoViewController.h
//  Flur
//
//  Created by Netanel Rubin on 10/13/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController <UIPageViewControllerDataSource>

    @property (strong, nonatomic) UIPageViewController *pageController;
    @property (assign, nonatomic) NSString* pinId;

    - (instancetype) initWithPin: (NSString*) pinId;
- (void) method;
@end
