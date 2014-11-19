//
//  ProfileNotificationsTableViewController.m
//  Token
//
//  Created by Dave on 11/7/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "ProfileNotificationsTableViewController.h"

@interface ProfileNotificationsTableViewController ()

@end

@implementation ProfileNotificationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"NOTIFICATIONS"];
    
    self.navigationController.navigationBar.topItem.title = @"";
    [self.tableView registerClass:[UITableViewCell  class] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section==0 || section==1) {
        return 3;
    }
    
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view = [UIView new];
        [view setBackgroundColor:[[UIColor colorWithRed:0.97254902 green:0.97254902 blue:0.97254902 alpha:1.0] colorWithAlphaComponent:1.0]];
        
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 200, 20)];
        commentLabel.text = @"LIKE NOTIFICATIONS";
        [view addSubview:commentLabel];
        return view;
    } else if (section==1) {
        UIView *view = [UIView new];
        [view setBackgroundColor:[[UIColor colorWithRed:0.97254902 green:0.97254902 blue:0.97254902 alpha:1.0] colorWithAlphaComponent:1.0]];
        
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 230, 20)];
        commentLabel.text = @"COMMENT NOTIFICATIONS";
        [view addSubview:commentLabel];
        return view;
    } else if (section==2) {
        
        UIView *view = [UIView new];
        [view setBackgroundColor:[[UIColor colorWithRed:0.97254902 green:0.97254902 blue:0.97254902 alpha:1.0] colorWithAlphaComponent:1.0]];
        
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 230, 20)];
        commentLabel.text = @"CONTACT NOTIFICATIONS";
        [view addSubview:commentLabel];
        return view;
    } else if (section==3) {
        UIView *view = [UIView new];
        [view setBackgroundColor:[[UIColor colorWithRed:0.97254902 green:0.97254902 blue:0.97254902 alpha:1.0] colorWithAlphaComponent:1.0]];
        
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 200, 20)];
        commentLabel.text = @"TOKEN NOTIFICATIONS";
        [view addSubview:commentLabel];
        return view;
    }
    
    else {
        UIView *view = [UIView new];
        [view setBackgroundColor:[[UIColor colorWithRed:0.97254902 green:0.97254902 blue:0.97254902 alpha:1.0] colorWithAlphaComponent:1.0]];
        
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 200, 20)];
        commentLabel.text = @"EMAIL NOTIFICATIONS";
        [view addSubview:commentLabel];
        return view;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.textLabel.text = @"Off";
        }
        
        if (indexPath.row==1) {
            cell.textLabel.text = @"From People I Follow";
        }
        
        if (indexPath.row==2) {
            cell.textLabel.text = @"From Everyone";
        }
    }
    
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            cell.textLabel.text = @"Off";
        }
        
        if (indexPath.row==1) {
            cell.textLabel.text = @"From People I Follow";
        }
        
        if (indexPath.row==2) {
            cell.textLabel.text = @"From Everyone";
        }
    }
    
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            cell.textLabel.text = @"Off";
        }
        
        if (indexPath.row==1) {
            cell.textLabel.text = @"All New Contacts";
        }
        
    }
    
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            cell.textLabel.text = @"Off";
        }
        
        if (indexPath.row==1) {
            cell.textLabel.text = @"When I Earn a Token";
        }
        
    }
    
    if (indexPath.section==4) {
        if (indexPath.row==0) {
            cell.textLabel.text = @"Off";
        }
        
        if (indexPath.row==1) {
            cell.textLabel.text = @"On";
        }
        
    }
    
    return cell;
}

@end
