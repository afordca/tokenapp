//
//  ForgotPasswordTableViewController.m
//  Token
//
//  Created by Dave on 10/23/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ForgotPasswordTableViewController.h"

@interface ForgotPasswordTableViewController ()

@end

@implementation ForgotPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.navigationItem setTitle:@"Forgot Password"];
    [self setNeedsStatusBarAppearanceUpdate];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModalViewControllerAnimated:)];
    
    [self setHeaderViewHeight];
    
    [self setFooterViewHeight];
    
    [self.navigationItem setLeftBarButtonItem:cancelItem];
    
    email = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 15, 55)];
    email.placeholder = @"Email";
    // setting delegate of email textfield
    [email setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)resetPassword
{
    // present alert view letting them know that password reset is coming soon
    [[[UIAlertView alloc] initWithTitle:@"Password Reset functionality COMING SOON" message:@"This button will be responsible resetting the password of a Token app account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)setHeaderViewHeight
{
    // HeaderView height in iPhone 6
    // value = (44 * 2) + (55 * 2) + 10
    // 667 - value
    if (IS_IPHONE_6_DEVICE) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, 100)];
        headerLabel.text = @"Please input your email address and a temporary password will be sent.";
        headerLabel.numberOfLines = 3;
        
        [headerView addSubview:headerLabel];
        self.tableView.tableHeaderView = headerView;
    }
    
    if (IS_IPHONE_5_DEVICE) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, 100)];
        headerLabel.text = @"Please input your email address and a temporary password will be sent.";
        headerLabel.numberOfLines = 3;
        
        [headerView addSubview:headerLabel];
        self.tableView.tableHeaderView = headerView;
    }
    
    if (IS_IPHONE_4S_DEVICE) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 220, 100)];
        headerLabel.text = @"Please input your email address and a temporary password will be sent.";
        headerLabel.numberOfLines = 3;
        
        [headerView addSubview:headerLabel];
        self.tableView.tableHeaderView = headerView;
    }
}

- (void)setFooterViewHeight
{
    if (IS_IPHONE_6_DEVICE) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 300)];
 
        resetPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(62.5, 15, 250, 40)];
        [resetPasswordButton setTitle:@"Reset" forState:UIControlStateNormal];
        resetPasswordButton.layer.cornerRadius = 2;
        resetPasswordButton.layer.borderWidth = 1;
        resetPasswordButton.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
        resetPasswordButton.backgroundColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0];
        
        [footerView addSubview:resetPasswordButton];
        self.tableView.tableFooterView = footerView;
    }
    
    if (IS_IPHONE_5_DEVICE) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        
        resetPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 15, 200, 40)];
        [resetPasswordButton setTitle:@"Reset" forState:UIControlStateNormal];
        resetPasswordButton.layer.cornerRadius = 2;
        resetPasswordButton.layer.borderWidth = 1;
        resetPasswordButton.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
        resetPasswordButton.backgroundColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0];
        
        [footerView addSubview:resetPasswordButton];
        self.tableView.tableFooterView = footerView;
    }
    
    if (IS_IPHONE_4S_DEVICE) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        
        resetPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 15, 200, 40)];
        [resetPasswordButton setTitle:@"Reset" forState:UIControlStateNormal];
        resetPasswordButton.layer.cornerRadius = 2;
        resetPasswordButton.layer.borderWidth = 1;
        resetPasswordButton.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
        resetPasswordButton.backgroundColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0];
        
        [footerView addSubview:resetPasswordButton];
        self.tableView.tableFooterView = footerView;
    }
    
    [resetPasswordButton addTarget:self action:@selector(resetPassword) forControlEvents:UIControlEventTouchDown];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell addSubview:email];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
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
