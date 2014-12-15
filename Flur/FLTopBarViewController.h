//
//  FLTopBarViewController.h
//  Flur
//
//  Created by Netanel Rubin on 12/1/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLTopBarViewControllerDelegate <NSObject>

@optional
- (void)settingButtonPress;
- (void)showTablePage:(int)fromPhotoAlbum;
- (void)hideTablePage;
- (void)hideInfoPage;
- (void)hideDropFlurPage;



@end

@interface FLTopBarViewController : UIViewController

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIButton *tableListButton;

@property (nonatomic, assign) id<FLTopBarViewControllerDelegate> delegate;

- (void) showInfoPageBar;
- (void) showDropFlurBar;
- (void) showTableBar;
- (void) showMapBar;
- (void) showContributeBar;

- (void) revertTopBar;

@end
