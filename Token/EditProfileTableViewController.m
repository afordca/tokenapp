//
//  EditProfileTableViewController.m
//  Token
//
//  Created by Dave on 11/7/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "EditProfileTableViewController.h"
#import "ChangePasswordTableViewController.h"

@interface EditProfileTableViewController ()

@end

@implementation EditProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"EDIT PROFILE"];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0]];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModalViewControllerAnimated:)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:@"EDIT PROFILE"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section==0) {
        return 4;
    } else if (section==1) {
        return 4;
    } else if (section==2) {
        return 2;
    } else if (section==3) {
        return 2;
    } else {
        return 2;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view = [UIView new];
        [view setBackgroundColor:[[UIColor colorWithRed:0.97254902 green:0.97254902 blue:0.97254902 alpha:1.0] colorWithAlphaComponent:1.0]];
        
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 20)];
        commentLabel.text = @"PUBLIC INFO";
        [view addSubview:commentLabel];
        return view;
    } else if (section==1) {
        UIView *view = [UIView new];
        [view setBackgroundColor:[[UIColor colorWithRed:0.97254902 green:0.97254902 blue:0.97254902 alpha:1.0] colorWithAlphaComponent:1.0]];
        
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 20)];
        commentLabel.text = @"PRIVATE INFO";
        [view addSubview:commentLabel];
        return view;
    } else if (section==2) {
        UIView *view = [UIView new];
        [view setBackgroundColor:[[UIColor colorWithRed:0.97254902 green:0.97254902 blue:0.97254902 alpha:1.0] colorWithAlphaComponent:1.0]];
        
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 20)];
        commentLabel.text = @"PRIVACY";
        [view addSubview:commentLabel];
        return view;
    } else if (section==3) {
        UIView *view = [UIView new];
        [view setBackgroundColor:[[UIColor colorWithRed:0.97254902 green:0.97254902 blue:0.97254902 alpha:1.0] colorWithAlphaComponent:1.0]];
        
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 20)];
        commentLabel.text = @"SOCIAL ACCOUNTS";
        [view addSubview:commentLabel];
        return view;
    } else {
        return 0;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            [cell.imageView setImage:[UIImage imageNamed:@"SampleData_lebron"]];
            [cell.textLabel setText:@"Profile Photo"];
            cell.separatorInset = UIEdgeInsetsMake(0, - 15, 0, 0);
        }
        
        if (indexPath.row==1) {
            [cell.textLabel setText:@"First Name"];
            
        }
        
        if (indexPath.row==2) {
            [cell.textLabel setText:@"Last Name"];
            
        }
        
        if (indexPath.row==3) {
            [cell.textLabel setText:@"Biography"];
            
        }
        
    }
    
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            [cell.textLabel setText:@"Email"];
        }
        
        if (indexPath.row==1) {
            [cell.textLabel setText:@"Phone"];
            
        }
        
        if (indexPath.row==2) {
            [cell.textLabel setText:@"Gender"];
            
        }
        
        if (indexPath.row==3) {
            [cell.textLabel setText:@"Birthday"];
            
        }
        
    }
    
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            [cell.textLabel setText:@"Make Posts Private"];
            cell.detailTextLabel.numberOfLines = 2;
            [cell.detailTextLabel setText:@"Only those who follow you can see post when private"];
        }
        
        if (indexPath.row==1) {
            [cell.textLabel setText:@"Make Tokens Private"];
            cell.detailTextLabel.numberOfLines = 2;
            [cell.detailTextLabel setText:@"Decide if you want to show others your tokens"];
            
        }

    }
    
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            [cell.textLabel setText:@"Facebook"];
            
        }
        
        if (indexPath.row==1) {
            [cell.textLabel setText:@"Twitter"];
            
        }
        
    }
    
    if (indexPath.section==4) {
        if (indexPath.row==0) {
            [cell.textLabel setText:@"CHANGE PASSWORD"];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        
        if (indexPath.row==1) {
            [cell.textLabel setText:@"SECURITY CODE"];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==4) {
        if (indexPath.row==0) {
            ChangePasswordTableViewController *changePassTVC = [[ChangePasswordTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            changePassTVC.title = @"PASSWORD";
            
            [self.navigationController pushViewController:changePassTVC animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        return 80;
    }
    
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

@end
