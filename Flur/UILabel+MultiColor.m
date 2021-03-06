//
//  UILable+MultiColor.m
//  Flur
//
//  Created by Netanel Rubin on 11/23/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import "UILabel+MultiColor.h"

@implementation UILabel (FormattedText)

- (void)setTextColor:(UIColor *)textColor range:(NSRange)range
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: self.attributedText];
    [text addAttribute: NSForegroundColorAttributeName
                 value: textColor
                 range: range];
    
    [self setAttributedText: text];
}

- (void)setFont:(UIFont *)font range:(NSRange)range
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: self.attributedText];
    [text addAttribute: NSFontAttributeName
                 value: font
                 range: range];
    
    [self setAttributedText: text];
}

- (void)setTextColor:(UIColor *)textColor beforeOccurenceOfString:(NSString*)separator{
    
    NSRange range = [self.text rangeOfString:separator];
    
    if (range.location != NSNotFound)
    {
        range.length = range.location;
        range.location = 0;
        [self setTextColor:textColor range:range];
    }
}

- (void)setTextColor:(UIColor *)textColor afterOccurenceOfString:(NSString*)separator{
    
    NSRange range = [self.text rangeOfString:separator];
    
    if (range.location != NSNotFound)
    {
        range.location ++;
        range.length = self.text.length - range.location;
        [self setTextColor:textColor range:range];
    }
}

- (void)setFont:(UIFont *)font beforeOccurenceOfString:(NSString*)separator{
    
    NSRange range = [self.text rangeOfString:separator];
    
    if (range.location != NSNotFound)
    {
        range.length = range.location;
        range.location = 0;
        [self setFont:font range:range];
    }
}

- (void)setFont:(UIFont *)font afterOccurenceOfString:(NSString*)separator{
    
    NSRange range = [self.text rangeOfString:separator];
    
    if (range.location != NSNotFound)
    {
        range.location ++;
        range.length = self.text.length - range.location;
        [self setFont:font range:range];
    }
}

@end
