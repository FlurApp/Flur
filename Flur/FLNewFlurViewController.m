//
//  FLNewFlurViewController.m
//  Flur
//
//  Created by David Lee on 12/2/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import "FLNewFlurViewController.h"
#import "FLConstants.h"

#import "UILabel+MultiColor.h"
#import "FLFlurAnnotation.h"
#import "Flur.h"
#import "FLPhotoManager.h"


@interface FLNewFlurViewController ()


@property (nonatomic, strong) UITextView *promptInput;
@property (nonatomic, strong) UILabel *placeholder;
@property (nonatomic, strong) UILabel *charCount;
@property (nonatomic, strong) UIButton *addFlur;

@property (nonatomic, strong) NSLayoutConstraint *promptInputBottom;
@property (nonatomic, strong) NSLayoutConstraint *addButtonBottom;

@property (nonatomic) BOOL active;
@property (nonatomic) CGRect keyboard;

@property (nonatomic, strong) UILabel *dateLabel;






@end


@implementation FLNewFlurViewController

- (void) setup {
    self.active = true;
}

- (void) setFocus:(BOOL)yesNo {
    if (yesNo)
        [self.promptInput becomeFirstResponder];
    else
        [self.promptInput resignFirstResponder];
}

- (void) cleanUp {
    self.active = false;
    self.promptInput.text = @"";
    self.placeholder.text = @"Add your prompt here";
    self.charCount.text = @"0/200";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d, YYYY"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
    
    [UIView animateWithDuration:.2 animations:^{
        self.addButtonBottom.constant = 110;
    }];
}

- (void)viewDidLoad {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow:)
                   name:UIKeyboardDidShowNotification object:nil];
    
    
    self.promptInput = [[UITextView alloc] init];
    [self.promptInput setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.promptInput];
    self.promptInput.backgroundColor = RGBA(255, 255, 255, .9);
    [self.promptInput setTintColor: RGB(13,191,255)];



    
    self.promptInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.promptInput.delegate = self;
    [self.promptInput setReturnKeyType:UIReturnKeyDone];
    self.promptInput.keyboardAppearance = UIKeyboardAppearanceLight;
    self.promptInput.keyboardType = UIKeyboardTypeAlphabet;
    self.promptInput.autocorrectionType = UITextAutocorrectionTypeNo;
    self.promptInput.textAlignment = NSTextAlignmentLeft;


    [self.promptInput setFont:[UIFont fontWithName:@"Avenir-Light" size:23]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.promptInput attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    self.promptInputBottom = [NSLayoutConstraint constraintWithItem:self.promptInput attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    //[self.view addConstraint:self.promptInputBottom];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.promptInput attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.promptInput attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10]];
    
    
    
    
    self.placeholder = [[UILabel alloc] init];
    [self.placeholder setFont:[UIFont fontWithName:@"Avenir-Light" size:23]];
    [self.placeholder setTextColor:RGBA(150,150,150, 1)];
    self.placeholder.text = @"Add your prompt here";
    
    [self.placeholder setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.promptInput addSubview:self.placeholder];

    [self.promptInput addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholder attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.promptInput attribute:NSLayoutAttributeTop multiplier:1.0 constant:10]];
    
    [self.promptInput addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholder attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.promptInput attribute:NSLayoutAttributeLeading multiplier:1.0 constant:5]];
    
    [self loadWaste];
    
}

- (IBAction)addFlur:(id)sender {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    if (self.promptInput.text.length == 0)
        return;
    
    data[@"prompt"] = self.promptInput.text;
    [self.delegate addFlurToCamera:data];
    [self.view endEditing:YES];
    
    [self cleanUp];

}

- (void) loadWaste {
    UIView *waste1 = [[UIView alloc] init];
    [waste1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:waste1];
    waste1.backgroundColor = RGBA(255, 255, 255, .9);
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:waste1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:waste1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.promptInput attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:waste1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:waste1 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    
    UIView *waste2 = [[UIView alloc] init];
    [waste2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:waste2];
    waste2.backgroundColor = RGBA(255, 255, 255, .9);
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:waste2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:waste2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.promptInput attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:waste2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:waste2 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    
    
    UIView *bottomBar = [[UIView alloc] init];
    [bottomBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:bottomBar];
    bottomBar.backgroundColor = RGB(240,240,240);//RGBA(13,191,255, .9);
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.promptInput attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.promptInput attribute:NSLayoutAttributeBottom multiplier:1.0 constant:55]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    [self.view layoutIfNeeded];

    
    self.charCount = [[UILabel alloc] init];
    [self.charCount setFont:[UIFont fontWithName:@"Avenir-Light" size:23]];
    [self.charCount setTextColor:RGBA(179, 88, 224, 1)];//RGBA(255,255,255, 1)];
    self.charCount.text = @"0/200";
    
    [self.charCount setTranslatesAutoresizingMaskIntoConstraints:NO];
    [bottomBar addSubview:self.charCount];
    
    [bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.charCount attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bottomBar attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.charCount attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:bottomBar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10]];
    
    
    self.dateLabel = [[UILabel alloc] init];
    [self.dateLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:23]];
    [self.dateLabel setTextColor:RGBA(179, 88, 224, 1)];//RGBA(255,255,255, 1)];
    
    [self.dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [bottomBar addSubview:self.dateLabel];
    
    [bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bottomBar attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:bottomBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d, YYYY"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
    
    
    
    
    
    
    self.addFlur = [[UIButton alloc] init];
    [self.addFlur setTitle:@"Add Flur" forState:UIControlStateNormal];
    [self.addFlur setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.addFlur.backgroundColor = RGBA(13,191,255, 1);
    [self.addFlur setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [self.addFlur addTarget:self action:@selector(addFlur:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.addFlur];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.addFlur attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bottomBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    self.addButtonBottom = [NSLayoutConstraint constraintWithItem:self.addFlur attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:110];
    
    [self.view addConstraint:self.addButtonBottom];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.addFlur attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:55]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.addFlur attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.addFlur attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];


}

-(void)keyboardDidShow:(NSNotification*)notification {
    if (!self.active)
        return;
    // Keyboard frame is in window coordinates
    NSDictionary *userInfo = [notification userInfo];
    self.keyboard = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.addButtonBottom.constant = -self.keyboard.size.height + 110;
    [self.view layoutIfNeeded];
    // Put both the submit button and the error message label right above the keyboard vertically
    [UIView animateWithDuration:.15 animations:^{
        self.addButtonBottom.constant = -self.keyboard.size.height;
        [self.view layoutIfNeeded];

    }];
    
    return;
    
}

- (void)textViewDidChange:(UITextView *)textView {
    self.charCount.text = [NSString stringWithFormat:@"%lu/200", self.promptInput.text.length];
    if (self.promptInput.text.length == 0)
        self.placeholder.text = @"Add your prompt here";
    else
        self.placeholder.text = @"";
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self addFlur:textField];
    return NO;
}

//- (IBAction)addFlur:(id)sender {
//    [_delegate addFlur:@"test"];
//}

@end
