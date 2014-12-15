//
//  PhotoViewController.h
//  Flur
//
//  Created by Netanel Rubin on 10/13/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLPin.h"

@protocol PhotoViewControllerDelegate <NSObject>

@optional
-(void)hidePhotoPage;
-(void)showMapPage;
-(void)showPhotoPage;
-(void)showTablePage:(int)fromPhotoAlbum;
- (void) animateNewPin;
@end

@interface PhotoViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, PhotoViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (assign, nonatomic) FLPin* pin;
@property (nonatomic, strong) UILabel *dateLabel;

- (void) setData: (NSMutableDictionary*) data;

@property (nonatomic, assign) id<PhotoViewControllerDelegate> delegate;

@end
