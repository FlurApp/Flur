//
//  FLTableViewController.m
//  Flur
//
//  Created by David Lee on 11/12/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import <Parse/Parse.h>
#import "FLTableViewController.h"
#import "LocalStorage.h"
#import <SWTableViewCell/SWTableViewCell.h>
#import "FLCustomCellTableViewCell.h"
#import "FLConstants.h"

@interface FLTableViewController ()

@property (nonatomic, retain) NSMutableArray *pinsArray;
@property (nonatomic, strong) UIView* topBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) NSArray *months;


@end

@implementation FLTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //[LocalStorage destroyLocalStorage];
    // [LocalStorage createTestData];
    
    self.months = [[NSArray alloc] initWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
    //[PFUser logOut];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /*[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    //[self.tableView setBackgroundColor:RGBA(186,108,224,.7)];

    self.pinsArray = [[NSMutableArray alloc] init];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = RGB(186,108,224);
    //self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getFlurs)
                  forControlEvents:UIControlEventValueChanged];*/
    
    
   // self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    
    

    UIView *waste = [[UIView alloc]init];
     [waste setTranslatesAutoresizingMaskIntoConstraints:NO];
     [self.view addSubview:waste];
     
     [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:waste attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
     
     [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:waste attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:80]];
     
     [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:waste attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
     
     [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:waste attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
     
     [self.view setNeedsLayout];
     [self.view layoutIfNeeded];

    
    
    
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self.tableView reloadData];
    
    [self.view addSubview: self.tableView];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:waste attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
  
    
    
    
    self.topBar = [[UIView alloc]init];
    [self.topBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.topBar.backgroundColor = [UIColor redColor];

    [self.view addSubview:self.topBar];
    
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:80]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.topBar.frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[RGBA(186,108,224, .98) CGColor], (id)[RGBA(179, 88, 224, .98) CGColor], nil];
    
//    [gradient setShadowOffset:CGSizeMake(1, 1)];
//    [gradient setShadowColor:[[UIColor blackColor] CGColor]];
//    [gradient setShadowOpacity:0.5];
    
    [self.topBar.layer insertSublayer:gradient atIndex:0];
    
//    CAGradientLayer *shadow = [CAGradientLayer layer];
//    shadow.frame = CGRectMake(0, self.topBar.frame.origin.y + self.topBar.frame.size.height, self.view.frame.size.width, 3);
//    shadow.colors = [NSArray arrayWithObjects:(id)[RGBA(100,100,100,.9) CGColor], (id)[RGBA(255,255,255,0) CGColor], nil];
//    [self.topBar.layer insertSublayer:shadow atIndex:1];
    
    self.backButton = [[UIButton alloc] init];
    [self.backButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.backButton addTarget:self action:@selector(returnToMap:) forControlEvents:UIControlEventTouchDown];
    [self.backButton setImage:[UIImage imageNamed:@"leaveCamera.png"] forState:UIControlStateNormal];
    
    [self.topBar addSubview:self.backButton];
    
    [self.topBar addConstraint:[NSLayoutConstraint constraintWithItem:_backButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:25]];
    
    [self.topBar addConstraint:[NSLayoutConstraint constraintWithItem:_backButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    
    [self.topBar addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0
                                                             constant:40.0]];
    [self.topBar addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0
                                                             constant:40.0]];
    

    
    
    
    // get flurs
    [self getFlurs];
    
}

- (void) getFlurs {
    // get contributed pins
    //[LocalStorage deleteAllFlurs];
    
    [LocalStorage getFlurs:^(NSMutableDictionary *allFlurs) {
        self.pinsArray = allFlurs[@"allFlurs"];
        
       // NSLog(@"first: %@", [self.pinsArray[0] prompt]);
        //NSLog(@"second: %@", [self.pinsArray[1] prompt]);

        [self reloadData];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.pinsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    FLCustomCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                            CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[FLCustomCellTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
        /*cell.leftUtilityButtons = [self leftButtons];
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;*/
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.cellPrompt.text = [[self.pinsArray objectAtIndex:indexPath.row] prompt];
    
    NSDate *date = [[self.pinsArray objectAtIndex:indexPath.row] dateAdded];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSInteger curMonth = [[dateFormatter stringFromDate:date] integerValue] - 1;
    
    [dateFormatter setDateFormat:@"dd"];
    NSString *curDay = [NSString stringWithFormat:@"%ld", [[dateFormatter stringFromDate:date] integerValue]];
    
    [dateFormatter setDateFormat:@"YYYY"];
    NSString *curYear = [dateFormatter stringFromDate:date];

    
    cell.cellDate.text = [NSString stringWithFormat:@"%@ %@, %@", self.months[curMonth], curDay, curYear];
    cell.cellContentCount.text = @"7 Contributors";
    
    cell.flur = [self.pinsArray objectAtIndex:indexPath.row];

    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                icon:[UIImage imageNamed:@"check.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0]
                                                icon:[UIImage imageNamed:@"clock.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
                                                icon:[UIImage imageNamed:@"cross.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
                                                icon:[UIImage imageNamed:@"list.png"]];
    
    return leftUtilityButtons;
}


/*- (NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait;
   
}*/

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

    //newCell.backgroundColor = [UIColor whiteColor];

}

- (void) tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.backgroundView.backgroundColor = RGB(230,230,230);
}

- (void) tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.backgroundView.backgroundColor = RGB(255,255,255);
}

/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        NSLog(@"Unhandled editing style! %d", editingStyle);
    }
}*/

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (IBAction)returnToMap:(id)sender {
    [FLCustomCellTableViewCell closeCurrentlyOpenCell];
    [_delegate movePanelToOriginalPosition];
}

- (void)reloadData {
    // Reload table data
    [self.tableView reloadData];
    
    // End the refreshing
    /*if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }*/
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
