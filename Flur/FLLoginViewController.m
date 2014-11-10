//
//  FLLoginViewController.m
//  Flur
//
//  Created by David Lee on 11/6/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import <Parse/Parse.h>
#import "FLLoginViewController.h"
#import "FLMasterNavigationController.h"

#define MAXLENGTH 15


@interface FLTextField : UITextField<UITextFieldDelegate>

@end

@implementation FLTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

@end


@interface FLLoginViewController ()

@property (nonatomic, strong, readwrite) UIButton *signupButton;
@property (nonatomic, strong, readwrite) UIButton *loginButton;
@property (nonatomic, strong) FLTextField* usernameInput;
@property (nonatomic, strong) FLTextField* passwordInput;
@property (nonatomic, strong) UIManagedDocument * document;


@end

@implementation FLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameInput = [[FLTextField alloc] init];
    self.usernameInput.delegate = self;
    
    self.usernameInput.placeholder = @"Username";
    self.usernameInput.backgroundColor = [UIColor redColor];
    self.usernameInput.textColor = [UIColor blackColor];
    self.usernameInput.layer.cornerRadius = 5;
    self.usernameInput.layer.masksToBounds = YES;
    
    self.usernameInput.layer.borderColor=[[UIColor blackColor]CGColor];
    self.usernameInput.layer.borderWidth= 1.0f;
    
    [self.usernameInput setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:self.usernameInput];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.usernameInput attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:50]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.usernameInput attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.usernameInput attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-20]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.usernameInput attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
    
    
    
    self.passwordInput = [[FLTextField alloc] init];
    self.passwordInput.delegate = self;
    
    self.passwordInput.placeholder = @"Password";
    self.passwordInput.backgroundColor = [UIColor redColor];
    self.passwordInput.textColor = [UIColor blackColor];
    self.passwordInput.layer.cornerRadius = 5;
    self.passwordInput.layer.masksToBounds = YES;
    
    self.passwordInput.layer.borderColor=[[UIColor blackColor]CGColor];
    self.passwordInput.layer.borderWidth= 1.0f;
    
    [self.passwordInput setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:self.passwordInput];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordInput attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.usernameInput attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordInput attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordInput attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-20]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordInput attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
    
    
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
    [self signupWithUsername:self.usernameInput.text withPassword:self.passwordInput.text];
}

- (IBAction)loginToFlur:(id)sender {
    [self loginWithUsername:self.usernameInput.text withPassword:self.passwordInput.text];
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    if ([string isEqualToString:@" "]){
        return NO;
    }
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= MAXLENGTH || returnKey;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) signupWithUsername:(NSString*)username withPassword:(NSString*)password {
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            // Display an alert view to show the error message
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            [alertView show];
            // Bring the keyboard back up, because they probably need to change something.
            return;
        }
        else {
            
        }
    }];
}

- (void) loginWithUsername:(NSString*)username withPassword:(NSString*)password {
    [PFUser logInWithUsernameInBackground:username password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            NSLog(@"successful login");
                                            [FLMasterNavigationController switchToViewController:@"FLInitialMapViewController" fromViewController:@"FLLoginViewController" withData:NULL];
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSLog(@"login failed...");
                                            
                                            // check reasons...and display
                                        }
                                    }];
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
