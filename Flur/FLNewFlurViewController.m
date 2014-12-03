//
//  FLNewFlurViewController.m
//  Flur
//
//  Created by David Lee on 12/2/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import "FLNewFlurViewController.h"
#import "FLConstants.h"

@interface FLNewFlurViewController ()

@property (nonatomic, strong) UIButton *addNewFlur;

@end


@implementation FLNewFlurViewController


- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.addNewFlur = [[UIButton alloc] initWithFrame:CGRectMake(0,0,200,100)];
    [self.addNewFlur setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.addNewFlur addTarget:self action:@selector(addFlur:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.addNewFlur setTitle:@"Drop Flur" forState:UIControlStateNormal];
    self.addNewFlur.backgroundColor = RGB(238, 0 ,255);
    self.addNewFlur.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:20];
    [self.addNewFlur setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [self.view addSubview:self.addNewFlur];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.addNewFlur attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:25]];

}

- (IBAction)addFlur:(id)sender {
    [_delegate addFlur:@"test"];
}

@end
