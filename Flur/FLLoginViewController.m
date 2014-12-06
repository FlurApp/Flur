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


@property (nonatomic) CGRect keyboard;


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

@property (nonatomic, strong) NSString *mode;
@property (nonatomic, strong) NSString *otherMode;
@property (nonatomic, strong) UILabel *pageTitle;
@property (nonatomic, strong) UIView *topBar;

@property (nonatomic, strong) UITextField *emailInput;
@property (nonatomic, strong) UILabel *emailDummy;

@property (nonatomic, strong) UITextField *passwordInput;
@property (nonatomic, strong) UILabel *passwordDummy;

@property (nonatomic, strong) UIButton *signUpWithEmailButton;




@end

@implementation FLLoginViewController

- (void)setData:(NSMutableDictionary *)data {
    self.mode = [data objectForKey:@"mode"];
    self.otherMode = [self.mode isEqualToString:@"Sign Up"] ? @"Login" : @"Sign Up";
    self.pageTitle.text = self.mode;
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
    
    [self performSelector:@selector(showKeyboard:) withObject:self afterDelay:.2];
}

- (IBAction)showKeyboard:(id)sender {
    [self.emailInput becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadTopBar];
    [self loadInputs];
    [self loadButton];

    
    // Changes the color of the cursor when typing in the text field
    [[FLTextField appearance] setTintColor:RGB(152,0,194)];
    
    
    // Used later on to grab on to keyboard to place button
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow:)
                   name:UIKeyboardDidShowNotification object:nil];
    
}

- (void) loadTopBar {
    self.topBar = [[UIView alloc] init];
    [self.topBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.topBar.backgroundColor = RGB(240,240,240);
    
    [self.view addSubview:self.topBar];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:70]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    UIView *topBarLine = [[UIView alloc] init];
    [topBarLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    topBarLine.backgroundColor = RGB(50,50,50);
    
    [self.view addSubview:topBarLine];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:topBarLine attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:topBarLine attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:.5]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:topBarLine attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:topBarLine attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    self.pageTitle = [[UILabel alloc] init];
    [self.pageTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.pageTitle.text = self.mode;
    [self.pageTitle setFont:[UIFont fontWithName:@"Avenir-Light" size:22]];
    [self.pageTitle setTextColor:RGB(10, 10, 10)];
    
    [self.topBar addSubview:self.pageTitle];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageTitle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:32]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageTitle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
}

- (void) loadInputs {
    
    /* ----------------------------------------------------
                EMAIL BAR
     ----------------------------------------------------*/
    
    UILabel *emailLabel = [[UILabel alloc] init];
    [emailLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [emailLabel setTextColor:RGB(13,191,255)];
    [emailLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:18]];
    emailLabel.text = @"Email";
    [self.view addSubview:emailLabel];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:emailLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:emailLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15]];
    
    
    UIView *grayLine = [[UIView alloc] init];
    [grayLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    grayLine.backgroundColor = RGB(180,180,180);
    
    [self.view addSubview:grayLine];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:grayLine attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:emailLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:12]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:grayLine attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:grayLine attribute:NSLayoutAttributeTop multiplier:1.0 constant:.5]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:grayLine attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:grayLine attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    self.emailInput = [[UITextField alloc] init];
    [self.emailInput setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.emailInput.delegate = self;
    self.emailInput.userInteractionEnabled = YES;
    [self.emailInput setFont:[UIFont fontWithName:@"Avenir-Light" size:18]];
    [self.emailInput setTintColor:RGB(13,191,255)];

    [self.emailInput addTarget:self
                           action:@selector(emailInputChanged:)
                 forControlEvents:UIControlEventEditingChanged];

    
    [self.view addSubview:self.emailInput];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emailInput attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emailInput attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:120]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emailInput attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    self.emailDummy = [[UILabel alloc] init];
    [self.emailDummy setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.emailDummy setTextColor:RGB(210,210,210)];
    [self.emailDummy setFont:[UIFont fontWithName:@"Avenir-Light" size:18]];
    self.emailDummy.text = @"nateLee@flur.com";
    [self.view addSubview:self.emailDummy];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emailDummy attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emailDummy attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:120]];


    
    
    
    /* ----------------------------------------------------
                        PASSWORD BAR
     ----------------------------------------------------*/
    
    UILabel *passwordLabel = [[UILabel alloc] init];
    [passwordLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [passwordLabel setTextColor:RGB(13,191,255)];
    [passwordLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:18]];
    passwordLabel.text = @"Password";
    [self.view addSubview:passwordLabel];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:passwordLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:grayLine attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:passwordLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15]];
    
    
    UIView *grayLine2 = [[UIView alloc] init];
    [grayLine2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    grayLine2.backgroundColor = RGB(180,180,180);
    
    [self.view addSubview:grayLine2];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:grayLine2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:passwordLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:12]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:grayLine2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:grayLine2 attribute:NSLayoutAttributeTop multiplier:1.0 constant:.5]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:grayLine2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:grayLine2 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    self.passwordInput = [[UITextField alloc] init];
    [self.passwordInput setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.passwordInput.delegate = self;
    self.passwordInput.userInteractionEnabled = YES;
    [self.passwordInput setFont:[UIFont fontWithName:@"Avenir-Light" size:18]];
    [self.passwordInput setTintColor:RGB(13,191,255)];
    
    [self.passwordInput addTarget:self
                        action:@selector(passwordInputChanged:)
              forControlEvents:UIControlEventEditingChanged];
    
    
    [self.view addSubview:self.passwordInput];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordInput attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:grayLine attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordInput attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:120]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordInput attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    self.passwordDummy = [[UILabel alloc] init];
    [self.passwordDummy setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.passwordDummy setTextColor:RGB(210,210,210)];
    [self.passwordDummy setFont:[UIFont fontWithName:@"Avenir-Light" size:18]];
    self.passwordDummy.text = @"secret";
    [self.view addSubview:self.passwordDummy];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordDummy attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:grayLine attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordDummy attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:120]];
    
    
}

- (void) loadButton {
    self.signUpWithEmailButton = [[UIButton alloc] init];
    [self.signUpWithEmailButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.signUpWithEmailButton.backgroundColor = RGBA(179, 88, 224, 1);
    [self.signUpWithEmailButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.signUpWithEmailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signUpWithEmailButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:22]];
 
    [self.view addSubview:self.signUpWithEmailButton];
    
    self.submitTop = [NSLayoutConstraint constraintWithItem:self.signUpWithEmailButton
                                                  attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual toItem:self.view
                                                  attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    self.submitBottom = [NSLayoutConstraint constraintWithItem:self.signUpWithEmailButton
                                                  attribute:NSLayoutAttributeBottom
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self.signUpWithEmailButton
                                                  attribute:NSLayoutAttributeTop multiplier:1.0
                                                      constant:50];
    
    self.submitLeading = [NSLayoutConstraint constraintWithItem:self.signUpWithEmailButton
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.view
                                                     attribute:NSLayoutAttributeLeading multiplier:1.0
                                                      constant:-self.view.frame.size.width];
    
    self.submitTrailing = [NSLayoutConstraint constraintWithItem:self.signUpWithEmailButton
                                                      attribute:NSLayoutAttributeTrailing
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.view
                                                      attribute:NSLayoutAttributeTrailing multiplier:1.0
                                                       constant:-self.view.frame.size.width];
    [self.view addConstraint:self.submitTop];
    [self.view addConstraint:self.submitBottom];
    [self.view addConstraint:self.submitLeading];
    [self.view addConstraint:self.submitTrailing];
    
}

//- (IBAction)keyboardDidShow:(id)sender {
//}

-(void)keyboardDidShow:(NSNotification*)notification {
    // Keyboard frame is in window coordinates
    NSDictionary *userInfo = [notification userInfo];
    self.keyboard = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // Put both the submit button and the error message label right above the keyboard vertically
    self.submitTop.constant = -self.keyboard.size.height - 50;
    [self.view layoutIfNeeded];
    
    return;

}

- (void) showSubmitButton {
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.submitLeading.constant = 0;
        self.submitTrailing.constant = 0;
        
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void) hideSubmitButton {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.submitLeading.constant = -self.view.frame.size.width;
        self.submitTrailing.constant = -self.view.frame.size.width;
        
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (IBAction)emailInputChanged: (id)sender {
    if (self.emailInput.text.length == 0)
        self.emailDummy.text = @"nateLee@flur.com";
    else
        self.emailDummy.text = @"";
    
    if (self.emailInput.text.length >0 && self.passwordInput.text.length>0)
        [self showSubmitButton];
    else
        [self hideSubmitButton];
}

- (IBAction)passwordInputChanged: (id)sender {
    if (self.passwordInput.text.length == 0)
        self.passwordDummy.text = @"secret";
    else
        self.passwordDummy.text = @"";
    
    
    if (self.emailInput.text.length >0 && self.passwordInput.text.length>0)
        [self showSubmitButton];
    else
        [self hideSubmitButton];
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

/*- (void)d:(NSNotification *)notification
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Reset"
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
