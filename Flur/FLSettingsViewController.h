//
//  FLSettingsViewController.h
//  Flur
//
//  Created by Netanel Rubin on 11/23/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLSettingsViewControllerDelegate <NSObject>

@optional
- (void)addFlur:(NSString*)prompt;
- (void)hideInfoView;
- (void)hideSettingsPage;

@required
-(void)showDropFlurPage;
-(void)hideMapPage;
-(void)showSplashPage;

@end


@interface FLSettingsViewController : UIViewController <FLSettingsViewControllerDelegate>

@property (nonatomic, assign) id<FLSettingsViewControllerDelegate> delegate;

@end
