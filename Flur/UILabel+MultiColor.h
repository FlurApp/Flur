//
//  UILable+MultiColor.h
//  Flur
//
//  Created by Netanel Rubin on 11/23/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@interface UILabel (FormattedText)

- (void)setTextColor:(UIColor *)textColor range:(NSRange)range;
- (void)setFont:(UIFont *)font range:(NSRange)range;

- (void)setTextColor:(UIColor *)textColor beforeOccurenceOfString:(NSString*)separator;
- (void)setTextColor:(UIColor *)textColor afterOccurenceOfString:(NSString*)separator;
- (void)setFont:(UIFont *)font beforeOccurenceOfString:(NSString*)separator;
- (void)setFont:(UIFont *)font afterOccurenceOfString:(NSString*)separator;

@end