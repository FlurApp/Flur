//
//  FLLoginViewController.m
//  Flur
//
//  Created by David Lee on 11/6/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <Parse/Parse.h>
#import "FLLoginViewController.h"
#import "FLConstants.h"

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

@property (nonatomic, strong) NSString *mode;

@property (nonatomic) CGRect keyboard;

@property (nonatomic, strong) UIButton *orDoOpposite;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UILabel* errorMessage;
@property (nonatomic, strong) UILabel *pageTitle;
@property (nonatomic, strong) UIButton *forgotPassword;


// All constraints for the submit button, used for animating
@property (nonatomic, strong) NSLayoutConstraint *submitLeading;
@property (nonatomic, strong) NSLayoutConstraint *submitTrailing;
@property (nonatomic, strong) NSLayoutConstraint *submitTop;
@property (nonatomic, strong) NSLayoutConstraint *submitBottom;

// All constraints for the error message label, used for animating
@property (nonatomic, strong) NSLayoutConstraint *errorMessageLeading;
@property (nonatomic, strong) NSLayoutConstraint *errorMessageTrailing;
@property (nonatomic, strong) NSLayoutConstraint *errorMessageTop;
@property (nonatomic, strong) NSLayoutConstraint *errorMessageBottom;

@property (nonatomic, strong) NSString *otherMode;


@end

@implementation FLLoginViewController

- (void)setData:(NSMutableDictionary *)data {
    self.mode = [data objectForKey:@"mode"];
    self.otherMode = [self.mode isEqualToString:@"Sign Up"] ? @"Login" : @"Sign Up";
    self.pageTitle.text = self.mode;
    [self.submitButton setTitle:self.mode forState:UIControlStateNormal];
    
    NSString* orDoOppositeText = [NSString stringWithFormat:@"or %@", self.otherMode];
    [self.orDoOpposite setTitle:orDoOppositeText forState:UIControlStateNormal];
    [self.orDoOpposite setTitleColor:submitButtonColor forState:UIControlStateNormal];
    self.orDoOpposite.backgroundColor = [UIColor clearColor];
    [self.orDoOpposite.titleLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:16]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Necessary to later capture return key events
    self.usernameInput.delegate = self;
    self.passwordInput.delegate = self;
    
    // Set background color for view
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    //gradient.colors = [NSArray arrayWithObjects:(id)[RGB(186,108,224) CGColor], (id)[RGB(179, 88, 224) CGColor], nil];
    gradient.colors = [NSArray arrayWithObjects:(id)[backgroundGradientLight CGColor], (id)[backgroundGradientDark CGColor], nil];

    [self.view.layer insertSublayer:gradient atIndex:0];
    
    // Create page title, either 'Sign Up' or 'Login'

    self.pageTitle = [[UILabel alloc] init];

    [self.pageTitle setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.pageTitle setFont:[UIFont fontWithName:@"Avenir-Light" size:30]];
    self.pageTitle.textColor = [UIColor whiteColor];
    
    [self.view addSubview:self.pageTitle];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageTitle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:60]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageTitle attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    

    
    // Put a long line under the page title that is somewhat transparent
    UIView* littleLine = [[UIView alloc]init];
    [littleLine setTranslatesAutoresizingMaskIntoConstraints:NO];

    littleLine.backgroundColor = RGBA(255,255,255,.5);
    
    [self.view addSubview:littleLine];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:littleLine attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.pageTitle attribute:NSLayoutAttributeTop multiplier:1.0 constant:50]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:littleLine attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:littleLine attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-20]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:littleLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1]];
    
    // Put a smaller bolder line under the page title
    UIView* boldLine = [[UIView alloc]init];
    [boldLine setTranslatesAutoresizingMaskIntoConstraints:NO];

    boldLine.backgroundColor = RGBA(255,255,255,1);
    
    [self.view addSubview:boldLine];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:boldLine attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.pageTitle attribute:NSLayoutAttributeTop multiplier:1.0 constant:50]];
    

     [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:boldLine attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.pageTitle attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:boldLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1]];
    
     [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:boldLine attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50]];
    
    

    // Create the username input field
    self.usernameInput = [[FLTextField alloc] init];
    [self.usernameInput setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.usernameInput.delegate = self;
    
    self.usernameInput.placeholder = @"Email";
    self.usernameInput.backgroundColor = [UIColor whiteColor];
    self.usernameInput.textColor = RGB(110,110,110);
    self.usernameInput.layer.cornerRadius = 4;
    self.usernameInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameInput.returnKeyType = UIReturnKeyNext;
    self.usernameInput.keyboardAppearance = UIKeyboardAppearanceDark;
    self.usernameInput.keyboardType = UIKeyboardTypeEmailAddress;
    self.usernameInput.autocorrectionType = UITextAutocorrectionTypeNo;

    
    [self.usernameInput addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    
    [self.view addSubview:self.usernameInput];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.usernameInput attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.pageTitle attribute:NSLayoutAttributeTop multiplier:1.0 constant:80]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.usernameInput attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:40]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.usernameInput attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-40]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.usernameInput attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
    
    
    // Create the password input field
    self.passwordInput = [[FLTextField alloc] init];
    self.passwordInput.delegate = self;

    
    self.passwordInput.placeholder = @"Password";
    self.passwordInput.backgroundColor = [UIColor whiteColor];
    self.passwordInput.textColor = RGB(110,110,110);
    self.passwordInput.layer.cornerRadius = 4;
    self.passwordInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordInput.returnKeyType = UIReturnKeyDone;
    [self.passwordInput setEnablesReturnKeyAutomatically: YES];
    self.passwordInput.secureTextEntry = YES;
    self.passwordInput.keyboardAppearance = UIKeyboardAppearanceDark;
    self.passwordInput.autocorrectionType = UITextAutocorrectionTypeNo;


    
    [self.passwordInput addTarget:self
                           action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
    
    [self.passwordInput setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.passwordInput];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordInput attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.usernameInput attribute:NSLayoutAttributeBottom multiplier:1.0 constant:3]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordInput attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:40]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordInput attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-40]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordInput attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
    
    // Create the button to change from Sign Up screen to Login and vice versa
    self.orDoOpposite = [[UIButton alloc]init];
    [self.orDoOpposite setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.orDoOpposite addTarget:self action:@selector(switchScreen:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.orDoOpposite];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.orDoOpposite attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.passwordInput attribute:NSLayoutAttributeBottom multiplier:1.0 constant:2]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.orDoOpposite attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.passwordInput attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    
    // Creat the submit button for the login/signup info
    self.submitButton = [[UIButton alloc] init];
    [self.submitButton setTranslatesAutoresizingMaskIntoConstraints:NO];

    //[self.submitButton setTitleColor:RGB(179, 88, 224) forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [self.submitButton setBackgroundColor:submitButtonColor];
    [[self.submitButton layer] setCornerRadius:2];
    [self.submitButton setEnabled:TRUE];
    [self.submitButton setCenter: self.view.center];
    [self.submitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchDown];
    [self.submitButton addTarget:self action:@selector(unSubmit:) forControlEvents:UIControlEventTouchUpInside];
    self.submitButton.alpha = 0;
    
    [[self view] addSubview:self.submitButton];
    

    // Put the submit button offscreen and transparent initially, will be animated in later
    self.submitLeading = [NSLayoutConstraint constraintWithItem:self.submitButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-self.view.frame.size.width];
    
    self.submitTrailing = [NSLayoutConstraint constraintWithItem:self.submitButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-self.view.frame.size.width];
    
    self.submitTop = [NSLayoutConstraint constraintWithItem:self.submitButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-450];
    
    self.submitBottom = [NSLayoutConstraint constraintWithItem:self.submitButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.keyboard.size.height];
    
    [[self view] addConstraint:self.submitLeading];
    [[self view] addConstraint:self.submitTrailing];
    [[self view] addConstraint:self.submitTop];
    [[self view] addConstraint:self.submitBottom];


    
    
    // Create the error message label
    self.errorMessage = [[UILabel alloc]init];
    self.errorMessage.text = @"Incorrect username/password combo.";
    self.errorMessage.backgroundColor = RGB(222,58,58);
    [self.errorMessage setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.errorMessage.alpha = 0;
    [self.errorMessage setTextColor:[UIColor whiteColor]];
    self.errorMessage.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.errorMessage];
    
    self.errorMessageLeading = [NSLayoutConstraint constraintWithItem:self.errorMessage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeLeading multiplier:1.0 constant:self.view.frame.size.width];
    
    self.errorMessageTrailing = [NSLayoutConstraint constraintWithItem:self.errorMessage attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:self.view.frame.size.width];
    
    self.errorMessageTop = [NSLayoutConstraint constraintWithItem:self.errorMessage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-450];
    
    self.errorMessageBottom = [NSLayoutConstraint constraintWithItem:self.errorMessage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.keyboard.size.height];
    
    // Put the error message label offscreen and transparent initially, will be animated in later
    [[self view] addConstraint:self.errorMessageLeading];
    [[self view] addConstraint:self.errorMessageTrailing];
    [[self view] addConstraint:self.errorMessageTop];
    [[self view] addConstraint:self.errorMessageBottom];
    
    // forgot password
    
    self.forgotPassword = [[UIButton alloc] init];
    self.forgotPassword.backgroundColor = [UIColor clearColor];
    [self.forgotPassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // i know it looks crazy but thats how u underline shit
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"Forgot password?"];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    
    [attributeString addAttribute:NSForegroundColorAttributeName
                            value:[UIColor whiteColor]
                            range:(NSRange){0, [attributeString length]}];
    
    UIFont *font = [UIFont fontWithName:@"Avenir-Light" size:12];
    [attributeString addAttribute:NSFontAttributeName
                            value:font
                            range:(NSRange){0, [attributeString length]}];
    
    [self.forgotPassword setAttributedTitle:[attributeString copy] forState:UIControlStateNormal];
    [self.forgotPassword addTarget:self action:@selector(doForgotPassword:) forControlEvents:UIControlEventTouchDown];
    [self.forgotPassword setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.forgotPassword];
    
    // constraints for ForgotPasswordLabel
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.forgotPassword attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.passwordInput attribute:NSLayoutAttributeBottom multiplier:1.0 constant:2]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.forgotPassword attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.passwordInput attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];

    
    // Changes the color of the cursor when typing in the text field
    [[FLTextField appearance] setTintColor:RGB(152,0,194)];
    
    
    // Used later on to grab on to keyboard to place button
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow:)
                   name:UIKeyboardDidShowNotification object:nil];
    
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    // Keyboard frame is in window coordinates
    NSDictionary *userInfo = [notification userInfo];
    self.keyboard = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"keyboard showed");
    
    // Put both the submit button and the error message label right above the keyboard vertically
    self.submitTop.constant = -self.keyboard.size.height - 50;
    self.submitBottom.constant = -self.keyboard.size.height;
    
    self.errorMessageTop.constant = -self.keyboard.size.height - 50;
    self.errorMessageBottom.constant = -self.keyboard.size.height;
    [self.view layoutIfNeeded];

    return;
}

- (IBAction)unSubmit:(id)sender {
    self.submitButton.backgroundColor = submitButtonColor;
    
    if ([self.mode isEqualToString: @"Sign Up"]) {
        [self signupWithUsername:self.usernameInput.text withPassword:self.passwordInput.text];
    }
    else if([self.mode isEqualToString:@"Login"])
        [self loginWithUsername:self.usernameInput.text withPassword:self.passwordInput.text];
}


- (IBAction)submit:(id)sender {
    self.submitButton.backgroundColor = RGB(220,220,220);
   
}
     
- (IBAction)switchScreen:(id)sender {

    // Animate a fade out of the page title and a fade in of the new page title
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.pageTitle.alpha = 0;
    } completion:^(BOOL finished) {
        
         [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
             self.pageTitle.text = self.otherMode;
             self.pageTitle.alpha = 1;
         } completion:^(BOOL finished) {
         }];
    }];
    
    // Animate a fade out of the page title and a fade in of the new page title
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.orDoOpposite.alpha = 0;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.orDoOpposite setTitle:[NSString stringWithFormat:@"or %@",self.mode] forState:UIControlStateNormal];
            self.orDoOpposite.alpha = 1;
        } completion:^(BOOL finished) {
            NSString* temp = self.mode;
            self.mode = self.otherMode;
            self.otherMode = temp;
            
        }];
    }];
    
    self.usernameInput.text = @"";
    self.passwordInput.text = @"";
    
    [self hideSubmitButtonWithNewText:self.otherMode];
    [self hideErrorMessage];
    
  
    
}

- (IBAction)textFieldDidChange: (id)sender {
    // If the error message is visible, animate it off screen
    if (self.errorMessageTrailing.constant == 0) {
        [self hideErrorMessage];
    }
    
    // If both fields have some contents, animate the login button onto the screen
    if (self.usernameInput.text.length > 0 && self.passwordInput.text.length > 0) {
        [self showSubmitButton];
    }
    
    // If one of the inputs does not have some contents, animate the login button off the screen
    else if (self.usernameInput.text.length == 0 || self.passwordInput.text.length == 0) {
        [self hideSubmitButton];
    }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.usernameInput)
       [self.passwordInput becomeFirstResponder];
    else if (textField == self.passwordInput) {
        [self submit:self.submitButton];
        [self unSubmit:self.submitButton];
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)validateEmail: (NSString *) candidate {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; //  return 0;
    return [emailTest evaluateWithObject:candidate];
}

- (void) signupWithUsername:(NSString*)username withPassword:(NSString*)password {
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = username;
    
    // if invalid email address
    if (![self validateEmail:username]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid email"
                                                        message:[NSString stringWithFormat: @"Please enter a valid email address."]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // if password is too short
    else if (password.length < 8) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid password"
                                                        message:[NSString stringWithFormat: @"Your password must contain at least 8 characters."]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
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
            [self dropSubmitButton];
            [_delegate hideLoginPage];
            [_delegate showMapPage];
            [self cleanUp];
            
            // for push notifications
            [self updateInstallationWithUser];
        }
    }];
}

- (void) loginWithUsername:(NSString*)username withPassword:(NSString*)password {
    [PFUser logInWithUsernameInBackground:username password:password
                                    block:^(PFUser *user, NSError *error) {
                                        
        if (user) {
            // Do stuff after successful login.
            NSLog(@"successful login");
            
            [self dropSubmitButton];
            [_delegate hideLoginPage];
            [_delegate showMapPage];
            
            // for push notifications
            [self updateInstallationWithUser];
            
            // clean up
            [self cleanUp];
            
            [self syncCoreDataWithServer];
            
            NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
            [data setObject:@"true" forKey:@"sync"];
        } else {
            // The login failed. Check error to see why.
            NSLog(@"login failed...");

            [self showErrorMessage];
            [self hideSubmitButton];
            [self.passwordInput becomeFirstResponder];
            
            // check reasons...and display
        }
                                        
    }];
}

- (void) updateInstallationWithUser {
    PFUser *user = [PFUser currentUser];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setObject:user forKey:@"user"];
    [currentInstallation saveInBackground];
}

- (void) cleanUp {
    [self hideSubmitButton];
    self.usernameInput.text = @"";
    self.passwordInput.text = @"";
    
    self.errorMessageBottom.constant = 0;
    self.errorMessageTop.constant = self.view.frame.size.height;
    
}
- (void) syncCoreDataWithServer {
    
}

- (IBAction)doForgotPassword:(id)sender {
    
     [PFUser requestPasswordResetForEmailInBackground:self.usernameInput.text
                                                block:^(BOOL succeeded,NSError *error) {
        
        if (!error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset Password"
                                                            message:[NSString stringWithFormat: @"A link to reset your password has been sent to your email"]
                                                           delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [alert show];
            return;
            
        }
        else
        {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[NSString stringWithFormat: @"Password reset failed: %@ Please re-enter your email address.",errorString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }];
        
}


- (void) dropSubmitButton {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.passwordInput resignFirstResponder];
        [self.usernameInput resignFirstResponder];
        self.submitBottom.constant = 0;
        self.submitTop.constant = -50;

        [self.view layoutIfNeeded];
    } completion:nil];
}


- (void) showSubmitButton {
    self.submitButton.alpha = 1;
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.submitLeading.constant = 0;
        self.submitTrailing.constant = 0;
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void) showErrorMessage {
    self.errorMessage.alpha = 1;
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.errorMessageLeading.constant = 0;
        self.errorMessageTrailing.constant = 0;
        
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void) hideSubmitButton {
    [self hideSubmitButtonWithNewText:@""];
}

- (void) hideSubmitButtonWithNewText:(NSString *) newButtonText {
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.submitLeading.constant = -1*self.view.frame.size.width;
        self.submitTrailing.constant = -1*self.view.frame.size.width;
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL done){
        [UIView animateWithDuration:0.01 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.submitButton.alpha = 0;
            if (![newButtonText isEqualToString:@""])
                [self.submitButton setTitle:newButtonText forState:UIControlStateNormal];
            
            [self.view layoutIfNeeded];
        } completion:nil];
    }];
    
}

- (void) hideErrorMessage {
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.errorMessageLeading.constant = self.view.frame.size.width;
        self.errorMessageTrailing.constant = self.view.frame.size.width;
        
        [self.view layoutIfNeeded];
    } completion:nil];

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
