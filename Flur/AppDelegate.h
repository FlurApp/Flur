//
//  AppDelegate.h
//  Flur
//
//  Created by Lily Hashemi on 10/1/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLPin.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "User.h"
#import "FLTableViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) FLTableViewController *tvp;

@end

