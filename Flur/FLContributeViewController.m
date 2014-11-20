//
//  FLContributeViewController.m
//  Flur
//
//  Created by David Lee on 11/16/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import "FLContributeViewController.h"
#import "FLPin.h"
#import "FLMasterNavigationController.h"

@interface FLContributeViewController ()


@property (nonatomic, readwrite) FLPin* pin;

@end


#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define purp RGB(186,108,224)

@implementation FLContributeViewController


- (id)initWithData:(NSMutableDictionary *)data {
    self = [super init];
    if (self) {
        FLPin *pin = [data objectForKey:@"FLPin"];
        self.pin = pin;
        self.view.opaque = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.view.tintColor = purp;
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    self.view.backgroundColor = RGBA(255,255,255,.7);
    
    // white overlay box
    CGRect whiteBoxRect = [[UIScreen mainScreen] bounds];
    whiteBoxRect.size.height /=2;
    UIView *whiteBox = [[UIView alloc] initWithFrame:whiteBoxRect];
    whiteBox.backgroundColor = [UIColor whiteColor];
    
    // pin prompt
    
    UILabel *promptLabel = [[UILabel alloc] init];
    [promptLabel setText:[self.pin prompt]];
    [promptLabel setTextColor:purp];
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
    [dateLabel setTextColor:purp];
    [dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    // pin contentCount
    
    NSNumber *n = [NSNumber numberWithInt:[self.pin contentCount]];
    UILabel *contentCountLabel = [[UILabel alloc] init];
    [contentCountLabel setText: [NSString stringWithFormat:@"Count: %@",n]];
    [contentCountLabel setTextColor:purp];
    [contentCountLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:20]];
    [contentCountLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // contribute button
    
    UIButton *contributeButton = [[UIButton alloc] init];
    [contributeButton setTitle:@"Contribute" forState:UIControlStateNormal];
    [contributeButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [contributeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[contributeButton layer] setCornerRadius:2];
    contributeButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:20];
    //[[contributeButton layer] setBorderColor:[purp CGColor]];
    //[[contributeButton layer] setBorderWidth:2.0];
    [[contributeButton layer] setBackgroundColor: [purp CGColor]];
    [contributeButton setCenter: self.view.center];
    [contributeButton addTarget:self action:@selector(contributingToFlur:) forControlEvents:UIControlEventTouchDown];
    
    // separator
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, 1)];
    lineView.backgroundColor = purp;


    // add subviews
    [self.view addSubview:whiteBox];
    [whiteBox addSubview:promptLabel];
    [whiteBox addSubview:dateLabel];
    [whiteBox addSubview:contentCountLabel];
    [whiteBox addSubview:lineView];
    [self.view addSubview:contributeButton];

    
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
        [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:contributeButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
        // contribute button top, view bottom
        [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:contributeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-70]];
    
        // contribute button leading view leading
        [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:contributeButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
        // contribute button trailing view trailing
        [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:contributeButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    // click anyhwere to exit back to map
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(exitContribute:)];
    [self.view addGestureRecognizer:singleFingerTap];
    
    
    // tryina animate the button
    CABasicAnimation *theAnimation;
    
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration=0.7;
    theAnimation.repeatCount=HUGE_VALF;
    theAnimation.autoreverses=YES;
    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation.toValue=[NSNumber numberWithFloat:0.8];
    [contributeButton.layer addAnimation:theAnimation forKey:@"animateOpacity"];

}

- (IBAction)contributingToFlur:(id)sender {
    NSLog(@"clicked contribute");
    
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    [data setObject:self.pin forKey:@"FLPin"];
    [self dismissViewControllerAnimated:YES completion:nil];
    [FLMasterNavigationController switchToViewController:@"FLCameraViewController"
                                      fromViewController:@"FLContributeViewController"
                                                withData:data];
}

- (void)exitContribute:(UITapGestureRecognizer *)recognizer {
    [self dismissViewControllerAnimated:YES completion:nil];
    [FLMasterNavigationController switchToViewController:@"FLInitialMapViewController"
                                      fromViewController:@"FLContributeViewController"
                                                withData:nil];
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
