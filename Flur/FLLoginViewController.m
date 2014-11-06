//
//  FLLoginViewController.m
//  Flur
//
//  Created by David Lee on 11/6/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import "FLLoginViewController.h"

@interface FLLoginViewController ()

@property (nonatomic, strong, readwrite) UIButton *signupButton;
@property (nonatomic, strong, readwrite) UIButton *loginButton;


@end

@implementation FLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // build button for signup
    self.signupButton = [[UIButton alloc] init];
    [self.signupButton setTitle:@"Sign up" forState:UIControlStateNormal];
    [self.signupButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[self.signupButton layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[self.signupButton layer] setBorderWidth:1.0];
    [[self.signupButton layer] setCornerRadius:10];
    [self.signupButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.signupButton setEnabled:TRUE];
    [self.signupButton setCenter: self.view.center];
    [self.signupButton addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchDown];
    [[self view] addSubview:self.signupButton];
    
    // build login button
    self.loginButton = [[UIButton alloc] init];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[self.loginButton layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[self.loginButton layer] setBorderWidth:1.0];
    [[self.loginButton layer] setCornerRadius:10];
    [self.loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.loginButton setEnabled:TRUE];
    [self.loginButton setCenter: self.view.center];
    [self.loginButton addTarget:self action:@selector(loginToFlur:) forControlEvents:UIControlEventTouchDown];
    [[self view] addSubview:self.loginButton];
    
    //setting the layout for the sign up button
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.signupButton attribute:NSLayoutAttributeTop relatedBy:
                                NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-180]];
    
    /*[[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.signupButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-140]]; */
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.signupButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeLeading multiplier:1.0 constant:30]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.signupButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-30]];
    
    // set layout of login button
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeTop relatedBy:
                                NSLayoutRelationEqual toItem:[self signupButton] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeLeading multiplier:1.0 constant:30]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-30]];
    

}

- (IBAction)signUp:(id)sender {
    NSLog(@"clicked sign up!");
    
    //do a bunch of sign up shit:
}

- (IBAction)loginToFlur:(id)sender {
    NSLog(@"clicked sign up!");
    
    //do a bunch of login shit:
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
