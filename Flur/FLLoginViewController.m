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
    return CGRectInset( bounds , 20 , 10 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 20 , 10 );
}

@end


@interface FLLoginViewController ()

@property (nonatomic, strong, readwrite) NSString *mode;
@property (nonatomic, strong, readwrite) UIButton *submitButton;
@property (nonatomic, strong) FLTextField* usernameInput;
@property (nonatomic, strong) FLTextField* passwordInput;
@property (nonatomic, strong) UIManagedDocument * document;


@end

@implementation FLLoginViewController

- (id)initWithData:(NSMutableDictionary *)data {
    NSString *mode = [data objectForKey:@"mode"];
    self.mode = mode;
    NSLog(@"Entering login view controller with mode: %@",mode);
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // background
    UIImageView *backSplash = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"flurSplashyBlank"]];
    backSplash.frame = self.view.bounds;
    
    backSplash.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:backSplash];
    self.usernameInput = [[FLTextField alloc] init];
    self.usernameInput.delegate = self;
    
    self.usernameInput.placeholder = @"Username";
    self.usernameInput.backgroundColor = [UIColor whiteColor];
    self.usernameInput.textColor = [UIColor grayColor];
    self.usernameInput.layer.cornerRadius = 2;
    self.usernameInput.layer.masksToBounds = YES;
    
    //self.usernameInput.layer.borderColor=[[UIColor whiteColor]CGColor];
    //self.usernameInput.layer.borderWidth= 1.0f;
    
    [self.usernameInput setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:self.usernameInput];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.usernameInput attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:50]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.usernameInput attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:40]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.usernameInput attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-40]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.usernameInput attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
    
    
    
    self.passwordInput = [[FLTextField alloc] init];
    self.passwordInput.delegate = self;

    
    self.passwordInput.placeholder = @"Password";
    self.passwordInput.backgroundColor = [UIColor whiteColor];
    self.passwordInput.textColor = [UIColor grayColor];
    self.passwordInput.layer.cornerRadius = 2;
    //self.passwordInput.layer.masksToBounds = YES;
    
    //self.passwordInput.layer.borderColor=[[UIColor grayColor]CGColor];
    //self.passwordInput.layer.borderWidth= 1.0f;
    
    //self.passwordInput.background = [UIImage imageNamed:@"Passwordbg.png"];
    

    [self.passwordInput setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.passwordInput];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordInput attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.usernameInput attribute:NSLayoutAttributeBottom multiplier:1.0 constant:1]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordInput attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:40]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordInput attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-40]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordInput attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
    
    // button
    self.submitButton = [[UIButton alloc] init];
    if ([self.mode isEqualToString: @"signup"]) {
        [self.submitButton setTitle:@"Sign up" forState:UIControlStateNormal];
    }
    else if ([self.mode isEqualToString: @"login"]) {
        [self.submitButton setTitle:@"Log in" forState:UIControlStateNormal];
    }
    [self.submitButton setTitleColor:[UIColor colorWithRed:0.33 green:0.76 blue:0.88 alpha:0.8] forState:UIControlStateNormal];
    //[[self.signupButton layer] setBorderColor:[[UIColor blackColor] CGColor]];
    //[[self.signupButton layer] setBorderWidth:1.0];
    [self.submitButton setBackgroundColor:[UIColor whiteColor]];
    [[self.submitButton layer] setCornerRadius:2];
    [self.submitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.submitButton setEnabled:TRUE];
    [self.submitButton setCenter: self.view.center];
    [self.submitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchDown];
    [[self view] addSubview:self.submitButton];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.submitButton attribute:NSLayoutAttributeTop relatedBy:
                                NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-140]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.submitButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeLeading multiplier:1.0 constant:40]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.submitButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-40]];
    
    
}

- (IBAction)submit:(id)sender {
    if ([self.mode isEqualToString: @"signup"])
        [self signupWithUsername:self.usernameInput.text withPassword:self.passwordInput.text];
    else if([self.mode isEqualToString:@"login"])
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
