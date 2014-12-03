//
//  FLSplashViewController.h
//  Flur
//
//  Created by David Lee on 11/8/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLSplashViewControllerDelegate <NSObject>

@optional
-(void)hideSplashPage;
-(void)showLoginPage:(NSMutableDictionary*)data;

@end

@interface FLSplashViewController : UIViewController <FLSplashViewControllerDelegate>

@property (nonatomic, assign) id<FLSplashViewControllerDelegate> delegate;

@end
