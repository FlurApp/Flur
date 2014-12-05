//
//  FLNewFlurViewController.h
//  Flur
//
//  Created by David Lee on 12/2/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLNewFlurViewControllerDelegate <NSObject>

@optional
- (void)addFlurToCamera: (NSMutableDictionary*)data;

@end


@interface FLNewFlurViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, assign) id<FLNewFlurViewControllerDelegate> delegate;



- (void) setFocus;



@end
