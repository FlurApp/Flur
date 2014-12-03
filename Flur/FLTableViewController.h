//
//  FLTableViewController.h
//  Flur
//
//  Created by David Lee on 11/12/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FLCustomCellTableViewCell.h"


@protocol FLTableViewControllerDelegate <NSObject>

@optional

@required
- (void)showInfoPage:(NSMutableDictionary *)data;

@end

@interface FLTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, FLCustomCellTableViewDelegate>

@property (nonatomic, assign) id<FLTableViewControllerDelegate> delegate;
- (void) getFlurs;

@end
