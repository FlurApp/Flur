//
//  FLSignupViewController.m
//  Flur
//
//  Created by David Lee on 11/6/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <Parse/Parse.h>
#import "FLSignupViewController.h"
#import "FLConstants.h"
#import <AVFoundation/AVFoundation.h>
#import "LocalStorage.h"

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

//@end

#define signupBlue RGBA(179, 88, 224, 1)

@interface FLSignupViewController ()


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

//camera shit
@property (nonatomic) AVCaptureDevice* frontDevice;
@property (nonatomic) AVCaptureSession* session;
@property (nonatomic, readwrite) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic) AVCaptureDeviceInput *captureInput;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, readwrite) UIImageView* imageTaken;
@property (nonatomic, strong) UIButton *profilePic;


@end

@implementation FLSignupViewController

- (void)setData:(NSMutableDictionary *)data {
    self.mode = [data objectForKey:@"mode"];
    self.otherMode = [self.mode isEqualToString:@"Sign Up"] ? @"Login" : @"Sign Up";
    self.pageTitle.text = self.mode;
    
    self.active = true;
    [self.signUpWithEmailButton setTitle:@"Sign up" forState:UIControlStateNormal];
    [self.signUpWithEmailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
    [self performSelector:@selector(showKeyboard:) withObject:self afterDelay:.2];
    
    [self loadCamera];
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
    
    // Changes the color of the cursor when typing in the text field
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
    self.passwordDummy.text = @"At least 8 characters";
    [self.view addSubview:self.passwordDummy];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordDummy attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:grayLine attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordDummy attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:120]];
    
}

- (void) loadButton {
    self.signUpWithEmailButton = UIButtonTypeCustom;
    self.signUpWithEmailButton = [[UIButton alloc] init];
    [self.signUpWithEmailButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.signUpWithEmailButton.backgroundColor = signupBlue;
    [self.signUpWithEmailButton setTitle:@"Sign up" forState:UIControlStateNormal];
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
    self.errorMessage.text = @"Invalid sign up";
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
    [self signupWithUsername:self.emailInput.text withPassword:self.passwordInput.text];
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
    [self.signUpWithEmailButton setTitle:@"Sign up" forState:UIControlStateNormal];
    
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
        [self showErrorMessage];
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
        [self showErrorMessage];
        [alert show];
        return;
    }
    else if (self.imageTaken == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:[NSString stringWithFormat: @"Please take a photo of yourself by pressing inside the camera circle. This will be used for your profile picture."]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [self showErrorMessage];
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
            
            //[self dropSubmitButton];
            [self saveProfilePic:^ {
                [_delegate hideSignupPage];
                [_delegate showMapPageFromLogin];
                [self cleanUp];
                
                // for push notifications
                [self updateInstallationWithUser];
            }];
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
    
    [self.session beginConfiguration];
    [self.session removeInput:self.captureInput];
    [self.session commitConfiguration];
    [self.session stopRunning];
    self.imageTaken = nil;

    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
}

- (IBAction)exit:(id)sender{
    [self cleanUp];
    [_delegate hideSignupPage];
    [_delegate showSplashPage];
}

- (void) syncCoreDataWithServer {
    
}


- (void) loadCamera {
    
    self.session = [[AVCaptureSession alloc] init];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            self.frontDevice = device;
        }
    }
    
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    NSError *error;
    self.captureInput = [AVCaptureDeviceInput deviceInputWithDevice:self.frontDevice error:&error];
    if (!self.captureInput) {
        // Handle the error appropriately.
    }
    [self.session addInput:self.captureInput];
    
    NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG };
    AVCaptureStillImageOutput *newStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [newStillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddOutput:newStillImageOutput]) {
        [self.session addOutput:newStillImageOutput];
        self.stillImageOutput = newStillImageOutput;
    }
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    
    // set up the viewing hole
    self.profilePic = [[UIButton alloc] initWithFrame:CGRectMake(0,0,150,150)];
    [self.profilePic setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.profilePic setBackgroundColor:[UIColor redColor]];
    [self.profilePic addTarget:self action:@selector(growButtonAnimation:) forControlEvents:UIControlEventTouchDown];
    [self.profilePic addTarget:self action:@selector(shrinkButtonAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [self.profilePic addTarget:self action:@selector(shrinkButtonAnimation:) forControlEvents:UIControlEventTouchUpOutside];

    [self.view addSubview:self.profilePic];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.profilePic attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.passwordDummy attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.profilePic attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.profilePic attribute:NSLayoutAttributeTop multiplier:1.0 constant:150]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.profilePic attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.profilePic.frame.size.height]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.profilePic attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    CGRect bounds = [self.profilePic bounds];
    [captureVideoPreviewLayer setFrame:bounds];
    [self.profilePic.layer addSublayer:captureVideoPreviewLayer];
    
    self.profilePic.layer.cornerRadius = self.profilePic.layer.frame.size.width/2;
    self.profilePic.clipsToBounds = YES;
    
    [self.session startRunning];
}

- (void) growButtonAnimation: (UIButton*) button {
    [self.imageTaken.layer removeFromSuperlayer];

    [UIView animateWithDuration:.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        button.transform = CGAffineTransformMakeScale(1.5,1.5);
        
    } completion:^(BOOL finished) {
        
        return;
    }];
}

- (void)shrinkButtonAnimation: (UIButton *) button  {
    [UIView animateWithDuration:.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        button.transform = CGAffineTransformMakeScale(1,1);
        
    } completion:^(BOOL finished) {
        [self takePhoto];
        return;
    }];
}

- (void) takePhoto {
    
    [self hideErrorMessage];
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != NULL) {
            NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [[UIImage alloc] initWithData:data];
            UIImage *flipped = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationLeftMirrored];

            
            self.imageTaken = [[UIImageView alloc] initWithImage:flipped];
            self.imageData = data;
        
            self.imageTaken.contentMode = UIViewContentModeScaleAspectFill;
            self.imageTaken.clipsToBounds = YES;
            self.imageTaken.frame = self.profilePic.layer.bounds;
            
            [self.profilePic.layer addSublayer:self.imageTaken.layer];
        }
    }];
}


- (void) saveProfilePic:(void (^)()) completion {
    PFFile *imageFile = [PFFile fileWithName:@"profilePic.gif" data:self.imageData];

    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFUser *user = [PFUser currentUser];
            [user setObject:imageFile forKey:@"profilePic"];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [LocalStorage getUser:^(NSMutableDictionary *data2) {
                    User *user = [data2 objectForKey:@"users"];
                    user.profilePic = self.imageData;
                    [LocalStorage saveDoc];
                    if (completion)
                        completion();
                }];
                
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        //HUD.progress = (float)percentDone/100;
    }];
}

@end
