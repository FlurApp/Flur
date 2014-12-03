//
//  FLCameraViewController.h
//  Flur
//
//  Created by David Lee on 10/26/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLCameraViewControllerDelegate <NSObject>

@optional
- (void) hideCameraPage;
- (void) showPhotoPage:(NSMutableDictionary*)data;
- (void) haveContributedToFlur:(NSString *) objectId;
@end

@interface FLCameraViewController : UIViewController <FLCameraViewControllerDelegate>

- (void) setData:(NSMutableDictionary *)data;

@property (nonatomic, assign) id<FLCameraViewControllerDelegate> delegate;


@end
