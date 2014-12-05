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



@end


@implementation FLNewFlurViewController

- (void) setup {
    
}

- (void) setFocus {
    [self.promptInput becomeFirstResponder];
}

- (void)viewDidLoad {
    
    self.promptInput = [[UITextView alloc] init];
    [self.promptInput setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.promptInput.delegate = self;
    [self.view addSubview:self.promptInput];
    self.promptInput.backgroundColor = RGBA(255, 255, 255, .9);
    [self.promptInput setTintColor: RGB(13,191,255)];



    
    self.promptInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.promptInput.returnKeyType = UIReturnKeyNext;
    self.promptInput.keyboardAppearance = UIKeyboardAppearanceLight;
    self.promptInput.keyboardType = UIKeyboardTypeAlphabet;
    self.promptInput.autocorrectionType = UITextAutocorrectionTypeNo;
    self.promptInput.textAlignment = NSTextAlignmentLeft;


    [self.promptInput setFont:[UIFont fontWithName:@"Avenir-Light" size:23]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.promptInput attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.promptInput attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:300]];
    
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
    
    
    
    
    self.addFlur = [[UIButton alloc] init];
    [self.addFlur setTitle:@"Add Flur" forState:UIControlStateNormal];
    [self.addFlur setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.addFlur.backgroundColor = RGBA(24, 112, 89, 1);
    [self.addFlur setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [self.addFlur addTarget:self action:@selector(addFlur:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.addFlur];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.addFlur attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:200]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.addFlur attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:250]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.addFlur attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.addFlur attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    [self loadWaste];
    
}

- (IBAction)addFlur:(id)sender {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    if (self.promptInput.text.length == 0)
        return;
    
    data[@"prompt"] = self.promptInput.text;
    [self.delegate addFlurToCamera:data];
    [self.view endEditing:YES];
}

- (void) loadWaste {
    UIView *waste1 = [[UIView alloc] init];
    [waste1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:waste1];
    waste1.backgroundColor = RGBA(255, 255, 255, .9);
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:waste1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:waste1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.promptInput attribute:NSLayoutAttributeBottom multiplier:1.0 constant:300]];
    
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
    bottomBar.backgroundColor = RGBA(13,191,255, .9);
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.promptInput attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.promptInput attribute:NSLayoutAttributeBottom multiplier:1.0 constant:55]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    [self.view layoutIfNeeded];

    
    self.charCount = [[UILabel alloc] init];
    [self.charCount setFont:[UIFont fontWithName:@"Avenir-Light" size:23]];
    [self.charCount setTextColor:RGBA(255,255,255, 1)];
    self.charCount.text = @"0/200";
    
    [self.charCount setTranslatesAutoresizingMaskIntoConstraints:NO];
    [bottomBar addSubview:self.charCount];
    
    [bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.charCount attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bottomBar attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.charCount attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:bottomBar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10]];
    
    
    UILabel *dateLabel = [[UILabel alloc] init];
    [dateLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:23]];
    [dateLabel setTextColor:RGBA(255,255,255, 1)];
    
    [dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [bottomBar addSubview:dateLabel];
    
    [bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bottomBar attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:bottomBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MMM d, YYYY"];
    
    dateLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];

}

- (void)textViewDidChange:(UITextView *)textView {
    self.charCount.text = [NSString stringWithFormat:@"%lu/200", self.promptInput.text.length];
    if (self.promptInput.text.length == 0)
        self.placeholder.text = @"Add your prompt here";
    else
        self.placeholder.text = @"";

    
}

//- (IBAction)addFlur:(id)sender {
//    [_delegate addFlur:@"test"];
//}

@end
