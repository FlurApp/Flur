//
//  FLSplashViewController.m
//  Flur
//
//  Created by David Lee on 11/8/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import "FLSplashViewController.h"
#import "FLMasterNavigationController.h"

@interface FLSplashViewController ()

@property (nonatomic, strong, readwrite) UIButton *signupButton;
@property (nonatomic, strong, readwrite) UIButton *loginButton;

@end

@implementation FLSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *backSplash = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"flurSplashyWithPin-iphone6"]];
    backSplash.frame = self.view.bounds;
    
    backSplash.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:backSplash];
    
    // build button for signup
    self.signupButton = [[UIButton alloc] init];
    [self.signupButton setTitle:@"Sign up" forState:UIControlStateNormal];
    [self.signupButton setTitleColor:[UIColor colorWithRed:0.33 green:0.76 blue:0.88 alpha:1.0] forState:UIControlStateNormal];
    //[[self.signupButton layer] setBorderColor:[[UIColor blackColor] CGColor]];
    //[[self.signupButton layer] setBorderWidth:1.0];
    [self.signupButton setBackgroundColor:[UIColor whiteColor]];
    [[self.signupButton layer] setCornerRadius:2];
    [self.signupButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.signupButton setEnabled:TRUE];
    [self.signupButton setCenter: self.view.center];
    [self.signupButton addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchDown];
    [[self view] addSubview:self.signupButton];
    
    // build login button
    self.loginButton = [[UIButton alloc] init];
    //[self.loginButton setBackgroundImage:[UIImage imageNamed:@"LogIn.png"] forState:UIControlStateNormal];
    
    [self.loginButton setTitle:@"Log in" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithRed:0.33 green:0.76 blue:0.88 alpha:1.0] forState:UIControlStateNormal];
    //[[self.loginButton layer] setBorderColor:[[UIColor blackColor] CGColor]];
    //[[self.loginButton layer] setBorderWidth:1.0];
    [self.loginButton setBackgroundColor:[UIColor whiteColor]];
    [[self.loginButton layer] setCornerRadius:2];
    [self.loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.loginButton setEnabled:TRUE];
    [self.loginButton setCenter: self.view.center];
    [self.loginButton addTarget:self action:@selector(loginToFlur:) forControlEvents:UIControlEventTouchDown];
    [[self view] addSubview:self.loginButton];
    
    //setting the layout for the sign up button
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.signupButton attribute:NSLayoutAttributeTop relatedBy:
                                NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-140]];
    
    /*[[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.signupButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-140]]; */
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.signupButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeLeading multiplier:1.0 constant:40]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.signupButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-40]];
    
    // set layout of login button
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeTop relatedBy:
                                NSLayoutRelationEqual toItem:[self signupButton] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:1]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeLeading multiplier:1.0 constant:40]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-40]];

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUp:(id)sender {
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    [data setObject:@"signup" forKey:@"mode"];
    [FLMasterNavigationController switchToViewController:@"FLLoginViewController"
                                      fromViewController:@"FLSplashViewController"
                                                withData:data];
    
}

- (IBAction)loginToFlur:(id)sender {
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    [data setObject:@"login" forKey:@"mode"];
    [FLMasterNavigationController switchToViewController:@"FLLoginViewController"
                                      fromViewController:@"FLSplashViewController"
                                                withData:data];
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
