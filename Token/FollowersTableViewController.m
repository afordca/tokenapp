//
//  FollowersTableViewController.m
//  Token
//
//  Created by Dave on 11/6/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "FollowersTableViewController.h"

@interface FollowersTableViewController ()

@end

@implementation FollowersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, -25, 0, 0)];
    if ([self.navigationItem.title isEqual:@"FOLLOWING"]) {
        [cell.imageView setImage:[UIImage imageNamed:@"SampleData_lebron"]];
    }
    
    if ([self.navigationItem.title isEqual:@"FOLLOWERS"]) {
        [cell.imageView setImage:[UIImage imageNamed:@"Sample_ellen"]];
    }
    
    cell.textLabel.text = @"First Name Last Name";
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    cell.detailTextLabel.text = @"Username";
    return cell;
}

@end
