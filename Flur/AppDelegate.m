//
//  AppDelegate.m
//  Flur
//
//  Created by Lily Hashemi on 10/1/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import <Parse/Parse.h>

#import "AppDelegate.h"
#import "FLCameraViewController.h"
#import "FLInitialMapViewController.h"
#import "FLLoginViewController.h"
#import "FLMasterNavigationController.h"
#import "FLPin.h"
#import "PhotoViewController.h"

@interface AppDelegate ()


@end

@implementation AppDelegate
            
static FLMasterNavigationController *navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Initialize window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];

    // Set appearance of status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIView appearance] setTintColor:[UIColor whiteColor]];
    
    // Override point for customization after application launch.
    [Parse setApplicationId:@"***REMOVED***"
                  clientKey:@"***REMOVED***"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
//    
//    // local user core data thing
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
//                                                     inDomains:NSUserDomainMask] firstObject];
//    
//    NSString* documentName = @"MyDocument";
//    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
//    self.document = [[UIManagedDocument alloc] initWithFileURL:url];
//    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
//        [self.document openWithCompletionHandler:^(BOOL success) {
//            if (success) [self documentIsReady];
//            if (!success) NSLog(@"couldn’t open document at %@", url);
//        }]; } else {
//            [self.document saveToURL:url forSaveOperation:UIDocumentSaveForCreating
//                   completionHandler:^(BOOL success) {
//                       if (success) [self documentIsReady];
//                       if (!success) NSLog(@"couldn’t create document at %@", url);
//                   }];
//        }
//
//   
//    /*PhotoViewController * control = [[PhotoViewController alloc] initWithData:
//                                     [[NSMutableDictionary alloc]init] ];*/
//    FLLoginViewController * control_login = [FLLoginViewController new];
//    FLInitialMapViewController * control_map = [FLInitialMapViewController new];
//    UIViewController *control;
//    
////    if([self documentIsReady]) {
////        control = control_map;
////    }
////    else
////        control = control_login;
//    
//    control = control_map;
//
//
//    navController = [[UINavigationController alloc] initWithRootViewController: control];
//    [navController setNavigationBarHidden:YES];
//    navController.navigationBar.barStyle = UIBarStyleBlack;

//    self.window.rootViewController = navController;
//    self.window.backgroundColor = [UIColor blackColor];
    
    // Create navigation controller
    [FLMasterNavigationController init];
    self.window.rootViewController = [FLMasterNavigationController getNavController];
    
    // Boiler plate code from AppDelegate
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
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
