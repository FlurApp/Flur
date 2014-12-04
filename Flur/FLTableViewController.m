//
//  FLTableViewController.m
//  Flur
//
//  Created by David Lee on 11/12/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <Parse/Parse.h>
#import "FLTableViewController.h"
#import "LocalStorage.h"
#import "FLConstants.h"

@interface FLTableViewController ()

@property (nonatomic, retain) NSMutableArray *pinsArray;
@property (nonatomic, strong) UIView* topBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *pageTitle;


@end

@implementation FLTableViewController

- (void) didMoveToParentViewController:(UIViewController *)parent {
    [self getFlurs];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[LocalStorage destroyLocalStorage];
    // [LocalStorage createTestData];
    
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
    
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self.tableView reloadData];
    
    [self.view addSubview: self.tableView];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
  

    // get flurs
    [self getFlurs];
    
}

- (void) getFlurs {
    NSLog(@"Getting flurs");
    // get contributed pins
    [LocalStorage getFlurs:^(NSMutableDictionary *allFlurs) {
        self.pinsArray = allFlurs[@"allFlurs"];
        NSLog(@"Size: %lu", self.pinsArray.count);
        
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    }
    
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.cellPrompt.text = [[self.pinsArray objectAtIndex:indexPath.row] prompt];
    
    NSDate *date = [[self.pinsArray objectAtIndex:indexPath.row] dateAdded];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MMM d, YYYY"];
    
    cell.cellDate.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];

    cell.cellContentCount.text = [NSString stringWithFormat:@"%@ contributions", [[[self.pinsArray objectAtIndex:indexPath.row] totalContentCount] stringValue]];
    
    cell.flur = [self.pinsArray objectAtIndex:indexPath.row];

    return cell;
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

- (IBAction)showInfoButtonPress:(id)sender {
}

- (void)reloadData {
    // Reload table data
    //NSLog(@"Function *reloadData* called in TableVC");
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

- (void) showInfo:(NSMutableDictionary*)data {
    Flur *flur = (Flur *)[data objectForKey:@"flur"];
    NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
    
    [newData setObject:flur forKey: @"flur"];
    [newData setObject:flur.creatorUsername forKey:@"creatorUsername"];
    [newData setObject:flur.dateCreated forKey:@"dateCreated"];
    [newData setObject:flur.dateAdded forKey:@"dateAdded"];
    [newData setObject:flur.totalContentCount forKey:@"totalContentCount"];
    [newData setObject:flur.myContentPosition forKey:@"myContentPosition"];
    [newData setObject:flur.objectId forKey:@"pinId"];

    [self.delegate showInfoPage:newData];
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
