//
//  FLSignupViewController.h
//  Flur
//
//  Created by David Lee on 12/10/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLSignupViewControllerDelegate <NSObject>
@optional
- (void)hideSignupPage;
- (void)showMapPageFromLogin;
- (void)showSplashPage;
@end


@interface FLSignupViewController : UIViewController
@property (nonatomic, assign) id<FLSignupViewControllerDelegate> delegate;

- (void)setData:(NSMutableDictionary *)data;

@end
