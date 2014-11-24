//
//  FLSettingsViewController.h
//  Flur
//
//  Created by Netanel Rubin on 11/23/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLSettingsViewControllerDelegate <NSObject>
@end

@interface FLSettingsViewController : UIViewController

@property (nonatomic, assign) id<FLSettingsViewControllerDelegate> delegate;

@end
