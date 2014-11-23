//
//  MainViewController.h
//  Flur
//
//  Created by David Lee on 11/23/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLInitialMapViewController.h"

#define CENTER_TAG 1

@interface MainViewController : UIViewController <FLInitialMapViewControllerDelegate>

@property (nonatomic, strong) FLInitialMapViewController *mapViewController;

@end
