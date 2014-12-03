//
//  FLContributeViewController.m
//  Flur
//
//  Created by David Lee on 11/16/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import "FLContributeViewController.h"
#import "FLPin.h"
#import <QuartzCore/QuartzCore.h>
#import "FLConstants.h"

@interface FLContributeViewController ()

@property (nonatomic, readwrite) FLPin* pin;
@property (nonatomic, strong) UIButton *contributeButton;
@property (nonatomic, strong) NSLayoutConstraint *contributeButtonLeading;
@property (nonatomic, strong) NSLayoutConstraint *contributeButtonTrailing;
@property (nonatomic, strong) CABasicAnimation *contributeButtonAnimation;


@end


@implementation FLContributeViewController


- (id)initWithData:(NSMutableDictionary *)data {
    self = [super init];
    if (self) {
        FLPin *pin = [data objectForKey:@"FLPin"];
        self.pin = pin;
        self.view.opaque = NO;
        self.view.backgroundColor = RGBA(256,256,256,.4);
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.view.tintColor = contributeColor;
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    // white overlay box
    CGRect whiteBoxRect = [[UIScreen mainScreen] bounds];
    whiteBoxRect.size.height /=2;
    UIView *whiteBox = [[UIView alloc] initWithFrame:whiteBoxRect];
    whiteBox.backgroundColor = [UIColor whiteColor];
    whiteBox.alpha = 1;
    
    // pin prompt
    
    UILabel *promptLabel = [[UILabel alloc] init];
    [promptLabel setText:[self.pin prompt]];
    [promptLabel setTextColor:contributeColor];
    [promptLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:30]];
    [promptLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [promptLabel setNumberOfLines: 0];
    [promptLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // pin date
    
    UILabel *dateLabel = [[UILabel alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d, Y"];
    NSString *dateText = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[self.pin dateCreated]]];
    [dateLabel setText: dateText];
    [dateLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:20]];
    [dateLabel setTextColor:contributeColor];
    [dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // pin contentCount
    
    NSNumber *n = [NSNumber numberWithInt:[self.pin contentCount]];
    UILabel *contentCountLabel = [[UILabel alloc] init];
    [contentCountLabel setText: [NSString stringWithFormat:@"Count: %@",n]];
    [contentCountLabel setTextColor:contributeColor];
    [contentCountLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:20]];
    [contentCountLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // contribute button underlay
    UIView *contributeUnderlay = [[UIView alloc] initWithFrame:CGRectZero];
    contributeUnderlay.backgroundColor = [UIColor whiteColor];
    [contributeUnderlay setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    // contribute button
    
    self.contributeButton = [[UIButton alloc] init];
    [self.contributeButton setTitle:@"Go!" forState:UIControlStateNormal];
    [self.contributeButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [self.contributeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    //[[contributeButton layer] setCornerRadius:2];
    self.contributeButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:20];
    //[[contributeButton layer] setBorderColor:[contributeColor CGColor]];
    //[[contributeButton layer] setBorderWidth:2.0];
    [[self.contributeButton layer] setBackgroundColor: [contributeColor CGColor]];
    [self.contributeButton setCenter: self.view.center];
    [self.contributeButton addTarget:self action:@selector(contributingToFlur:) forControlEvents:UIControlEventTouchUpInside];
    [self.contributeButton addTarget:self action:@selector(contributingTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contributeButton addTarget:self action:@selector(contributingTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    
    // separator
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, 1)];
    lineView.backgroundColor = contributeColor;
    
    
    // add subviews
    [self.view addSubview:whiteBox];
    [whiteBox addSubview:promptLabel];
    [whiteBox addSubview:dateLabel];
    [whiteBox addSubview:contentCountLabel];
    [whiteBox addSubview:lineView];
    [self.view addSubview:contributeUnderlay];
    [contributeUnderlay addSubview:self.contributeButton];
    
    // do layout
    
    // white box top, view top
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:whiteBox attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    // date top, view top
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:30]];
    
    // date leading, view leading
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    
    // date right, content count left
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:contentCountLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10]];
    
    // content count top, date top
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentCountLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    // prompt label
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:promptLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:100]];
    
    // prompt label
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:promptLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    // prompt label
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:promptLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    // prompt label
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:promptLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:promptLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10]];
    
    // contribute button bottom, view bottom
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:contributeUnderlay attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    // contribute button top, view bottom
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:contributeUnderlay attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-70]];
    
    // contribute button leading view leading
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:contributeUnderlay attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    // contribute button trailing view trailing
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:contributeUnderlay attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    // contribute button contribute underlay
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.contributeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contributeUnderlay attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    // contribute button contribute underlay
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.contributeButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contributeUnderlay attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    // contribute button contribute underlay
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.contributeButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:contributeUnderlay attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    // contribute button contribute underlay
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.contributeButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:contributeUnderlay attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    
    // fade in contribute button
    contributeUnderlay.opaque = NO;
    CABasicAnimation *fadeInAndOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAndOut.duration = 0.8;
    fadeInAndOut.autoreverses = YES;
    fadeInAndOut.fromValue = [NSNumber numberWithFloat:1.0];
    fadeInAndOut.toValue = [NSNumber numberWithFloat:0.7];
    fadeInAndOut.repeatCount = HUGE_VALF;
    fadeInAndOut.fillMode = kCAFillModeBoth;
    self.contributeButtonAnimation = fadeInAndOut;
    [self.contributeButton.layer addAnimation:self.contributeButtonAnimation forKey:@"myanimation"];
    
    // click anyhwere to exit back to map
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(exitContribute:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

- (IBAction)contributingToFlur:(id)sender {
    [self.contributeButton setBackgroundColor:contributeColor];
    
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    [data setObject:self.pin forKey:@"FLPin"];
}

- (IBAction)contributingTouchDown:(id)sender {
    self.contributeButton.backgroundColor = darkContributeColor;
    [self.contributeButton.layer removeAllAnimations];
}

- (IBAction)contributingTouchUpOutside:(id)sender {
    self.contributeButton.backgroundColor = contributeColor;
    [self.contributeButton.layer addAnimation:self.contributeButtonAnimation forKey:@"myanimation"];
}

- (void)exitContribute:(UITapGestureRecognizer *)recognizer {
    [self.view removeFromSuperview];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end