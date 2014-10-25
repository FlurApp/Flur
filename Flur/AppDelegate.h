//
//  AppDelegate.h
//  Flur
//
//  Created by Lily Hashemi on 10/1/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;

- (void) switchController:(NSString*) controllerName;


@end

