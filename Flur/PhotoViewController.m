//
//  PhotoViewController.m
//  Flur
//
//  Created by Netanel Rubin on 10/13/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import "PhotoViewController.h"
#import "SinglePhotoViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface PhotoViewController ()

// UI elements
@property   (strong, nonatomic) UIImageView * spinner;
@property   (strong, nonatomic) UILabel * viewPrompt;
@property   (strong, nonatomic) UIView * topBar;
@property   (strong, nonatomic) UIView * bottomBar;
@property   (strong, nonatomic) UILabel* currentPicture;

// Used to pass top/bottom bar to SinglePhotoVC so it can toggle views
@property   (strong, nonatomic) NSMutableArray *viewsToToggle;

@property (strong, nonatomic) NSMutableArray *allPhotos;

// Used to detect whether two async calls have returned
@property (nonatomic) int count;
@property (nonatomic) bool topBarVisible;


@end

@implementation PhotoViewController

- (instancetype) initWithPin: (FLPin*) pin {
    self = [super init];
    
    if (self) {
        self.pinId = pin.pinId;
        self.topBarVisible = false;
        self.count = 0;
    }
    NSLog(@"Pin 3: %@", self.pinId);
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
       // Allocate space for all data members
    self.viewPrompt =       [[UILabel alloc] init];
    self.currentPicture =   [[UILabel alloc] init];
    self.topBar =           [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomBar =        [[UIView alloc] initWithFrame:CGRectZero];
    self.spinner =          [[UIImageView alloc] initWithFrame:self.view.bounds];
    
    self.viewsToToggle =    [[NSMutableArray alloc] init];
    self.allPhotos =        [[NSMutableArray alloc] init];

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
    
    // Wait until all views have been generated to pass the list of views that the SinglePhotoVC should
    // control
    initialViewController.viewsToToggle = self.viewsToToggle;
    
    // Query DB and load view when ready
    [self displayAllData];

 

        // Do any additional setup after loading the view.
}



- (void) loadSpinner {
    self.spinner.translatesAutoresizingMaskIntoConstraints = NO;

    NSMutableArray* frameHolders = [[NSMutableArray alloc] init];
    for(int i=0; i<29; i++) {
        NSString* imageName;
        if (i < 10)
            imageName = [NSString stringWithFormat:@"frame_00%d.gif", i];
        else
            imageName = [NSString stringWithFormat:@"frame_0%d.gif", i];

        [frameHolders addObject:[UIImage imageNamed:imageName]];
    }
    
    self.spinner.animationImages = [[NSArray alloc] initWithArray:frameHolders];
    self.spinner.animationDuration = 1.0f;
    self.spinner.animationRepeatCount = 0;
    [self.spinner startAnimating];
    [self.view addSubview:self.spinner];
    

    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.spinner
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                                           constant:0.0]];
    
    // Center Horizontally
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.spinner
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.spinner
                                                       attribute:NSLayoutAttributeHeight
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1.0
                                                        constant:100.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.spinner
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1.0
                                                        constant:100.0]];
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
    
    UIImage * exitImage = [UIImage imageNamed:@"exit_image.png"];
    [exitButton setBackgroundImage:exitImage forState:UIControlStateNormal];
    [exitButton addTarget:self
                   action:@selector(navBack)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self.topBar addSubview:exitButton];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:exitButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:20]];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:exitButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-5]];
    
    self.currentPicture.text = @"";
    [self.currentPicture setTextColor:[UIColor blackColor]];
    self.currentPicture.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.topBar addSubview:self.currentPicture];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.currentPicture attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:25]];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.currentPicture attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:5]];
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
    
    self.topBar.alpha = 0;
    self.bottomBar.alpha = 0;
    
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
    prompt.translatesAutoresizingMaskIntoConstraints = NO;
    prompt.text = @"What did we do?";
    [prompt setTextColor:RGB(98,234,239)];
    
    [self.bottomBar addSubview:prompt];
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:prompt attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:10]];
    
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:prompt attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:prompt attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10]];
    
    
    
    self.viewPrompt.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewPrompt setTextColor:[UIColor whiteColor]];
    
    [self.bottomBar addSubview:self.viewPrompt];
    
    self.viewPrompt.numberOfLines = 0;
    self.viewPrompt.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.viewPrompt attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:prompt attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.viewPrompt attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10]];
    
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.viewPrompt attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.viewPrompt attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10]];
}

- (void) loadViews {
    [self loadSpinner];
    [self loadTopBar];
    [self loadBottomBar];
}


- (void) navBack {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate popMyself];
}

- (void) displayAllData {
    [self displayPrompt];
    [self displayPhoto];
}

- (void) displayPhoto {
    [self loadPhotos:^() {
        self.count++;
        if (self.count == 2) {
            [self animateAllData];
        }
    }];
}

- (void) displayPrompt {
    [self loadPrompt:^(NSString * prompt) {
        self.count++;
        [self.viewPrompt setText:prompt];
        //self.viewPrompt.text = @"Hey there this is a test its very good and long and dadff fuck this";
        if (self.count == 2) {
            [self animateAllData];
        }
    }];
}


- (void) animateAllData {
    
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:1.0];
    self.spinner.alpha = 0;
    [UIView commitAnimations];
    
    SinglePhotoViewController *currentSinglePhoto = [self.pageController.viewControllers lastObject];
    [currentSinglePhoto setImage:self.allPhotos[0]];
}

- (void) loadPhotos:(void (^) ()) completion {
    
    // Create the query
    PFQuery *query = [PFQuery queryWithClassName:@"Images"];
    [query whereKey:@"pinId" equalTo:self.pinId];
    [query orderByAscending:@"createdAt"];
    
    // Set to true once we have loaded our first photo
    __block bool loadedFirst = false;

    // Run query to download all relevant photos
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Now know how many photos are returned, set label in UI showing what photo you are
            // on out of how many photos are returned.
            self.currentPicture.text =[NSString stringWithFormat:@"1/%lu", objects.count];
            
            // Iterate over all objects and download corresponding data
            for (PFObject *object in objects) {
                PFFile *imageFile = [object objectForKey:@"imageFile"];
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        
                        // Add data to our container for photos
                        [self.allPhotos addObject:data];
                        
                        // If this is the first photo you have loaded, run completion handler to animate
                        // the screen.
                        if (!loadedFirst) {
                            loadedFirst = true;
                            completion();
                        }
                    }
                    else {
                        NSLog(@"fuck me");
                    }
                }];

            }
        }
    }];

}

- (void) loadPrompt:(void (^) (NSString* prompt)) completion{
    PFQuery *query = [PFQuery queryWithClassName:@"FlurPin"];
    [query whereKey:@"objectId" equalTo:self.pinId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            PFObject* object = objects[0];
            completion(object[@"prompt"]);
        }
        else {
            NSLog(@"fuck");
        }
    }];
}


- (void)replaceTopConstraintOnView:(UIView *)view withAttribute:(NSLayoutAttribute) attribute
                      withConstant:(float)constant
{
    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if ((constraint.firstItem == view) && (constraint.firstAttribute == attribute)) {
            constraint.constant = constant;
        }
    }];
}

- (void)animateConstraints
{
    [UIView animateWithDuration:0.8 animations:^{
        [self.view layoutIfNeeded];
    }];
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
    
    SinglePhotoViewController *childViewController = [[SinglePhotoViewController alloc] initWithSlideUp: [self.allPhotos count] == 0];
    
    childViewController.index = index;
    childViewController.pinId = self.pinId;
    childViewController.viewsToToggle = self.viewsToToggle;

    NSData* data = [self.allPhotos count] == 0 ? [[NSData alloc] init] : self.allPhotos[index];
    if ([data length] != 0)
    [childViewController setImage:data];
    
    
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
