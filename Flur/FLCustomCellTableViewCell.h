//
//  FLCustomCellTableViewCell.h
//  Flur
//
//  Created by Netanel Rubin on 11/21/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flur.h"
@protocol FLCustomCellTableViewDelegate <NSObject>

@optional

@required
- (void) showInfo:(NSMutableDictionary *)data;

@end

@interface FLCustomCellTableViewCell : UITableViewCell

@property (nonatomic, strong)  UIButton *button1;
@property (nonatomic, strong)  UIButton *button2;
@property (nonatomic, strong)  UILabel *prompt;
@property (nonatomic, strong)  UIView *myContentView;
@property (nonatomic, strong)  UIView *rightButtonsColorLayer;

@property (nonatomic, strong) UILabel *cellPrompt;
@property (nonatomic, strong) UILabel *cellContentCount;
@property (nonatomic, strong) UILabel *cellDate;

@property (nonatomic, strong) Flur *flur;

@property (nonatomic, assign) id<FLCustomCellTableViewDelegate> delegate;


+ (void) closeCurrentlyOpenCell;


@end
