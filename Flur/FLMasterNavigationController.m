//
//  FLMasterNavigationController.m
//  Flur
//
//  Created by Lily Hashemi on 10/4/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import "FLMasterNavigationController.h"
#import "FLCameraViewController.h"
#import "PhotoViewController.h"
#import "FLInitialMapViewController.h"
#import "FLLoginViewController.h"
#import "LocalStorage.h"

@interface FLMasterNavigationController ()

@end

@implementation FLMasterNavigationController

static UINavigationController *navController;

+ (UINavigationController*) getNavController {
    return navController;
}

+ (void) init {
    UIViewController *control;
    
    [LocalStorage openDocument];
    
    // if a user is found
    //if (true) {
    if([LocalStorage getUserFound]) {
        control = [[FLInitialMapViewController alloc] init];
    }
    else
        control = [[FLLoginViewController alloc] init];
    
    navController = [[UINavigationController alloc] initWithRootViewController: control];
    [navController setNavigationBarHidden:YES];
    navController.navigationBar.barStyle = UIBarStyleBlack;
}

+ (void) switchToViewController:(NSString*)newControllerName fromViewController:(NSString*)oldControllerName withData:(NSMutableDictionary*) data {
    
    // Leaving login view
    if ([oldControllerName isEqualToString:@"FLLoginViewController"]) {
        FLInitialMapViewController *mapController = [[FLInitialMapViewController alloc] init];
        [navController popViewControllerAnimated:YES];
        [navController pushViewController:mapController animated:NO];
    }
    
    // Leaving Map View
    if ([oldControllerName isEqualToString:@"FLInitialMapViewController"]) {
        
        // Entering Camera View
        if ([newControllerName isEqualToString:@"FLCameraViewController"]) {
            
            FLCameraViewController *camController = [[FLCameraViewController alloc] initWithData:data];
            [UIView animateWithDuration:0.75
                             animations:^{
                                 [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                                 [navController pushViewController:camController animated:NO];
                                 [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:navController.view cache:NO];
                             }];
        }
    }
        
    // Leaving Camera View
    else if ([oldControllerName isEqualToString:@"FLCameraViewController"]) {
        
        // Entering Photo View
        if ([newControllerName isEqualToString:@"PhotoViewController"]) {
            NSLog(@"told you");
            PhotoViewController *photoController = [[PhotoViewController alloc] initWithData:data];
            [UIView animateWithDuration:0.75
                             animations:^{
                                 [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                                 [navController pushViewController:photoController animated:NO];
                                 [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:navController.view cache:NO];
                             }];
        }
        
        // Re-entering Map View
        else if ([newControllerName isEqualToString:@"FLInitialMapViewController"]) {
            [(FLInitialMapViewController*)navController.viewControllers[0] removeBlur];
            [navController popViewControllerAnimated:YES];
        }
    }
        
    // Leaving Photo View
    else if ([oldControllerName isEqualToString:@"PhotoViewController"]) {
        
        // Re-entering Map View
        if ([newControllerName isEqualToString:@"FLInitialMapViewController"]) {
            
            NSMutableArray* navArray = [[NSMutableArray alloc] initWithArray:navController.viewControllers];
            int position = (navController.viewControllers.count - 1);
            [navArray removeObjectAtIndex:position-1];
            
            [(FLInitialMapViewController*)[navArray objectAtIndex:0] removeBlur];
            
            [navController setViewControllers:navArray animated:YES];
            [navController popViewControllerAnimated:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            
        }
    }
    
    else {
        NSLog(@"Not a correct controllerName for switchController");
        EXIT_FAILURE;
    }
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
