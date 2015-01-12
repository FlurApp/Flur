//
//  PhotoViewController.m
//  Flur
//
//  Created by Netanel Rubin on 10/13/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <Parse/Parse.h>

#import "PhotoViewController.h"
#import "SinglePhotoViewController.h"
#import "FLConstants.h"
#import "Flur.h"

#define flurYellow RGBA(255,220,70,.98)
#define flurBlue RGBA(13,191,255,1)
#define flurPurple RGBA(179,88,224,1)
#define flurRed RGBA(244,99,83,1)

@interface PhotoViewController ()

// UI elements
@property (strong, nonatomic) UILabel * viewPrompt;
@property (strong, nonatomic) UIView * topBar;
@property (strong, nonatomic) UIView * bottomBar;
@property (strong, nonatomic) UILabel* currentPicture;
@property (nonatomic, strong) UIButton *exitButton;
@property (nonatomic, strong) UIButton *flagButton;

// Used to pass top/bottom bar to SinglePhotoVC so it can toggle views
@property   (strong, nonatomic) NSMutableArray *viewsToToggle;

@property (strong, nonatomic) NSMutableArray *allPhotos;
@property (strong, nonatomic) NSString *prompt;

// Used to detect whether two async calls have returned
@property (nonatomic) int count;
@property (nonatomic) bool topBarVisible;

@property (nonatomic,strong) NSMutableDictionary *pin_data;

@end

@implementation PhotoViewController

- (void) setData: (NSMutableDictionary*) data {
    
    // Set appearance of status bar
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.pin_data = data;
    self.pin = [data objectForKey:@"FLPin"];
    self.topBarVisible = true;
    self.allPhotos = [data objectForKey:@"allPhotos"];
    
    // sort the photos by date
    [self.allPhotos sortUsingComparator:^NSComparisonResult(id a, id b) {
        
        NSDate *date1 = a[0];
        NSDate *date2 = b[0];
        
        return [date1 compare:date2];
    }];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    // Set up controller for the multiple page view
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    
    // date string
    self.dateLabel = [[UILabel alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d, YYYY"];
    
    if (self.pin) {
        self.viewPrompt.text = self.pin.prompt;
        self.dateLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self.pin.dateCreated]];
    }
    else {
        Flur *flur = [data objectForKey:@"flur"];
        self.viewPrompt.text = flur.prompt;
        self.dateLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:flur.dateCreated]];
    }
    [self.dateLabel setTextColor:[UIColor whiteColor]];
    
    SinglePhotoViewController *initialViewController = [self viewControllerAtIndex:0];
    
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    // Load custom views
    [self loadViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];

       // Allocate space for all data members
    self.viewPrompt =       [[UILabel alloc] init];
    self.currentPicture =   [[UILabel alloc] init];
    self.topBar =           [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomBar =        [[UIView alloc] initWithFrame:CGRectZero];
    
    self.viewsToToggle =    [[NSMutableArray alloc] init];
}



- (void) loadTopBar {
    self.topBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.topBar.backgroundColor = flurRed;

    [self.view addSubview:self.topBar];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:80]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
//    UIBlurEffect *blurEffect;
//    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    
//    UIVisualEffectView *blurEffectView;
//    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    blurEffectView.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    
//    [self.topBar addSubview:blurEffectView];
//    
//    [self.topBar addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
//    
//    [self.topBar addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
//    
//    
//    [self.topBar addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
//    
//    [self.topBar addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];

    
    UIButton *exitButton = [[UIButton alloc] init];
    exitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [exitButton setImage:[UIImage imageNamed:@"less_then-100.png"] forState:UIControlStateNormal];
    [exitButton setImageEdgeInsets:UIEdgeInsetsMake(5,5,5,5)];
   
    [exitButton addTarget:self
                   action:@selector(navBack)
         forControlEvents:UIControlEventTouchUpInside];
    
    self.exitButton = exitButton;
    [self.topBar addSubview:self.exitButton];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.exitButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:10]];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.exitButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:5]];
    
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.exitButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.exitButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.0]];
    

    self.currentPicture.text = [NSString stringWithFormat:@"1/%lu", (unsigned long) self.allPhotos.count];
    NSLog(@"%@",self.currentPicture.text);
    
    [self.currentPicture setTextColor:flurBlue];
    [self.currentPicture setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:25]];

    self.currentPicture.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.topBar addSubview:self.currentPicture];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.currentPicture attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.exitButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:2]];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.currentPicture attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10]];
}

- (void) loadBottomBar {
    self.bottomBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomBar.backgroundColor = flurRed;
    [self.view addSubview:self.bottomBar];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    [self.viewsToToggle addObject:self.topBar];
    [self.viewsToToggle addObject:self.bottomBar];
    
    self.topBar.alpha = 1;
    self.bottomBar.alpha = 1;
    
    // date label
    [self.dateLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:23]];
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bottomBar addSubview:self.dateLabel];
    
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:10]];
    
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10]];
    
    
    self.viewPrompt.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewPrompt setTextColor:flurYellow];
    [self.viewPrompt setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:18]];
    
    [self.bottomBar addSubview:self.viewPrompt];
    
    self.viewPrompt.numberOfLines = 0;
    self.viewPrompt.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.viewPrompt attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.dateLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.viewPrompt attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10]];
    
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.viewPrompt attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.viewPrompt attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10]];
    
    // Flag Button
    UIButton *flagButton = [[UIButton alloc] init];
    flagButton.translatesAutoresizingMaskIntoConstraints = NO;
    [flagButton setImage:[UIImage imageNamed:@"down_thumb.png"] forState:UIControlStateNormal];
    [flagButton setImageEdgeInsets:UIEdgeInsetsMake(5,5,5,5)];
    [flagButton addTarget:self
                   action:@selector(flagContent)
         forControlEvents:UIControlEventTouchUpInside];
    
    self.flagButton = flagButton;
    [self.bottomBar addSubview:self.flagButton];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.flagButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.flagButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-5]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.flagButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.flagButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.0]];
}

- (void) loadViews {
    [self loadTopBar];
    [self loadBottomBar];
}


- (void) navBack {
    [_delegate hidePhotoPage];
    
    if ([[self.pin_data objectForKey:@"previousPage"] isEqualToString: @"tablePage"])
        [_delegate showTablePage:-1];
    
    else {
        
        if ([[self.pin_data objectForKey:@"justAddedFlur"] isEqualToString:@"true"]) {
            [self.delegate animateNewPin];
        }
        else {
            [_delegate showMapPage];
        }
    }
}

- (void)flagContent {
    NSLog(@"flag content");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Report Content"
                                                    message:[NSString stringWithFormat: @"Press 'Report' to flag this photo as objectionable content."]
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Report",@"Cancel",nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        // Code for Report button
        SinglePhotoViewController* a= [self.pageController.viewControllers lastObject];
        
        Flur *flur = [self.pin_data objectForKey:@"flur"];
        PFObject* flurPin = [PFObject objectWithoutDataWithClassName:@"Images" objectId:self.allPhotos[a.index][2]];
        NSLog(@"%@",self.allPhotos[a.index][2]);
        [flurPin incrementKey:@"flagCount"];
        [flurPin saveInBackground];
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    if (buttonIndex == 1)
    {
        // Code for Cancel button
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
    }
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
    [childViewController.view setFrame:self.view.frame];
    
    childViewController.index = index;
    childViewController.viewsToToggle = self.viewsToToggle;
    [childViewController setImage:self.allPhotos[index][1]];
    
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
    NSLog(@"index %lu", (long)a.index);
    
    self.currentPicture.text = [NSString stringWithFormat:@"%d/%lu", (a.index+1), (unsigned long)self.allPhotos.count];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d, YYYY"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self.allPhotos[a.index][0]]];
}

@end
