//
//  ContactsTableViewController.m
//  Token
//
//  Created by Dave on 11/7/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "ContactsTableViewController.h"

@interface ContactsTableViewController ()

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.navigationController.navigationBar.topItem.title = @"";
    segCon = [[UISegmentedControl alloc] initWithItems:@[@"FOLLOW ALL"]];
    float value = [UIScreen mainScreen].bounds.size.width * 0.75;
    segCon.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - value)/2, 8, [UIScreen mainScreen].bounds.size.width * 0.75, 25);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:@"Contacts"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    [cell.imageView setImage:[UIImage imageNamed:@"Sample_ellen"]];
    cell.textLabel.text = @"Username";
    cell.detailTextLabel.text = @"First Name Last Name";
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    [view setBackgroundColor:[[UIColor colorWithRed:0.97254902 green:0.97254902 blue:0.97254902 alpha:1.0] colorWithAlphaComponent:1.0]];
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 20)];
    commentLabel.text = @"PRIVATE INFO";
    [view addSubview:segCon];
    return view;
}

@end
