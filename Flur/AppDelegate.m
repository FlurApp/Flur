//
//  AppDelegate.m
//  Flur
//
//  Created by Lily Hashemi on 10/1/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <Parse/Parse.h>

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LocalStorage.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Initialize window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];

    // Set appearance of status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIView appearance] setTintColor:[UIColor whiteColor]];
    
    // Override point for customization after application launch.
    [Parse setApplicationId:@"removed"
                  clientKey:@"removed"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }

    
    //app badge
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // Create navigation controller
    self.window.rootViewController = [[MainViewController alloc] init];
    
    // Boiler plate code from AppDelegate
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    if ([userInfo objectForKey:@"flurObjectId"] != nil) {
        
         NSString *flurObjectId = [userInfo objectForKey:@"flurObjectId"];
         NSNumber *totalContentCount = [userInfo objectForKey:@"totalContentCount"];
        [LocalStorage updateFlurWithObjectId:flurObjectId andTotalContentCount:totalContentCount completion:^{
            [self.tvp getFlurs];
            
            NSString *message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Flur Update"
                                                            message: message
                                                           delegate: self
                                                  cancelButtonTitle: @"View"
                                                  otherButtonTitles: nil];
            // [alert show];
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
