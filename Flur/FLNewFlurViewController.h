//
//  FLNewFlurViewController.h
//  Flur
//
//  Created by David Lee on 12/2/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLNewFlurViewControllerDelegate <NSObject>

@required
-(void) addFlur: (NSString*)prompt;

@end

@interface FLNewFlurViewController : UIViewController

@property (nonatomic, assign) id<FLNewFlurViewControllerDelegate> delegate;

@end
