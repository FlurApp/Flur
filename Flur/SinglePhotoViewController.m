//
//  SinglePhotoViewController.m
//  Flur
//
//  Created by Netanel Rubin on 10/13/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import "SinglePhotoViewController.h"
#import <Parse/Parse.h>

@interface SinglePhotoViewController ()

@property (strong, nonatomic) NSLayoutConstraint* yConstraint;
@property (strong, nonatomic) UIView* seeThroughContainer;



@end

@implementation SinglePhotoViewController

static bool topBarVisible = false;
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
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView setImage:[UIImage imageNamed:@""]];
    imageView.tag = 1;
    
    [self.view addSubview:imageView];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1.0
                                                             constant:0]];
    

}

// On finger press, toggle top and bottom bar
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    // CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    [self toggleViews];
}


- (void) toggleViews {
    for (UIView* view in self.viewsToToggle) {
        if (topBarVisible) {
            [UIView beginAnimations:@"fade in" context:nil];
            [UIView setAnimationDuration:.5];
            view.alpha = 0;
            [UIView commitAnimations];
        }
        else {
            [UIView beginAnimations:@"fade in" context:nil];
            [UIView setAnimationDuration:.5];
            view.alpha = 1;
            [UIView commitAnimations];
        }
    }
    topBarVisible = !topBarVisible;
}


- (void) setImage:(NSData *) data {
    
    // Create image from data and find correct subview to put it in
    UIImage *image = [UIImage imageWithData:data];
    UIImageView *imageViewPointer;
    for (UIView *subView in [self.view subviews]) {
        if (subView.tag == 1) {
            imageViewPointer = (UIImageView*) subView;
            [imageViewPointer setImage:image];
        }
    }
    
    // Calculate size of image depending on screen size
    double imageRatio = (self.view.frame.size.width)/image.size.width;
    double x = image.size.width * imageRatio;
    double y = image.size.height* imageRatio;
    
    // Set size of image
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageViewPointer
                                                       attribute:NSLayoutAttributeHeight
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1.0
                                                        constant:y]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageViewPointer
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1.0
                                                        constant:x]];
    
    
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
