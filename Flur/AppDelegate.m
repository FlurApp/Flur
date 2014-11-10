//
//  AppDelegate.m
//  Flur
//
//  Created by Lily Hashemi on 10/1/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import "AppDelegate.h"
#import "FLInitialMapViewController.h"
#import "PhotoViewController.h"
#import "FLCameraViewController.h"
#import "FLLoginViewController.h"
#import "FLPin.h"
#import "FLLoginViewController.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@property (nonatomic, strong) UIManagedDocument * document;

@end

@implementation AppDelegate
            
static UINavigationController *navController;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIView appearance] setTintColor:[UIColor whiteColor]];
    
    // Override point for customization after application launch.
    [Parse setApplicationId:@"***REMOVED***"
                  clientKey:@"***REMOVED***"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    // local user core data thing
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] firstObject];
    
    NSString* documentName = @"MyDocument";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    self.document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            if (success) [self documentIsReady];
            if (!success) NSLog(@"couldn’t open document at %@", url);
        }]; } else {
            [self.document saveToURL:url forSaveOperation:UIDocumentSaveForCreating
                   completionHandler:^(BOOL success) {
                       if (success) [self documentIsReady];
                       if (!success) NSLog(@"couldn’t create document at %@", url);
                   }];
        }

   
    /*PhotoViewController * control = [[PhotoViewController alloc] initWithData:
                                     [[NSMutableDictionary alloc]init] ];*/
    FLLoginViewController * control_login = [FLLoginViewController new];
    FLInitialMapViewController * control_map = [FLInitialMapViewController new];
    UIViewController *control;
    
//    if([self documentIsReady]) {
//        control = control_map;
//    }
//    else
//        control = control_login;
    
    control = control_map;


    navController = [[UINavigationController alloc] initWithRootViewController: control];
    [navController setNavigationBarHidden:YES];
    navController.navigationBar.barStyle = UIBarStyleBlack;

    self.window.rootViewController = navController;
    self.window.backgroundColor = [UIColor blackColor];
    
    // Setup navigation bar programmatically
    
    // Boiler plate code from AppDelegate
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

+ (void) switchViewController:(NSString*)controllerName withData:(NSMutableDictionary*) data {
    if ([controllerName isEqualToString:@"FLCameraViewController"]) {
        
        FLCameraViewController *camController = [[FLCameraViewController alloc] initWithData:data];
        [UIView animateWithDuration:0.75
                         animations:^{
                             [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                             [navController pushViewController:camController animated:NO];
                             [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:navController.view cache:NO];
                         }];
    } else if ([controllerName isEqualToString:@"PhotoViewController"]) {
        PhotoViewController *photoController = [[PhotoViewController alloc] initWithData:data];
        [UIView animateWithDuration:0.75
                         animations:^{
                             [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                             [navController pushViewController:photoController animated:NO];
                             [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:navController.view cache:NO];
                         }];
    } else {
        NSLog(@"Not a correct controllerName for switchController");
        EXIT_FAILURE;
    }
}

+ (void) popPhotoVC {
    NSLog(@"Called correctly");
    NSMutableArray* navArray = [[NSMutableArray alloc] initWithArray:navController.viewControllers];
    [navArray removeObjectAtIndex:1];
    
    [(FLInitialMapViewController*)[navArray objectAtIndex:0] removeBlur];
    
    [navController setViewControllers:navArray animated:YES];
    [navController popViewControllerAnimated:YES];
}

+ (void) popCameraVC {
    NSMutableArray* navArray = [[NSMutableArray alloc] initWithArray:navController.viewControllers];
    [navArray removeLastObject];
    
    [(FLInitialMapViewController*)[navArray objectAtIndex:0] removeBlur];
    
    [navController setViewControllers:navArray animated:YES];
    [navController popViewControllerAnimated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void) popMyself {
    /*[UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navController.view cache:NO];
                     }];
    [self.navController popViewControllerAnimated:NO];*/
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    //[self.navController.view.layer addAnimation:transition forKey:nil];
    //[[self navController] popViewControllerAnimated:NO];
}

- (BOOL) documentIsReady {
    NSLog(@"HELOOOO");
    if (self.document.documentState == UIDocumentStateNormal) { // start using document
        
        NSManagedObjectContext *context = self.document.managedObjectContext;
        
        /*User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
         inManagedObjectContext:context];*/
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        request.fetchBatchSize = 1;
        request.fetchLimit = 1;
        
        NSError *error;
        NSArray *users = [context executeFetchRequest:request error:&error];
        if (!users) {
            NSLog(@"Error loading user");
            return false;
        }
        else {
            if (users.count == 1) {
                NSLog(@"we have a user");
                return true;
            }
            else {
                return false;
            }
            //[self.document.managedObjectContext deleteObject:users[0]];
            //users = nil;
        }
    }
    return false;
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
