//
//  FLSettingsViewController.h
//  Flur
//
//  Created by Netanel Rubin on 11/23/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLSettingsViewControllerDelegate <NSObject>

@optional
- (void)addFlur:(NSString*)prompt;
- (void)hideInfoView;

@required
-(void)showDropFlurPage;

@end


@interface FLSettingsViewController : UIViewController <FLSettingsViewControllerDelegate>

@property (nonatomic, assign) id<FLSettingsViewControllerDelegate> delegate;
@property (nonatomic, assign) id<FLSettingsViewControllerDelegate> delegate2;


@end
