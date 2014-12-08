//
//  FLSettingsViewController.m
//  Flur
//
//  Created by Netanel Rubin on 11/23/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <Parse/Parse.h>

#import "FLSettingsViewController.h"
#import "FLConstants.h"
#import "MainViewController.h"
#import "FLInitialMapViewController.h"
#import "LocalStorage.h"

@interface FLSettingsViewController ()

@property (nonatomic, strong) UIImageView *profilePicture;
//@property (nonatomic, strong) UILabel *username;
@property (nonatomic, strong) UILabel *email;
@property (nonatomic, strong) UILabel *contributionCount;

@property (nonatomic, strong) UIButton *logoutButton;
@property (nonatomic, strong) UIButton *changePassword;
@property (nonatomic, strong) UIButton *addNewFlur;
@property (nonatomic, strong) UIView *profilePictureBorder;

@end




@implementation FLSettingsViewController

- (void) setData {
    PFUser *user = [PFUser currentUser];
    self.email.text = user.email;
    self.contributionCount.text = user[@"createdAt"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(253,253,253);
    NSInteger screenWidth = self.view.frame.size.width - PANEL_WIDTH;

    
    self.profilePictureBorder = [[UIView alloc] init];
    [self.profilePictureBorder setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.profilePictureBorder];
    //self.profilePictureBorder.backgroundColor = [UIColor redColor];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.profilePictureBorder attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:50]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.profilePictureBorder attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:screenWidth/2]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.profilePictureBorder attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:profilePictureBorderSize]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.profilePictureBorder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:profilePictureBorderSize]];
    
    self.profilePictureBorder.layer.cornerRadius = profilePictureBorderSize/2;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, profilePictureBorderSize, profilePictureBorderSize);
    gradient.colors = [NSArray arrayWithObjects:(id)[RGBA(255, 198, 119, .98) CGColor], (id)[RGBA(255,234,77, .98) CGColor], nil];
    gradient.cornerRadius = profilePictureBorderSize/2;

    
    /*[gradient setShadowOffset:CGSizeMake(1, 1)];
    [gradient setShadowColor:[[UIColor blackColor] CGColor]];
    [gradient setShadowOpacity:0.5];*/
    
    [self.profilePictureBorder.layer insertSublayer:gradient atIndex:0];
    
    self.profilePicture = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flur_icon/flur_512.png"]];
    [self.profilePicture setTranslatesAutoresizingMaskIntoConstraints:NO];
  
    
    [self.view addSubview:self.profilePicture];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.profilePicture attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:50 + (profilePictureBorderSize-profilePictureSize)/2]];
    
      [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.profilePicture attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:screenWidth/2]];
    
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.profilePicture attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:profilePictureSize]];
    
       [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.profilePicture attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:profilePictureSize]];

    self.profilePicture.layer.cornerRadius = profilePictureSize/2;
    self.profilePicture.clipsToBounds = YES;
    
    self.profilePicture.layer.borderWidth = 3.0f;
    self.profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    
    PFUser* user = [PFUser currentUser];
    
//    self.username = [[UILabel alloc]init];
//    [self.username setTranslatesAutoresizingMaskIntoConstraints:NO];
//    self.username.text = user.username;
//    self.username.font = personalInfoFont;
//    [self.username setTextColor:personalInfoColor];
//
//
//    
//    [self.view addSubview:self.username];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.username attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.profilePictureBorder attribute:NSLayoutAttributeBottom multiplier:1.0 constant:25]];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.username attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.profilePicture attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    self.email = [[UILabel alloc]init];
    [self.email setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.email.text = user.username;
    
     self.email.font = personalInfoFont;
    [self.email setTextColor:personalInfoColor];

    
    [self.view addSubview:self.email];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.email attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.profilePictureBorder attribute:NSLayoutAttributeBottom multiplier:1.0 constant:25]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.email attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.profilePicture attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d, YYYY"];
    
    self.contributionCount = [[UILabel alloc]init];
    [self.contributionCount setTranslatesAutoresizingMaskIntoConstraints:NO];
    //self.contributionCount.text =[NSString stringWithFormat:@"Contributions: %lu", [PFUser currentUser].numContributions];
    self.contributionCount.text = [NSString stringWithFormat:@"Joined: %@",[dateFormatter stringFromDate:user.createdAt]];
     self.contributionCount.font = personalInfoFont;
    [self.contributionCount setTextColor:personalInfoColor];
    
    [self.view addSubview:self.contributionCount];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.contributionCount attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.email attribute:NSLayoutAttributeTop multiplier:1.0 constant:25]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.contributionCount attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.email attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    self.addNewFlur = [[UIButton alloc] init];
    [self.addNewFlur setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.addNewFlur addTarget:self action:@selector(addFlur:) forControlEvents:UIControlEventTouchUpInside];

    
    [self.addNewFlur setTitle:@"Drop Flur" forState:UIControlStateNormal];
    self.addNewFlur.backgroundColor = RGB(179,88,224);
    self.addNewFlur.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:20];
    [self.addNewFlur setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [self.view addSubview:self.addNewFlur];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.addNewFlur attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contributionCount attribute:NSLayoutAttributeBottom multiplier:1.0 constant:25]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.addNewFlur attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.addNewFlur attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-PANEL_WIDTH]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.addNewFlur attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:buttonHeight]];
    
    
    self.changePassword = [[UIButton alloc] init];
    [self.changePassword setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.changePassword setTitle:@"Change Password" forState:UIControlStateNormal];
    self.changePassword.backgroundColor = RGB(13,191,255);
    self.changePassword.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:20];
    [self.changePassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.changePassword addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];

    
    
    [self.view addSubview:self.changePassword];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.changePassword attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.addNewFlur attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.changePassword attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.changePassword attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-PANEL_WIDTH]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.changePassword attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:buttonHeight]];
    
    self.logoutButton = [[UIButton alloc] init];
    [self.logoutButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.logoutButton addTarget:self action:@selector(logOut:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    self.logoutButton.backgroundColor = RGB(244,99,83);
    self.logoutButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:20];
    [self.logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [self.view addSubview:self.logoutButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.changePassword attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-PANEL_WIDTH]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:buttonHeight]];
    
    // Do any additional setup after loading the view.
}

- (IBAction)logOut:(id)sender {
    [PFUser logOut];
    [LocalStorage deleteAllFlurs];
    

    [LocalStorage destroyLocalStorage];
    
    [_delegate logout];
    [_delegate hideSettingsPage];
//    [_delegate hideMapPage];
//    [_delegate showSplashPage];
}

- (IBAction)addFlur:(id)sender {
    [_delegate showDropFlurPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)resetPassword:(id)sender{
    
    [PFUser requestPasswordResetForEmailInBackground:[PFUser currentUser].email
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
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[NSString stringWithFormat: @"%@",errorString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [alert show];
           return;
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
