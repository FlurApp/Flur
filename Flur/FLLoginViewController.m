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

//@implementation FLTextField
//
//- (CGRect)textRectForBounds:(CGRect)bounds {
//    return CGRectInset( bounds , 10 , 10 );
//}
//
//// text position
//- (CGRect)editingRectForBounds:(CGRect)bounds {
//    return CGRectInset( bounds , 10 , 10 );
//}
//
//@end

#define loginBlue RGBA(179, 88, 224, 1)

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
@property (nonatomic, strong) UIButton *exitButton;

@property (nonatomic, strong) UILabel *errorMessage;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) BOOL active;


// forgot password button
@property (nonatomic, strong) UIButton *forgotPassword;



@end

@implementation FLLoginViewController

- (void)setData:(NSMutableDictionary *)data {
    self.mode = [data objectForKey:@"mode"];
    self.otherMode = [self.mode isEqualToString:@"Sign Up"] ? @"Login" : @"Sign Up";
    self.pageTitle.text = self.mode;
    
    self.active = true;
    [self.signUpWithEmailButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.signUpWithEmailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
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
    [self loadError];
    
//    // Changes the color of the cursor when typing in the text field
//    [[FLTextField appearance] setTintColor:RGB(152,0,194)];
    
    
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
    
    
    
    self.exitButton = [[UIButton alloc] init];
    [self.exitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.exitButton.backgroundColor = [UIColor redColor];
    
    UIImage* tableIcon = [UIImage imageNamed:@"exit.png"];
    CGRect temp_rect = CGRectMake(0,0,75,75);
    CGRect rect = CGRectMake(0,0,75,75);
    UIGraphicsBeginImageContext(rect.size);
    [tableIcon drawInRect:temp_rect];
    UIImage *tableIconResized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imgData = UIImagePNGRepresentation(tableIconResized);
    UIImage *tableImg = [UIImage imageWithData:imgData];

    
    self.exitButton.backgroundColor = [UIColor clearColor];
    [self.exitButton setImage:tableImg forState:UIControlStateNormal];
    [self.exitButton setContentMode:UIViewContentModeCenter];
    [self.exitButton setImageEdgeInsets:UIEdgeInsetsMake(22.5,22.5,22.5,22.5)];
    
    [self.exitButton addTarget:self
                                   action:@selector(exit:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    [self.topBar addSubview:self.exitButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.exitButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.exitButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-5]];
    
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
    self.emailInput.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailInput.returnKeyType = UIReturnKeyNext;
    self.emailInput.keyboardType = UIKeyboardTypeEmailAddress;
    [self.emailInput setEnablesReturnKeyAutomatically: YES];


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
    self.emailDummy.text = @"name@example.com";
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
    
    self.passwordInput.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordInput.returnKeyType = UIReturnKeyDone;
    [self.passwordInput setEnablesReturnKeyAutomatically: YES];
    self.passwordInput.secureTextEntry = YES;

    
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
    
    // load forgot password button
    [self loadForgotPassword];
    
    
}

- (void) loadForgotPassword {
    // forgot password
    
    self.forgotPassword = [[UIButton alloc] init];
    
    // i know it looks crazy but thats how u underline shit
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"Forgot password?"];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    
    [attributeString addAttribute:NSForegroundColorAttributeName
                            value:loginBlue
                            range:(NSRange){0, [attributeString length]}];
    
    UIFont *font = [UIFont fontWithName:@"Avenir-Light" size:12];
    [attributeString addAttribute:NSFontAttributeName
                            value:font
                            range:(NSRange){0, [attributeString length]}];
    
    [self.forgotPassword setAttributedTitle:[attributeString copy] forState:UIControlStateNormal];
    
    [self.forgotPassword addTarget:self action:@selector(doForgotPassword:) forControlEvents:UIControlEventTouchDown];
    [self.forgotPassword setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.forgotPassword];
    
    // constraints for ForgotPasswordButton
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.forgotPassword attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.passwordInput attribute:NSLayoutAttributeBottom multiplier:1.0 constant:16]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.forgotPassword attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-20]];
}


- (void) loadButton {
    self.signUpWithEmailButton = UIButtonTypeCustom;
    self.signUpWithEmailButton = [[UIButton alloc] init];
    [self.signUpWithEmailButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.signUpWithEmailButton.backgroundColor = loginBlue;
    [self.signUpWithEmailButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.signUpWithEmailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signUpWithEmailButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:22]];
    
    [self.signUpWithEmailButton addTarget:self
                                   action:@selector(submitButtonPress:)
                         forControlEvents:UIControlEventTouchUpInside];
    
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
    
    
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width/2, 25);
    self.activityIndicator.hidesWhenStopped = NO;
    self.activityIndicator.alpha = 0;
    [self.signUpWithEmailButton addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
}

- (void) loadError {
    
    self.errorMessage = [[UILabel alloc] init];
    [self.errorMessage setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.errorMessage.backgroundColor = RGB(244,99,83);
    [self.errorMessage setTextColor:[UIColor whiteColor]];
    [self.errorMessage setFont:[UIFont fontWithName:@"Avenir-Light" size:19]];
    self.errorMessage.text = @"Invalid username/password combo";
    self.errorMessage.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:self.errorMessage];
    
    self.errorMessageTop = [NSLayoutConstraint constraintWithItem:self.errorMessage
                                                  attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual toItem:self.view
                                                  attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    self.errorMessageBottom = [NSLayoutConstraint constraintWithItem:self.errorMessage
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.errorMessage
                                                     attribute:NSLayoutAttributeTop multiplier:1.0
                                                      constant:50];
    
    self.errorMessageLeading = [NSLayoutConstraint constraintWithItem:self.errorMessage
                                                      attribute:NSLayoutAttributeLeading
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.view
                                                      attribute:NSLayoutAttributeLeading multiplier:1.0
                                                       constant:self.view.frame.size.width];
    
    self.errorMessageTrailing = [NSLayoutConstraint constraintWithItem:self.errorMessage
                                                       attribute:NSLayoutAttributeTrailing
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self.view
                                                       attribute:NSLayoutAttributeTrailing multiplier:1.0
                                                        constant:self.view.frame.size.width];
    [self.view addConstraint:self.errorMessageTop];
    [self.view addConstraint:self.errorMessageBottom];
    [self.view addConstraint:self.errorMessageLeading];
    [self.view addConstraint:self.errorMessageTrailing];


}

- (IBAction)submitButtonPress:(id)sender {
    [self loginWithUsername:self.emailInput.text withPassword:self.passwordInput.text];
}

//- (IBAction)keyboardDidShow:(id)sender {
//}

-(void)keyboardDidShow:(NSNotification*)notification {
    if (!self.active)
        return;
    // Keyboard frame is in window coordinates
    NSDictionary *userInfo = [notification userInfo];
    self.keyboard = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // Put both the submit button and the error message label right above the keyboard vertically
    self.submitTop.constant = -self.keyboard.size.height - 50;
    self.errorMessageTop.constant = -self.keyboard.size.height - 50;
    [self.view layoutIfNeeded];
    
    return;

}

- (void) showSubmitButton {
    self.activityIndicator.alpha = 0;
    
    if (self.signUpWithEmailButton.state == UIControlStateNormal)
        NSLog(@"WHAT: %@",self.signUpWithEmailButton.currentTitle);
    
    [self.signUpWithEmailButton setTitle:@"Login" forState:UIControlStateNormal];
 
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

- (void) showErrorMessage {
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.errorMessageLeading.constant = 0;
        self.errorMessageTrailing.constant = 0;
        
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void) hideErrorMessage {
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.errorMessageLeading.constant = self.view.frame.size.width;
        self.errorMessageTrailing.constant = self.view.frame.size.width;
        
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (IBAction)emailInputChanged: (id)sender {
    if (self.emailInput.text.length == 0)
        self.emailDummy.text = @"name@example.com";
    else
        self.emailDummy.text = @"";
    
    if (self.emailInput.text.length >0 && self.passwordInput.text.length>0)
        [self showSubmitButton];
    else
        [self hideSubmitButton];
    
    [self hideErrorMessage];

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
    
    [self hideErrorMessage];
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
    
    if (textField == self.emailInput)
        [self.passwordInput becomeFirstResponder];
    else if (textField == self.passwordInput) {
        [self.signUpWithEmailButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return NO;
}


/*- (IBAction)unSubmit:(id)sender {
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
}*/

- (void) loginWithUsername:(NSString*)username withPassword:(NSString*)password {
    
    [UIView animateWithDuration:.1 animations:^{
        [self.signUpWithEmailButton setTitle:@"" forState:UIControlStateNormal];
        self.activityIndicator.alpha = 1;
    }];

    
    [PFUser logInWithUsernameInBackground:username password:password
                                    block:^(PFUser *user, NSError *error) {

        if (user) {
            // Do stuff after successful login.
            
            [_delegate hideLoginPage];
            [_delegate showMapPageFromLogin];
            
            // for push notifications
            [self updateInstallationWithUser];
            
            // clean up
            [self cleanUp];
            //[self syncCoreDataWithServer];
            
            NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
            [data setObject:@"true" forKey:@"sync"];
        } else {
            // The login failed. Check error to see why.
            [self hideSubmitButton];
            [self showErrorMessage];
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
    self.active = false;
    self.emailInput.text = @"";
    self.passwordInput.text = @"";
    [self.emailInput sendActionsForControlEvents:UIControlEventEditingChanged];
    [self.passwordInput sendActionsForControlEvents:UIControlEventEditingChanged];

    
    self.errorMessageTop.constant = 2000;
    self.submitTop.constant = 2000;
    
    [self.view endEditing:YES];
    
    [self hideSubmitButton];
    [self hideErrorMessage];
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
}

- (IBAction)exit:(id)sender{
    [self cleanUp];
    [_delegate hideLoginPage];
    [_delegate showSplashPage];
}

- (void) syncCoreDataWithServer {
    
}

- (IBAction)doForgotPassword:(id)sender {
    
    [PFUser requestPasswordResetForEmailInBackground:self.emailInput.text
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


/*- (void) dropSubmitButton {
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
