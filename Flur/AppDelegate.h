//
//  AppDelegate.h
//  Flur
//
//  Created by Lily Hashemi on 10/1/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLPin.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//- (void) switchController:(NSString*) controllerName;
//- (void) switchController:(NSString *)controllerName withData:(NSMutableDictionary*)data;
- (void) popMyself;

+ (void) switchViewController:(NSString*)controllerName withData:(NSMutableDictionary*) data;
+ (void) popPhotoVC;
+ (void) popCameraVC;


@end

