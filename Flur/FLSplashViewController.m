//
//  FLSplashViewController.m
//  Flur
//
//  Created by David Lee on 11/8/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import "FLSplashViewController.h"
#import "FLConstants.h"

@interface FLSplashViewController ()

@property (nonatomic, strong, readwrite) UIButton *signupButton;
@property (nonatomic, strong, readwrite) UIButton *loginButton;
@property (nonatomic, strong, readwrite) NSLayoutConstraint *loginButtonContraint;
@property (nonatomic, strong, readwrite) NSLayoutConstraint *signupButtonContraint;



@end

@implementation FLSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*UIImageView *backSplash = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"flurSplashyWithPin-iphone6"]];
    backSplash.frame = self.view.bounds;
    
    backSplash.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:backSplash];*/
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flur_clear.png"]];
    //image.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;

    [image setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:image];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:image attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:image attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-100]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:image attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:150]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:image attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:150]];
    
    

    UIColor *buttonBackgroundColor = RGB(255,255,255);
    UIColor *buttonTextColor = RGB(152,0,194);

    // build button for signup
    self.signupButton = [[UIButton alloc] init];
    [self.signupButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.signupButton setTitleColor:buttonTextColor forState:UIControlStateNormal];

    [self.signupButton setBackgroundColor:buttonBackgroundColor];
    [[self.signupButton layer] setCornerRadius:4];
    [self.signupButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.signupButton setEnabled:TRUE];
    [self.signupButton setCenter: self.view.center];
    [self.signupButton addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchDown];
    self.signupButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.signupButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
    [self.signupButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:23]];

    [[self view] addSubview:self.signupButton];
    
    // build login button
    self.loginButton = [[UIButton alloc] init];
    //[self.loginButton setBackgroundImage:[UIImage imageNamed:@"LogIn.png"] forState:UIControlStateNormal];
    
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:buttonTextColor forState:UIControlStateNormal];
    
    //[[self.loginButton layer] setBorderWidth:.8];
    [[self.loginButton layer] setCornerRadius:4];
    //self.loginButton.layer.borderColor = RGB(100,100,100).CGColor;

    [self.loginButton setBackgroundColor:buttonBackgroundColor];
    
    [self.loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.loginButton setEnabled:TRUE];
    [self.loginButton setCenter: self.view.center];
    [self.loginButton addTarget:self action:@selector(loginToFlur:) forControlEvents:UIControlEventTouchDown];
    //[self.loginButton setFont:[UIFont systemFontOfSize:20]];
    [self.loginButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:23]];


       self.loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.loginButton.contentEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
    
    [[self view] addSubview:self.loginButton];
    
    self.signupButtonContraint = [NSLayoutConstraint constraintWithItem:self.signupButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-self.view.frame.size.width];
    self.loginButtonContraint = [NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeLeading multiplier:1.0 constant:self.view.frame.size.width];
    

    
    //setting the layout for the sign up buttony
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.signupButton attribute:NSLayoutAttributeCenterY relatedBy:
                                NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:100]];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.signupButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:self.signupButtonContraint];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.signupButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50]];
    
    // set layout of login button
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeTop relatedBy:
                                NSLayoutRelationEqual toItem:[self signupButton] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15]];
    
    [[self view] addConstraint:self.loginButtonContraint];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];

    
      [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50]];
    
    
//    CAGradientLayer *gradient = [CAGradientLayer layer]; 
//    gradient.frame = self.view.bounds;
//    gradient.colors = [NSArray arrayWithObjects:(id)[RGB(186,108,224) CGColor], (id)[RGB(179, 88, 224) CGColor], nil];
//    [self.view.layer insertSublayer:gradient atIndex:0];
    
    self.view.backgroundColor = RGBA(179, 88, 224, 1);
    
    [self.view layoutIfNeeded];
    
    
    [UIView animateWithDuration:0.4 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.loginButtonContraint.constant = 80;
        self.signupButtonContraint.constant = -80;
        [self.view layoutIfNeeded];
    } completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUp:(id)sender {
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    [data setObject:@"Sign Up" forKey:@"mode"];
    [_delegate hideSplashPage];
    [_delegate showLoginPage:data];
}

- (IBAction)loginToFlur:(id)sender {
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    [data setObject:@"Login" forKey:@"mode"];
    [_delegate hideSplashPage];
    [_delegate showLoginPage:data];
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
