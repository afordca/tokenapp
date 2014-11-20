//
//  InviteTableViewController.m
//  Token
//
//  Created by Dave on 11/7/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "InviteTableViewController.h"

@interface InviteTableViewController ()

@end

@implementation InviteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"INVITE";
    segCon = [[UISegmentedControl alloc] initWithItems:@[@"INVITE ALL", @"INVITE SELECTED"]];
    float value = [UIScreen mainScreen].bounds.size.width * 0.75;
    segCon.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - value)/2, 8, [UIScreen mainScreen].bounds.size.width * 0.75, 25);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString *string = [[NSString alloc] initWithFormat:@"Contact %ld", indexPath.row + 1];
    [cell.imageView setImage:[UIImage imageNamed:@"SampleData_lebron"]];
    cell.textLabel.text = string;
    
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
