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

@end

@implementation SinglePhotoViewController

- (instancetype) initWithSlideUp:(bool) slideUp {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.slideUp = slideUp;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    
    if (self.slideUp) {
        self.yConstraint.constant = 1000;
        [self.view addConstraint: self.yConstraint];
    }
    else {
        [self.view addConstraint: self.yConstraint];
    }
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
    
    double imageRatio = (self.view.frame.size.width-20)/image.size.width;
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
    self.yConstraint.constant = 0;
    NSLog(@"safd");
    [UIView animateWithDuration:0.7
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
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
