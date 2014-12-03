//
//  FLTopBarViewController.h
//  Flur
//
//  Created by Netanel Rubin on 12/1/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLTopBarViewControllerDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;

@required

- (void)settingButtonPress;
- (void)showTablePage;
- (void)hideTablePage;
- (void) hideInfoPage;




@end

@interface FLTopBarViewController : UIViewController

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIButton *tableListButton;

@property (nonatomic, assign) id<FLTopBarViewControllerDelegate> delegate;

- (void) showInfoPageBar;
- (void) showDropFlurBar;

@end
