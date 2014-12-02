//
//  FLTableViewController.h
//  Flur
//
//  Created by David Lee on 11/12/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FLCustomCellTableViewCell.h"


@protocol FLTableViewControllerDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;
- (void)showInfoPage:(NSMutableDictionary *)data;

@end

@interface FLTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, FLCustomCellTableViewDelegate>

@property (nonatomic, assign) id<FLTableViewControllerDelegate> delegate;
- (void) getFlurs;

@end
