//
//  FLLoginViewController.h
//  Flur
//
//  Created by David Lee on 11/6/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "User.h"

@protocol FLLoginViewControllerDelegate <NSObject>

@required
-(void)hideLoginPage;
-(void)showMapPage;

@end

@interface FLTextField : UITextField<UITextFieldDelegate>

@end

@interface FLLoginViewController : UIViewController <UITextFieldDelegate, FLLoginViewControllerDelegate>

- (void)setData:(NSMutableDictionary *)data;

@property (nonatomic, strong) FLTextField* usernameInput;
@property (nonatomic, strong) FLTextField* passwordInput;


@property (nonatomic, assign) id<FLLoginViewControllerDelegate> delegate;

@end

