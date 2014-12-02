///Users/Dave/Flur/Flur/FLLoginViewController.m
//  FLMasterNavigationController.h
//  Flur
//
//  Created by Lily Hashemi on 10/4/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLInitialMapViewController.h"

@interface FLMasterNavigationController : UINavigationController

+ (void) init;
+ (UINavigationController*) getNavController;
+ (void) switchToViewController:(NSString*)newControllerName fromViewController:(NSString*)oldControllerName withData:(NSMutableDictionary*) data;

@end
