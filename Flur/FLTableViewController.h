//
//  FLTableViewController.h
//  Flur
//
//  Created by David Lee on 11/12/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLTableViewControllerDelegate <NSObject>
@end

@interface FLTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) id<FLTableViewControllerDelegate> delegate;

@end
