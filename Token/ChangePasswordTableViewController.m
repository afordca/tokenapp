//
//  ChangePasswordTableViewController.m
//  Token
//
//  Created by Dave on 11/7/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "ChangePasswordTableViewController.h"

@interface ChangePasswordTableViewController ()

@end

@implementation ChangePasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    [self.navigationItem setTitle:@"PASSWORD"];
    
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    v.backgroundColor = [UIColor colorWithRed:0.97254902 green:0.97254902 blue:0.97254902 alpha:1.0];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setRightBarButtonItem:rightItem];
    // self.tableView.tableFooterView = v;
    
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

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 50;
    } else if (section==1) {
        return 40;
    } else {
        return 30;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    if (indexPath.section==0) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 15, 50)];
        textField.placeholder = @"OLD PASSWORD";
        [cell addSubview:textField];
    }
    
    if (indexPath.section==1) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 15, 50)];
        textField.placeholder = @"NEW PASSWORD";
        [cell addSubview:textField];
    }
    
    if (indexPath.section==2) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 15, 50)];
        textField.placeholder = @"CONFIRM NEW PASSWORD";
        [cell addSubview:textField];
    }
    
    return cell;
}

@end
