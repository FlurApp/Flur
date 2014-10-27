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


@interface PhotoViewController ()

@property   (strong, nonatomic) UIImageView * spinner;
@property   (strong, nonatomic) UILabel * viewPrompt;
@property   (strong, nonatomic) UIView * topBar;
@property   (strong, nonatomic) UIView * bottomBar;
@property   (strong, nonatomic) UILabel* currentPicture;


@property   (strong, nonatomic) NSMutableArray *viewsToToggle;





@property (strong, nonatomic) NSMutableArray *allPhotos;
@property (nonatomic) int count;
@property (nonatomic) bool topBarVisible;


@end

@implementation PhotoViewController

- (instancetype) initWithPin: (NSString*) pinId {
    self = [super init];
    
    if (self) {
        self.pinId = pinId;
        self.topBarVisible = false;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.allPhotos = [[NSMutableArray alloc] init];
    self.viewPrompt = [[UILabel alloc] init];
    self.currentPicture = [[UILabel alloc] init];

    self.spinner = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.topBarVisible = true;
    self.viewsToToggle = [[NSMutableArray alloc] init];

    self.pinId = @"c8kzGmjHaU";
    self.count = 0;

    
    // SET UP CONTROLLER
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
    
    [self loadViews];
    initialViewController.viewsToToggle = self.viewsToToggle;
    [self displayAllData];

 

        // Do any additional setup after loading the view.
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

- (void) loadViews {
    [self loadSpinner];
    
    
    self.topBar = [[UIView alloc] initWithFrame:CGRectZero];
    self.topBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.topBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topBar];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:50]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
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
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.currentPicture attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:20]];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.currentPicture attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:5]];


    
    self.bottomBar = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomBar.translatesAutoresizingMaskIntoConstraints = NO;
    //self.bottomBar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bottomBar];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-80]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];

    
    [self.viewsToToggle addObject:self.topBar];
    [self.viewsToToggle addObject:self.bottomBar];
    
    self.topBar.alpha = 0;
    self.bottomBar.alpha = 0;
    
    UIBlurEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    UIVisualEffectView *blurEffectView;
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.translatesAutoresizingMaskIntoConstraints = NO;

    
    [self.bottomBar addSubview:blurEffectView];
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];

    self.viewPrompt = [[UILabel alloc] init];
    self.viewPrompt.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewPrompt setTextColor:[UIColor whiteColor]];
    
    //[self.viewPrompt setTextAlignment:UITextAlignmentCenter];
    
    [self.bottomBar addSubview:self.viewPrompt];
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.viewPrompt attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:10]];
    
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.viewPrompt attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.bottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.viewPrompt attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    /*[[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.viewPrompt attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];*/
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
        if (self.count == 2) {
            [self animateAllData];
        }
    }];
}


- (void) animateAllData {
    [self replaceTopConstraintOnView:self.viewPrompt withAttribute:NSLayoutAttributeTop withConstant:30];
    [self animateConstraints];
    
    
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:1.0];
    self.spinner.alpha = 0;
    [UIView commitAnimations];
    
    SinglePhotoViewController *currentSinglePhoto = [self.pageController.viewControllers lastObject];
    [currentSinglePhoto setImage:self.allPhotos[0]];
}

- (void) loadPhotos:(void (^) ()) completion {
    // GET IMAGE
    __block bool loadedFirst = false;
    PFQuery *query = [PFQuery queryWithClassName:@"Images"];
    [query whereKey:@"pinId" equalTo:self.pinId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.currentPicture.text =[NSString stringWithFormat:@"1/%lu", objects.count];

            for (PFObject *object in objects) {
                PFFile *imageFile = [object objectForKey:@"imageFile"];
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        [self.allPhotos addObject:data];
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
    NSData* data = [self.allPhotos count] == 0 ? [[NSData alloc] init] : self.allPhotos[index];
    SinglePhotoViewController *childViewController = [[SinglePhotoViewController alloc] initWithSlideUp: [self.allPhotos count] == 0];
    childViewController.index = index;
    childViewController.pinId = self.pinId;
    childViewController.viewsToToggle = self.viewsToToggle;

    
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
   // NSLog(@"current index %lu", ((SinglePhotoViewController*)(previousViewControllers[0])).index);
    SinglePhotoViewController* a= [self.pageController.viewControllers lastObject];
    NSLog(@"index %lu", a.index);
    
    self.currentPicture.text = [NSString stringWithFormat:@"%lu/%lu", (a.index+1), (unsigned long)self.allPhotos.count];
}


@end
