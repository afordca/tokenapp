//
//  SettingsTableViewController.m
//  Token
//
//  Created by Dave on 11/7/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "ContactsTableViewController.h"
#import "InviteTableViewController.h"
#import "ProfileNotificationsTableViewController.h"
#import "DisclosuresTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"SETTINGS"];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0]];
        
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModalViewControllerAnimated:)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:@"SETTINGS"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {
        return 4;
    } else if (section==1) {
        return 2;
    } else if (section==2) {
        return 2;
    } else if (section==3) {
        return 6;
    } else {
        return 2;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view = [UIView new];
        [view setBackgroundColor:[[UIColor colorWithRed:0.97254902 green:0.97254902 blue:0.97254902 alpha:1.0] colorWithAlphaComponent:1.0]];
        
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 20)];
        commentLabel.text = @"PEOPLE TO FOLLOW";
        [view addSubview:commentLabel];
        return view;
    } else if (section==1) {
        UIView *view = [UIView new];
        [view setBackgroundColor:[[UIColor colorWithRed:0.97254902 green:0.97254902 blue:0.97254902 alpha:1.0] colorWithAlphaComponent:1.0]];
        
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 20)];
        commentLabel.text = @"SHARE SETTINGS";
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
        commentLabel.text = @"PUSH NOTIFICATIONS";
        [view addSubview:commentLabel];
        return view;
    }
    
        else {
                UIView *view = [UIView new];
                [view setBackgroundColor:[[UIColor colorWithRed:0.97254902 green:0.97254902 blue:0.97254902 alpha:1.0] colorWithAlphaComponent:1.0]];
                
                UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 20)];
                commentLabel.text = @"PUBLIC INFO";
                // [view addSubview:commentLabel];
                return view;
            }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            ContactsTableViewController *contactsTVC = [[ContactsTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:contactsTVC animated:YES];
        }
        
        if (indexPath.row==3) {
            InviteTableViewController *inviteTVC = [[InviteTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:inviteTVC animated:YES];
        }
    }
    
    if (indexPath.section==2) {
        ProfileNotificationsTableViewController *pNotifTVC = [[ProfileNotificationsTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:pNotifTVC animated:YES];
    }
    
    if (indexPath.section==3) {
        DisclosuresTableViewController *disclosuresTVC = [[DisclosuresTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        
        if (indexPath.row==0) {
            disclosuresTVC.title = @"PRIVACY POLICY";
            [self.navigationController pushViewController:disclosuresTVC animated:YES];
        }
        
        if (indexPath.row==1) {
            disclosuresTVC.title = @"TERMS OF SERVICE";
            [self.navigationController pushViewController:disclosuresTVC animated:YES];
        }
        
        if (indexPath.row==2) {
            disclosuresTVC.title = @"HELP CENTER";
            [self.navigationController pushViewController:disclosuresTVC animated:YES];
        }
        
        if (indexPath.row==3) {
            UIActionSheet *logOutSheet = [[UIActionSheet alloc] initWithTitle:@"Report A Problem" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Spam or Abuse", @"Something isn't working", @"General Feedback", @"I didn't receive my gift card", @"Cancel", nil];
            [logOutSheet showInView:self.view];
        }
        
        if (indexPath.row==4) {
            UIActionSheet *logOutSheet = [[UIActionSheet alloc] initWithTitle:@"Sure you want to clear search history?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Clear" otherButtonTitles: @"Cancel", nil];
            [logOutSheet showInView:self.view];
        }
        
        if (indexPath.row==5) {
            UIActionSheet *logOutSheet = [[UIActionSheet alloc] initWithTitle:@"Sure you want to log out?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Log Out" otherButtonTitles: @"Cancel", nil];
            [logOutSheet showInView:self.view];
        }
        
     }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            cell.textLabel.text = @"From Contacts";
        }
        
        if (indexPath.row==1) {
            cell.textLabel.text = @"From Facebook";
        }
        
        if (indexPath.row==2) {
            cell.textLabel.text = @"From Twitter";
        }
        
        if (indexPath.row==3) {
            cell.textLabel.text = @"Invite your contacts";
        }
    }
    
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            cell.textLabel.text = @"Facebook";
        }
        
        if (indexPath.row==1) {
            cell.textLabel.text = @"Twitter";
        }
    }
    
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            cell.textLabel.text = @"Turn on Push Notifications";
        }
        
        if (indexPath.row==1) {
            cell.textLabel.text = @"Notification Setting";
        }
    }
    
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            cell.textLabel.text = @"Privacy Policy";
        }
        
        if (indexPath.row==1) {
            cell.textLabel.text = @"Terms Of Service";
        }
        
        if (indexPath.row==2) {
            cell.textLabel.text = @"Help Center";
        }
        
        if (indexPath.row==3) {
            cell.textLabel.text = @"Report a Problem";
        }
        
        if (indexPath.row==4) {
            cell.textLabel.text = @"Clear Search Field";
        }
        
        if (indexPath.row==5) {
            cell.textLabel.text = @"Log Out";
        }
    }
    
    return cell;
}


@end
