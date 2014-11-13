//
//  FLContributedListViewController.m
//  Flur
//
//  Created by David Lee on 11/12/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//


#import "FLContributedListViewController.h"
#import "LocalStorage.h"
//#import <Parse/Parse.h>

@interface FLContributedListViewController ()

@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) PFQueryTableViewController *pfqTable;

@end

@implementation FLContributedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary* flur = [[NSMutableDictionary alloc]init];
    flur[@"prompt"] = @"HEY";
    flur[@"lat"] = [NSNumber numberWithDouble:12.3];
    flur[@"lng"] = [NSNumber numberWithDouble:12.3];
    flur[@"objectId"] = @"ID";
    flur[@"numContributions"] = [NSNumber numberWithInt:3];
    
    //[LocalStorage addFlur:flur];
    
    //[LocalStorage deleteAllFlurs];
    
    [LocalStorage getFlurs:^(NSMutableDictionary *allFlurs) {
        NSArray* arr = allFlurs[@"allFlurs"];
        NSLog(@"count: %lu", arr.count
              );
    }];
    // Do any additional setup after loading the view.
    
    //
    /*UILabel *tableLabel = [[UILabel alloc] init];
    tableLabel.text = @"Past Flurs";
    [tableLabel setFrame: CGRectMake(0,0,300,50)];*/
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    //[self.tableView setTableHeaderView: tableLabel];
    [self.view addSubview:self.tableView];
    
    
    //self.pfqTable = [[PFQueryTableViewController alloc] initWithClassName:@"FlurPin"];
    //[self.view addSubview:self.pfqTable.view];
    

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
