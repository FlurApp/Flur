//
//  FLCameraViewController.h
//  Flur
//
//  Created by David Lee on 10/26/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FLPin.h"

@protocol FLCameraViewControllerDelegate <NSObject>

@required
- (void) hideCameraPage;
@end

@interface FLCameraViewController : UIViewController <FLCameraViewControllerDelegate>

- (void) setData:(NSMutableDictionary *)data;

@property (nonatomic, assign) id<FLCameraViewControllerDelegate> delegate;


@end
