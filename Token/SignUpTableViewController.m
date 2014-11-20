//
//  SignUpTableViewController.m
//  Token
//
//  Created by Dave on 10/17/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "SignUpTableViewController.h"
#import "SignUpTableViewCell.h"

@interface SignUpTableViewController ()

@end

@implementation SignUpTableViewController
@synthesize firstName, lastName, username, password;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    if (IS_IPHONE_6_DEVICE) {
        self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
        
        firstName = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width, 55)];
        lastName = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width, 55)];
        username = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width, 55)];
        password = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width, 55)];
        
    }
    
    if (IS_IPHONE_5_DEVICE) {
        self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
        
        firstName = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, [UIScreen mainScreen].bounds.size.width, 55)];
        lastName = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, [UIScreen mainScreen].bounds.size.width, 55)];
        username = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, [UIScreen mainScreen].bounds.size.width, 55)];
        password = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, [UIScreen mainScreen].bounds.size.width, 55)];
    }
    
    if (IS_IPHONE_4S_DEVICE) {
        self.tableView.contentInset = UIEdgeInsetsMake(-5, 0, 0, 0);
        
        firstName = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 10, 55)];
        lastName = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 10, 55)];
        username = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 10, 55)];
        password = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 10, 55)];
    }
    
    // Setting delegate of firstName textField
    [firstName setDelegate:self];
    
    // Setting delegate of lastName textField
    [lastName setDelegate:self];
    
    // Setting delegate of username textField
    [username setDelegate:self];
    
    // Setting delegate of password textField
    [password setDelegate:self];
    

    // Creating cancel button to dismiss view when clicked
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModalViewControllerAnimated:)];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0]];
    
    [self.navigationItem setLeftBarButtonItem:cancelItem];
    [self.navigationItem setTitle:@"Sign Up"];
    
    [self.tableView registerClass:[SignUpTableViewCell class] forCellReuseIdentifier:@"SignUpCell"];
    
    [self setFooterViewHeight];
    
    
    [lastName setTextColor:[UIColor blackColor]];
    
    firstName.placeholder = @"First Name";
    lastName.placeholder = @"Last Name";
    username.placeholder = @"Username";
    password.placeholder = @"Password";
    
    NSLog(@"viewDidLoad in SignUpTableViewController called.");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)signUp
{
    // present alert view letting them know that sign up is coming soon
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"Create Account functionality COMING SOON" message:@"This button will be responsible creating a new account in the Token app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert addButtonWithTitle:@"Aight Doe"];
    [alert show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SignUpTableViewCell *signUpCell = (SignUpTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SignUpCell" forIndexPath:indexPath];
    [signUpCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.row==0) {
        if (signUpCell) {
            [signUpCell setLoadedCell:firstName];
            NSLog(@"SignUpCell is invalid.");
            return signUpCell;
        }
        
        //return signUpCell;
    }
    
    if (indexPath.row==1) {
        if (signUpCell) {
            [signUpCell setLoadedCell:lastName];
            return signUpCell;
        }
        
    }
    
    if (indexPath.row==2) {
        if (signUpCell) {
            [signUpCell setLoadedCell:username];
            return signUpCell;
        }
        
    }
    
    if (indexPath.row==3) {
        if (signUpCell) {
            [signUpCell setLoadedCell:password];
            return signUpCell;
        }
    }
    
    // Configure the cell...
    
    return signUpCell;
}

- (void)setFooterViewHeight
{
    if (IS_IPHONE_6_DEVICE) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 250)];
        
        createAccountButton = [[UIButton alloc] initWithFrame:CGRectMake(62.5, 15, 250, 40)];
        [createAccountButton setTitle:@"Create Account" forState:UIControlStateNormal];
        createAccountButton.layer.cornerRadius = 2;
        createAccountButton.layer.borderWidth = 1;
        createAccountButton.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
        createAccountButton.backgroundColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0];
        
        [footerView addSubview:createAccountButton];
        self.tableView.tableFooterView = footerView;
    }
    
    if (IS_IPHONE_5_DEVICE) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        
        createAccountButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 15, 200, 40)];
        [createAccountButton setTitle:@"Create Account" forState:UIControlStateNormal];
        createAccountButton.layer.cornerRadius = 2;
        createAccountButton.layer.borderWidth = 1;
        createAccountButton.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
        createAccountButton.backgroundColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0];
        
        
        [footerView addSubview:createAccountButton];
        self.tableView.tableFooterView = footerView;
    }
    
    if (IS_IPHONE_4S_DEVICE) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        
        createAccountButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 15, 200, 40)];
        [createAccountButton setTitle:@"Create Account" forState:UIControlStateNormal];
        createAccountButton.layer.cornerRadius = 2;
        createAccountButton.layer.borderWidth = 1;
        createAccountButton.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
        createAccountButton.backgroundColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0];

        
        [footerView addSubview:createAccountButton];
        self.tableView.tableFooterView = footerView;
    }
    
    [createAccountButton addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchDown];
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
