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

@interface FLTableViewController ()

@property (nonatomic, retain) NSMutableArray *pinsArray;
@property (nonatomic, strong) UIView* topBar;
@property (nonatomic, strong) UITableView *tableView;



@end

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1]

@implementation FLTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [PFUser logOut];
    
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
    
    
    self.topBar = [[UIView alloc]init];
    [self.topBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.topBar.backgroundColor = RGB(179, 88, 224);
    
    [self.view addSubview:self.topBar];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self.tableView reloadData];
    
    [self.view addSubview: self.tableView];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
  
    // get flurs
    [self getFlurs];
    
}

- (void) getFlurs {
    // get contributed pins
    //[LocalStorage deleteAllFlurs];
    
    [LocalStorage getFlurs:^(NSMutableDictionary *allFlurs) {
        self.pinsArray = allFlurs[@"allFlurs"];
        
        NSLog(@"first: %@", [self.pinsArray[0] prompt]);
        NSLog(@"count: %lu", (unsigned long)self.pinsArray.count);
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
    NSLog(@"pin count: %lu", self.pinsArray.count);
    return self.pinsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                            CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        /*cell.leftUtilityButtons = [self leftButtons];
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;*/
    }
    
    
    //cell.textLabel.text = @"SAF sadf asdf asdf asdf asdf asdf asdf asdf asdf sadf asdf asd";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // set the cell text
    cell.backgroundView = [[UIView alloc] init];
    UILabel *cellText = [[UILabel alloc] init];
    [cellText setTranslatesAutoresizingMaskIntoConstraints:NO];

    cellText.text = @"Hi this is a test of the app and how it handles long prompts";//[[self.pinsArray objectAtIndex:indexPath.row] prompt];
    [cellText setFont:[UIFont fontWithName:@"Avenir-Light" size:19]];
    [cellText setTextColor:RGB(50,50,50) ];
    cellText.numberOfLines = 0;
    cellText.lineBreakMode = NSLineBreakByWordWrapping;

    [cell.backgroundView addSubview:cellText];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:cellText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTop multiplier:1.0 constant:15]];
    
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:cellText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15]];
    
       [cell addConstraint:[NSLayoutConstraint constraintWithItem:cellText attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-15]];
    
    
    UILabel *cellDate = [[UILabel alloc] init];
    //cellDate.text =[[self.pinsArray objectAtIndex:indexPath.row] dateAdded];
    [cellDate setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    cellDate.text = @"Aug 1, 2014";
    [cellDate setTextColor:RGB(179, 88, 224) ];
    [cellDate setFont:[UIFont fontWithName:@"Avenir-Light" size:14]];

    [cell.backgroundView addSubview:cellDate];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:cellDate attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cellText attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:cellDate attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:cellDate attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:cellDate attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-15]];

    
    UILabel *cellContentCount = [[UILabel alloc] init];
    //cellDate.text =[[self.pinsArray objectAtIndex:indexPath.row] dateAdded];
    [cellContentCount setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    cellContentCount.text = @"7 Contributors";
    [cellContentCount setTextColor:RGB(150,150,150) ];
    [cellContentCount setFont:[UIFont fontWithName:@"Avenir-Light" size:14]];

    [cell.backgroundView addSubview:cellContentCount];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:cellContentCount attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cellText attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:cellContentCount attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:cellContentCount attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeLeading multiplier:1.0 constant:120]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:cellContentCount attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10]];


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
