//
//  PhotoViewController.m
//  Flur
//
//  Created by Netanel Rubin on 10/13/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import <Parse/Parse.h>

#import "PhotoViewController.h"
#import "SinglePhotoViewController.h"
#import "FLMasterNavigationController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface PhotoViewController ()

// UI elements
@property   (strong, nonatomic) UILabel * viewPrompt;
@property   (strong, nonatomic) UIView * topBar;
@property   (strong, nonatomic) UIView * bottomBar;
@property   (strong, nonatomic) UILabel* currentPicture;

// Used to pass top/bottom bar to SinglePhotoVC so it can toggle views
@property   (strong, nonatomic) NSMutableArray *viewsToToggle;

@property (strong, nonatomic) NSMutableArray *allPhotos;
@property (strong, nonatomic) NSString *prompt;


// Used to detect whether two async calls have returned
@property (nonatomic) int count;
@property (nonatomic) bool topBarVisible;


@end

@implementation PhotoViewController

- (instancetype) initWithData: (NSMutableDictionary*) data {
    self = [super init];
    
    if (self) {
        self.pin = [data objectForKey:@"FLPin"];
        self.topBarVisible = true;
        self.allPhotos = [data objectForKey:@"allPhotos"];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

       // Allocate space for all data members
    self.viewPrompt =       [[UILabel alloc] init];
    self.currentPicture =   [[UILabel alloc] init];
    self.topBar =           [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomBar =        [[UIView alloc] initWithFrame:CGRectZero];
    
    self.viewsToToggle =    [[NSMutableArray alloc] init];

    self.view.backgroundColor = [UIColor blackColor];
//    self.pinId = @"c8kzGmjHaU";

    
    // Set up controller for the multiple page view
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    SinglePhotoViewController *initialViewController = [self viewControllerAtIndex:0];
   
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    // Load custom views
    [self loadViews];
}



- (void) loadTopBar {
    self.topBar.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.topBar];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:70]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    UIBlurEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *blurEffectView;
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [self.topBar addSubview:blurEffectView];
    
    [self.topBar addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self.topBar addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    
    [self.topBar addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.topBar addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];

    
    UIButton *exitButton = [[UIButton alloc] init];
    exitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [exitButton setImage:[UIImage imageNamed:@"leaveCamera.png"] forState:UIControlStateNormal];

   
    [exitButton addTarget:self
                   action:@selector(navBack)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self.topBar addSubview:exitButton];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:exitButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:28 ]];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:exitButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10]];
    
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:exitButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:30.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:exitButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:30.0]];
    
    
    self.currentPicture.text = [NSString stringWithFormat:@"1/%d", self.allPhotos.count];
    [self.currentPicture setTextColor:[UIColor whiteColor]];
    [self.currentPicture setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:25]];

    self.currentPicture.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.topBar addSubview:self.currentPicture];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.currentPicture attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:30]];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.currentPicture attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
}

- (void) loadBottomBar {
    self.bottomBar.translatesAutoresizingMaskIntoConstraints = NO;
    //self.bottomBar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bottomBar];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    [self.viewsToToggle addObject:self.topBar];
    [self.viewsToToggle addObject:self.bottomBar];
    
    self.topBar.alpha = 1;
    self.bottomBar.alpha = 1;
    
    UIBlurEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *blurEffectView;
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [self.bottomBar addSubview:blurEffectView];
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    UILabel* prompt = [[UILabel alloc] init];
    [prompt setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:23]];

    prompt.translatesAutoresizingMaskIntoConstraints = NO;
    prompt.text = @"What did we do?";
    [prompt setTextColor:RGB(98,234,239)];
    
    [self.bottomBar addSubview:prompt];
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:prompt attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:10]];
    
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:prompt attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:prompt attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10]];
    
    
    
    self.viewPrompt.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewPrompt setTextColor:[UIColor whiteColor]];
    [self.viewPrompt setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:18]];

    self.viewPrompt.text = self.pin.prompt;
    
    [self.bottomBar addSubview:self.viewPrompt];
    
    self.viewPrompt.numberOfLines = 0;
    self.viewPrompt.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.viewPrompt attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:prompt attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.viewPrompt attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10]];
    
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.viewPrompt attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.viewPrompt attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10]];
}

- (void) loadViews {
    [self loadTopBar];
    [self loadBottomBar];
}


- (void) navBack {
   // AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   // [appDelegate popMyself];
    [FLMasterNavigationController switchToViewController:@"FLInitialMapViewController" fromViewController:@"PhotoViewController" withData:[[NSMutableDictionary alloc]init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(SinglePhotoViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(SinglePhotoViewController *)viewController index];
    
    
    index++;
    
    if (index == [self.allPhotos count]) {
        return nil;
    }

    return [self viewControllerAtIndex:index];
    
}

- (SinglePhotoViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    SinglePhotoViewController *childViewController = [[SinglePhotoViewController alloc] init];
    
    childViewController.index = index;
    childViewController.viewsToToggle = self.viewsToToggle;
    [childViewController setImage:self.allPhotos[index]];
    
    return childViewController;    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 0;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

- (void)pageViewController:(UIPageViewController *)pvc didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    // If the page did not turn
    if (!completed)
    {
        // You do nothing because whatever page you thought
        // the book was on before the gesture started is still the correct page
        return;
    }
    
    // Everytime a page is turned, grab the index of the current page, display as current photo number
    SinglePhotoViewController* a= [self.pageController.viewControllers lastObject];
    NSLog(@"index %lu", a.index);
    
    self.currentPicture.text = [NSString stringWithFormat:@"%lu/%lu", (a.index+1), (unsigned long)self.allPhotos.count];
}


@end
