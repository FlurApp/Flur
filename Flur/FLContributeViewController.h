//
//  FLContributeViewController.h
//  Flur
//
//  Created by David Lee on 11/16/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLContributeViewControllerDelegate <NSObject>
@end

@interface FLContributeViewController : UIViewController
- (id)initWithData:(NSMutableDictionary *)data;

@property (nonatomic, assign) id<FLContributeViewControllerDelegate> delegate;


@end