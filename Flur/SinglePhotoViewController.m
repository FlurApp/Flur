//
//  SinglePhotoViewController.m
//  Flur
//
//  Created by Netanel Rubin on 10/13/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import "SinglePhotoViewController.h"
#import <Parse/Parse.h>

@interface SinglePhotoViewController ()

@property (strong, nonatomic) NSLayoutConstraint* yConstraint;
@property (strong, nonatomic) UIView* seeThroughContainer;
@property (nonatomic, strong) UIImageView *imageViewContainer;

@end

@implementation SinglePhotoViewController

static bool topBarVisible = true;
static bool firstToggle = true;


- (instancetype) initWithSlideUp:(bool) slideUp {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.slideUp = slideUp;
    }
    return self;
}

+ (void) setTopBarVisible:(bool)visible {
    topBarVisible = visible;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    // Create a clear container for detecting finger presses
    self.seeThroughContainer = [[UIView alloc] initWithFrame:CGRectZero];
    self.seeThroughContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.seeThroughContainer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.seeThroughContainer];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.seeThroughContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.seeThroughContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.seeThroughContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.seeThroughContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];

    // Add finger press detection
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.seeThroughContainer addGestureRecognizer:singleFingerTap];

    
    // Add image container for displaying images, initially empty image
    self.imageViewContainer = [[UIImageView alloc] init];
    self.imageViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.imageViewContainer setImage:[UIImage imageNamed:@""]];
    
    [self.view addSubview:self.imageViewContainer];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.imageViewContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
        [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.imageViewContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
}

// On finger press, toggle top and bottom bar
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    // CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    [self toggleViews];
}


- (void) toggleViews {
    firstToggle = false;
    for (UIView* view in self.viewsToToggle) {
        if (topBarVisible) {
            [UIView beginAnimations:@"fade in" context:nil];
            [UIView setAnimationDuration:.5];
            view.alpha = 0;
            [UIView commitAnimations];
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }
        else {
            [UIView beginAnimations:@"fade in" context:nil];
            [UIView setAnimationDuration:.5];
            view.alpha = 1;
            [UIView commitAnimations];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];

        }
    }
    topBarVisible = !topBarVisible;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void) setImage:(NSData *) data {
    
    // Create image from data and find correct subview to put it in
    UIImage *image = [UIImage imageWithData:data];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setClipsToBounds:YES];
    [imageView setFrame:self.view.frame];
    
    [self.imageViewContainer addSubview:imageView];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:imageView.superview
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:imageView.superview
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:imageView.superview
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:imageView.superview
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0]];
    
    
    
    [self.view layoutIfNeeded];
    
    if (firstToggle) {
        firstToggle = false;
        [self performSelector:@selector(toggleViews) withObject:self afterDelay:3];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
