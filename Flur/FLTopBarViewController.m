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
    UIView *topBarContainer = [[UIView alloc] init];
    topBarContainer.translatesAutoresizingMaskIntoConstraints = NO;
    topBarContainer.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:topBarContainer];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBarContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBarContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:TOP_BAR_HEIGHT]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBarContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:topBarContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    


    
    

    
    /* ----------------------------------------------------------
                Add Table List button to Top Bar
     -----------------------------------------------------------*/
    self.tableListButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.tableListButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.tableListButton.tag = 1;
    [self.tableListButton addTarget:self action:@selector(showTableView:)
                   forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview: self.tableListButton];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.tableListButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topBarContainer attribute:NSLayoutAttributeTop multiplier:1 constant:33]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.tableListButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:topBarContainer attribute:NSLayoutAttributeTrailing multiplier:1 constant:-17]];
    
    
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
    [[self view] addSubview:self.menuButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topBarContainer attribute:NSLayoutAttributeTop multiplier:1.0 constant:8]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:topBarContainer attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-8]];
    
    
    /* ----------------------------------------------------------
                Add Flur Image  to Top Bar
     -----------------------------------------------------------*/
    UIImage *flurImage = [UIImage imageNamed:@"flurfont.png"];
    self.flurImageContainer = [[UIImageView alloc] initWithImage:flurImage];
    self.flurImageContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [topBarContainer addSubview:self.flurImageContainer];
    
    [topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.flurImageContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topBarContainer attribute:NSLayoutAttributeTop multiplier:1.0 constant:35]];
    
    [topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.flurImageContainer attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:topBarContainer attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.flurImageContainer
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:30.0]];
    [topBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.flurImageContainer
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:60.0]];
    
    self.purpleView = [[UIView alloc] init];
    [self.purpleView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [topBarContainer addSubview:self.purpleView];

    self.purpleView.frame = CGRectMake(0, 0, topBarContainer.frame.size.width, topBarContainer.frame.size.height);
    
    
     CAGradientLayer *gradient1 = [CAGradientLayer layer];
     gradient1.frame = topBarContainer.bounds;
     gradient1.colors = [NSArray arrayWithObjects:(id)[RGBA(186,108,224, 1) CGColor], (id)[RGBA(179, 88, 224, 1) CGColor], nil];



     [self.purpleView.layer insertSublayer:gradient1 atIndex:0];
    
    
    
    
    
    self.blueView = [[UIView alloc] init];
    [self.blueView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [topBarContainer addSubview:self.blueView];
    
    self.blueView.frame = CGRectMake(self.view.frame.size.width, 0, topBarContainer.frame.size.width, topBarContainer.frame.size.height);
    
    
    CAGradientLayer *gradient2 = [CAGradientLayer layer];
    gradient2.frame = self.blueView.bounds;
    gradient2.colors = [NSArray arrayWithObjects:(id)[RGBA(99, 214, 255, 1) CGColor], (id)[RGBA(9, 190, 255, 1) CGColor], nil];

    
    [self.blueView.layer insertSublayer:gradient2 atIndex:0];
    
    
    
    
    
    
    /* ---------------------------------------
     Add gradient to Top Bar
     -----------------------------------------*/
    
    
    
    
    self.pageTitle = [[UILabel alloc] init];
    [self.pageTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.pageTitle.textAlignment = NSTextAlignmentCenter;
    self.pageTitle.text = @"asdf";
    [self.pageTitle setFont:[UIFont fontWithName:@"Avenir-Light" size:25]];
    [self.pageTitle setTextColor:[UIColor whiteColor]];
    self.pageTitle.alpha = 0;
    
    [self.view addSubview:self.pageTitle];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageTitle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageTitle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:50]];
    
    
    
    /* ----------------------------------------------------------
                Add Back Button  to Top Bar
     -----------------------------------------------------------*/
    self.backButton = [[UIButton alloc] init];
    [self.backButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.backButton addTarget:self action:@selector(backButtonPress:)
              forControlEvents:UIControlEventTouchDown];
    [self.backButton setImage:[UIImage imageNamed:@"less_then-100.png"] forState:UIControlStateNormal];
    self.backButton.alpha = 0;
    [self.view addSubview:self.backButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:50]];
    
   [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30]];
    
   [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30]];
    
    [self.view bringSubviewToFront:self.purpleView];
    [self.view sendSubviewToBack:self.blueView];

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
    [self.view bringSubviewToFront:self.blueView];
    [self.view sendSubviewToBack:self.purpleView];

    
    [UIView animateWithDuration:.2 animations:^{
        self.menuButton.alpha = 0;
        self.tableListButton.alpha = 0;
        self.blueView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.purpleView.frame = CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);


    } completion:^(BOOL finished) {
        self.pageTitle.text = @"Past Contributions";
        [UIView animateWithDuration:.2 animations:^{
            self.pageTitle.alpha = 1;
            self.backButton.alpha = 1;
        }];
    }];

}

- (void) showMapBar {
    [self.view bringSubviewToFront:self.purpleView];
    [self.view sendSubviewToBack:self.blueView];
    
    [UIView animateWithDuration:.2 animations:^{
        self.pageTitle.alpha = 0;
        self.backButton.alpha = 0;
        self.blueView.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.purpleView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);


    } completion:^(BOOL finished) {
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