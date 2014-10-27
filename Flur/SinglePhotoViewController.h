//
//  SinglePhotoViewController.h
//  Flur
//
//  Created by Netanel Rubin on 10/13/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinglePhotoViewController : UIViewController

- (instancetype) initWithSlideUp:(bool) slideUp;
- (void) setImage:(NSData *) data;


@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSString* imageName;
@property (assign, nonatomic) NSString* pinId;
@property (nonatomic) bool slideUp;
@property (strong, nonatomic) NSData* data;
@property   (strong, nonatomic) NSMutableArray *viewsToToggle;

+ (void) setTopBarVisible:(bool)visible;



@end
