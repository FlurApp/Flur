//
//  PhotoViewController.h
//  Flur
//
//  Created by Netanel Rubin on 10/13/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLPin.h"

@interface PhotoViewController : UIViewController <UIPageViewControllerDataSource>

    @property (strong, nonatomic) UIPageViewController *pageController;
    @property (assign, nonatomic) FLPin* pin;

    - (instancetype) initWithData: (NSMutableDictionary*) data;

@end
