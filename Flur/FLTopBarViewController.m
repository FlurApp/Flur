//
//  FLTopBarViewController.m
//  Flur
//
//  Created by Netanel Rubin on 12/1/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import "FLTopBarViewController.h"
#import "FLConstants.h"

@interface FLTopBarViewController ()
@property (nonatomic, strong) UIView *topBarContainer;
@property (nonatomic, strong) UIImageView *flurImageContainer;
@property (nonatomic, strong) UILabel *pageTitle;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIView *purpleView;
@property (nonatomic, strong) UIView *blueView;





@property (nonatomic) BOOL tableViewMode;
@property (nonatomic) BOOL infoViewMode;
//@property (nonatomic) BOOL dropFlurViewMode;


@end

@implementation FLTopBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.infoViewMode = false;
    self.tableViewMode = false;
    
    /* ---------------------------------------
                Setup Top Bar
    -----------------------------------------*/
    self.topBarContainer = [[UIView alloc] init];
    self.topBarContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.topBarContainer.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.topBarContainer];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBarContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBarContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:TOP_BAR_HEIGHT]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBarContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBarContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    


    
    

    

    
    
    
    /* ----------------------------------------------------------
                Add Flur Image  to Top Bar
     -----------------------------------------------------------*/
    UIImage *flurImage = [UIImage imageNamed:@"flurfont.png"];
    self.flurImageContainer = [[UIImageView alloc] initWithImage:flurImage];
    self.flurImageContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.topBarContainer addSubview:self.flurImageContainer];
    
    [self.topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.flurImageContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topBarContainer attribute:NSLayoutAttributeTop multiplier:1.0 constant:35]];
    
    [self.topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.flurImageContainer attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.topBarContainer attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.flurImageContainer
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:30.0]];
    [self.topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.flurImageContainer
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:60.0]];
    
    
    /* ----------------------------------------------------------
     Add Settings button to Top Bar
     -----------------------------------------------------------*/
    self.menuButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.menuButton = [[UIButton alloc] init];
    self.menuButton.tag = 1;
    [self.menuButton addTarget:self action:@selector(showSettingsPage:)
              forControlEvents:UIControlEventTouchUpInside];
    self.menuButton.backgroundColor = [UIColor clearColor];
    
    // create image for menu button
    UIImage* hamburger = [UIImage imageNamed:@"menu-32.png"];
    CGRect rect = CGRectMake(0,0,75,75);
    UIGraphicsBeginImageContext(rect.size);
    [hamburger drawInRect:rect];
    UIImage *hamburgerResized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(hamburgerResized);
    UIImage *menuImg = [UIImage imageWithData:imageData];
    
    // set image for menu button
    [self.menuButton setImage:menuImg forState:UIControlStateNormal];
    [self.menuButton setContentMode:UIViewContentModeCenter];
    [self.menuButton setImageEdgeInsets:UIEdgeInsetsMake(25,25,25,25)];
    
    // add menu button to view
    [self.menuButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.topBarContainer addSubview:self.menuButton];
    
    [self.topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.menuButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.flurImageContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self.topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.menuButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.topBarContainer attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    

    
    /* ----------------------------------------------------------
     Add Table List button to Top Bar
     -----------------------------------------------------------*/
    self.tableListButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.tableListButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.tableListButton.tag = 1;
    [self.tableListButton addTarget:self action:@selector(showTableView:)
                   forControlEvents:UIControlEventTouchUpInside];
    
    [self.topBarContainer addSubview: self.tableListButton];
    
    [self.topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.tableListButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.flurImageContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self.topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.tableListButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.topBarContainer attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-20]];
    
    
    /* ----------------------------------------------------------
                Add Blue and Purple Gradients to Top Bar
     -----------------------------------------------------------*/
    
    self.purpleView = [[UIView alloc] init];
    [self.purpleView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.topBarContainer addSubview:self.purpleView];

    self.purpleView.frame = CGRectMake(0, 0, self.topBarContainer.frame.size.width, self.topBarContainer.frame.size.height);
    
    
     CAGradientLayer *gradient1 = [CAGradientLayer layer];
     gradient1.frame = self.topBarContainer.bounds;
     gradient1.colors = [NSArray arrayWithObjects:(id)[RGBA(186,108,224, 1) CGColor], (id)[RGBA(179, 88, 224, 1) CGColor], nil];



     [self.purpleView.layer insertSublayer:gradient1 atIndex:0];
    
    
    
    
    
    self.blueView = [[UIView alloc] init];
    [self.blueView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.topBarContainer addSubview:self.blueView];
    
    self.blueView.frame = CGRectMake(self.view.frame.size.width, 0, self.topBarContainer.frame.size.width, self.topBarContainer.frame.size.height);
    
    
    CAGradientLayer *gradient2 = [CAGradientLayer layer];
    gradient2.frame = self.blueView.bounds;
    gradient2.colors = [NSArray arrayWithObjects:(id)[RGBA(99, 214, 255, 1) CGColor], (id)[RGBA(9, 190, 255, 1) CGColor], nil];

    
    [self.blueView.layer insertSublayer:gradient2 atIndex:0];
    
    
    
    
    
    
    /* ---------------------------------------
            Add Page Title to Top Bar
     -----------------------------------------*/
    
    
    
    
    self.pageTitle = [[UILabel alloc] init];
    [self.pageTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.pageTitle.textAlignment = NSTextAlignmentCenter;
    self.pageTitle.text = @"asdf";
    [self.pageTitle setFont:[UIFont fontWithName:@"Avenir-Light" size:25]];
    [self.pageTitle setTextColor:[UIColor whiteColor]];
    self.pageTitle.alpha = 0;
    
    [self.topBarContainer addSubview:self.pageTitle];
    
    [self.topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.pageTitle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.topBarContainer attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.pageTitle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.flurImageContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    
    /* ----------------------------------------------------------
                Add Back Button  to Top Bar
     -----------------------------------------------------------*/
    self.backButton = [[UIButton alloc] init];
    [self.backButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.backButton addTarget:self action:@selector(backButtonPress:)
              forControlEvents:UIControlEventTouchDown];
    [self.backButton setImage:[UIImage imageNamed:@"less_then-100.png"] forState:UIControlStateNormal];
    self.backButton.alpha = 0;
    [self.topBarContainer addSubview:self.backButton];
    
    [self.topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.topBarContainer attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    
    [self.topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.flurImageContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
   [self.topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30]];
    
   [self.topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30]];
    
    [self.topBarContainer sendSubviewToBack:self.purpleView];
    [self.topBarContainer sendSubviewToBack:self.blueView];

}

- (IBAction)backButtonPress:(id)sender {
    if (self.tableViewMode) {
        [self.delegate hideTablePage];
        self.tableViewMode = false;
        
        [self showMapBar];
    }
    else if (self.infoViewMode) {
        self.infoViewMode = false;
        self.tableViewMode = true;
        [self.delegate hideInfoPage];
        [UIView animateWithDuration:.2 animations:^{
            self.pageTitle.alpha = 0;
        } completion:^(BOOL finished) {
            self.pageTitle.text = @"Past Contributions";
            [UIView animateWithDuration:.2 animations:^{
                self.pageTitle.alpha = 1;
            }];
        }];
        
    }
    
}

- (void) revertTopBar {
    self.pageTitle.alpha = 0;
    self.flurImageContainer.alpha = 1;
}

- (IBAction)showTableView:(id)sender {
    [self.delegate showTablePage];

    [self showTableBar];
}

- (void) showTableBar {
    self.tableViewMode = true;
    [self.topBarContainer bringSubviewToFront:self.blueView];
    [self.topBarContainer sendSubviewToBack:self.purpleView];

    
    [UIView animateWithDuration:.2 animations:^{
        self.menuButton.alpha = 0;
        self.tableListButton.alpha = 0;
        self.flurImageContainer.alpha = 0;
        
        self.blueView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.purpleView.frame = CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);


    } completion:^(BOOL finished) {
        [self.topBarContainer sendSubviewToBack:self.blueView];
        self.pageTitle.text = @"Past Contributions";
        [UIView animateWithDuration:.2 animations:^{
            self.pageTitle.alpha = 1;
            self.backButton.alpha = 1;
        }];
    }];

}

- (void) showMapBar {
    [self.topBarContainer bringSubviewToFront:self.purpleView];
    [self.topBarContainer sendSubviewToBack:self.blueView];

    [UIView animateWithDuration:.2 animations:^{
        self.pageTitle.alpha = 0;
        self.backButton.alpha = 0;
        
        self.blueView.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.purpleView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);


    } completion:^(BOOL finished) {
        [self.topBarContainer sendSubviewToBack:self.purpleView];
        [UIView animateWithDuration:.2 animations:^{
            self.menuButton.alpha = 1;
            self.tableListButton.alpha = 1;
            self.flurImageContainer.alpha = 1;
        }];
    }];
}

- (IBAction)showSettingsPage:(id)sender {
    [self.delegate settingButtonPress];
}

- (void) showInfoPageBar {
    self.tableViewMode = false;
    self.infoViewMode = true;

    
    [UIView animateWithDuration:.2 animations:^{
        self.pageTitle.alpha = 0;
        self.backButton.alpha = 0;
    } completion:^(BOOL finished) {
        self.pageTitle.text = @"Flur Info";
        [UIView animateWithDuration:.2 animations:^{
            self.pageTitle.alpha = 1;
        }];
    }];
 
}

- (void) showDropFlurBar {
    
    self.flurImageContainer.alpha = 0;
    
    [UIView animateWithDuration:.2 animations:^{
        self.pageTitle.alpha = 0;
    } completion:^(BOOL finished) {
        self.pageTitle.text = @"Drop Flur";
        [UIView animateWithDuration:.2 animations:^{
            self.pageTitle.alpha = 1;
        }];
    }];
    
}

- (void) showContributeBar {
    self.tableViewMode = true;
    [UIView animateWithDuration:.2 animations:^{
        self.menuButton.alpha = 0;
        self.tableListButton.alpha = 0;
        self.flurImageContainer.alpha = 0;
    } completion:^(BOOL finished) {
        self.pageTitle.text = @"Contribute";
        [UIView animateWithDuration:.2 animations:^{
            self.pageTitle.alpha = 1;
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
