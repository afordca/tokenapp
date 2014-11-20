//
//  LoginTableViewController.m
//  Token
//
//  Created by Dave on 10/23/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "LoginTableViewController.h"
#import "ForgotPasswordTableViewController.h"
#import "MainFeedTableViewController.h"
#import "DiscoverTableViewController.h"
#import "UploadViewController.h"
#import "ProfileTableViewController.h"
#import "BalanceTableViewController.h"
#import "UsersProfileTableViewController.h"
#import "UserObject.h"

@interface LoginTableViewController ()

@end

@implementation LoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.navigationItem setTitle:@"Login"];
    // self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    forgotPasswordTVC = [[ForgotPasswordTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0]];
    
    if (IS_IPHONE_6_DEVICE) {
        self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
        
        username = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 15, 55)];
        username.placeholder = @"Username";
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        password = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 15, 55)];
        password.placeholder = @"Password";
    }
    
    if (IS_IPHONE_5_DEVICE) {
        self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
        
        username = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 15, 55)];
        username.placeholder = @"Username";
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        password = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 15, 55)];
        password.placeholder = @"Password";
    }
    
    if (IS_IPHONE_4S_DEVICE) {
        self.tableView.contentInset = UIEdgeInsetsMake(-5, 0, 0, 0);
        
        username = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width - 5, 55)];
        username.placeholder = @"Username";
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        password = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width - 5, 55)];
        password.placeholder = @"Password";
        
    }
    
    [self setFooterViewHeight];
    [username setDelegate:self];
    [password setDelegate:self];
    
    [forgotPasswordButton addTarget:self action:@selector(presentForgotPasswordTVC) forControlEvents:UIControlEventTouchDown];
    
    // Creating cancel button to dismiss view when clicked
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModalViewControllerAnimated:)];
    
    loginItem = [[UIBarButtonItem alloc] initWithTitle:@"Log In" style:UIBarButtonItemStylePlain target:self action:@selector(login)];
    
    [self.navigationItem setLeftBarButtonItem:cancelItem];
    
    [self.navigationItem setRightBarButtonItem:loginItem];
    
    [loginItem setEnabled:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isLoginAvailable) name:UITextFieldTextDidChangeNotification object:nil];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)login
{
    [username resignFirstResponder];
    [password resignFirstResponder];
    
    // Set curren't user's name
    [[UserObject currentUser] setUsername:username.text];
    
    // View Controller of to hold the main feed
    MainFeedTableViewController *mainFeedTVC = [[MainFeedTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    // Navigation controller the will hold the main feed view controller
    UINavigationController *mainFeedNav = [[UINavigationController alloc] initWithRootViewController:mainFeedTVC];
    
    // Setting the tab bar image of the buttom
    [mainFeedNav.tabBarItem setImage:[UIImage imageNamed:@"Feed"]];
    
    // View Controller of to hold the discover view
    DiscoverTableViewController *discoverTVC = [[DiscoverTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    // Navigation controller the will hold the discover view controller
    UINavigationController *discoverNav = [[UINavigationController alloc] initWithRootViewController:discoverTVC];
    
    // Setting the tab bar image of the buttom
    [discoverNav.tabBarItem setImage:[UIImage imageNamed:@"Discover"]];

    // View Controller of to hold the upload view
    UploadViewController *uploadVC = [[UploadViewController alloc] init];
    
    // Navigation controller the will hold the upload view controller
    UINavigationController *uploadNav = [[UINavigationController alloc] initWithRootViewController:uploadVC];
    
    // Setting the tab bar image of the buttom
    [uploadNav.tabBarItem setImage:[UIImage imageNamed:@"Upload"]];
    
    // View Controller of to hold the profile view
    UsersProfileTableViewController *usersProfileTVC = [[UsersProfileTableViewController alloc] init];
    
    // Navigation controller the will hold the profile view controller
    UINavigationController *profileNav = [[UINavigationController alloc] initWithRootViewController:usersProfileTVC];
    
    // Setting the tab bar image of the buttom
    [profileNav.tabBarItem setImage:[UIImage imageNamed:@"Profile"]];
    
    // View Controller of to hold the balance view
    BalanceTableViewController *balanceTVC = [[BalanceTableViewController alloc] init];
    
    // Navigation controller the will hold the bottom view controller
    UINavigationController *balanceNav = [[UINavigationController alloc] initWithRootViewController:balanceTVC];
    
    // Setting the tab bar image of the buttom
    [balanceNav.tabBarItem setImage:[UIImage imageNamed:@"Balance"]];
    
    UITabBarController *bottomNavigation = [[UITabBarController alloc] init];
    [bottomNavigation setViewControllers:@[mainFeedNav, discoverNav, uploadNav, profileNav, balanceNav]];
    
    // Main Window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window setRootViewController:bottomNavigation];
}

- (void)isLoginAvailable
{
    // Checking to see if login button should be enabled. If it should, enable it.
    if (username.text.length > 0 && password.text.length) {
        [loginItem setEnabled:YES];
    } else {
        [loginItem setEnabled:NO];
    }

}

- (void)viewDidAppear:(BOOL)animated
{
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
                                                          
- (void)presentForgotPasswordTVC
{
    UINavigationController *forgotPasswordNav = [[UINavigationController alloc] initWithRootViewController:forgotPasswordTVC];
    // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self presentViewController:forgotPasswordNav animated:YES completion:^{
        
    }];
}
                                                          
- (void)setFooterViewHeight
{
    // FooterView height in iPhone 6
    // value = (44 * 2) + (55 * 2) + 10
    
    if (IS_IPHONE_6_DEVICE) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
        
        forgotPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(112.5, 5, 150, 18)];
        [forgotPasswordButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
        [forgotPasswordButton setTitleColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0] forState:UIControlStateNormal];
        [footerView addSubview:forgotPasswordButton];
        self.tableView.tableFooterView = footerView;
    }
    
    if (IS_IPHONE_5_DEVICE) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        
        forgotPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(72.5, 5, 175, 18)];
        [forgotPasswordButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
        [forgotPasswordButton setTitleColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0] forState:UIControlStateNormal];
        [footerView addSubview:forgotPasswordButton];
        self.tableView.tableFooterView = footerView;
    }
    
    if (IS_IPHONE_4S_DEVICE) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        
        forgotPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(85, 5, 150, 18)];
        [forgotPasswordButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
        [forgotPasswordButton setTitleColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0] forState:UIControlStateNormal];
        [footerView addSubview:forgotPasswordButton];
        self.tableView.tableFooterView = footerView;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.row==0) {
        [cell addSubview:username];
        return cell;
    }
    
    if (indexPath.row==1) {
        [cell addSubview:password];
        return cell;
    }
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
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
