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
@property (nonatomic) bool topBarVisible;



@end

@implementation SinglePhotoViewController

- (instancetype) initWithSlideUp:(bool) slideUp {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.slideUp = slideUp;
        self.topBarVisible = false;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.seeThroughContainer = [[UIView alloc] initWithFrame:CGRectZero];
    self.seeThroughContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.seeThroughContainer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.seeThroughContainer];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.seeThroughContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.seeThroughContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.seeThroughContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.seeThroughContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];

    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.seeThroughContainer addGestureRecognizer:singleFingerTap];

    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView setImage:[UIImage imageNamed:@""]];
    imageView.tag = 1;
    
    [self.view addSubview:imageView];
    
    
    self.yConstraint = [NSLayoutConstraint constraintWithItem:imageView
                                               attribute:NSLayoutAttributeCenterY
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:self.view
                                               attribute:NSLayoutAttributeCenterY
                                              multiplier:1.0
                                                constant:0];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    if (self.slideUp) {
        self.yConstraint.constant = 1000;
        [self.view addConstraint: self.yConstraint];
    }
    else {
        [self.view addConstraint: self.yConstraint];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    [self toggleViews];
}

- (void) toggleViews {
    for (UIView* view in self.viewsToToggle) {
        if (self.topBarVisible) {
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
    self.topBarVisible = !self.topBarVisible;
}

- (void) setImage:(NSData *) data {
    UIImage *image = [UIImage imageWithData:data];
    UIImageView *imageViewPointer;
    for (UIView *subView in [self.view subviews]) {
        if (subView.tag == 1) {
            imageViewPointer = (UIImageView*) subView;
            [imageViewPointer setImage:image];
        }
    }
    
    double imageRatio = (self.view.frame.size.width)/image.size.width;
    double x = image.size.width * imageRatio;
    double y = image.size.height* imageRatio;
    
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
    
    if (self.slideUp) {
        NSLog(@"helloooo");
        self.yConstraint.constant = 0;
        [UIView animateWithDuration:0.7
                         animations:^{
                             [self.view layoutIfNeeded];
                             [self performSelector:@selector(toggleViews) withObject:self afterDelay:.70];

                         }];
    }
}

- (void) displayImage:(NSData* ) data {
    UIImage *image = [UIImage imageWithData:data];
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView setImage:image];
    
    [self.view addSubview:imageView];

    
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
