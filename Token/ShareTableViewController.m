//
//  ShareTableViewController.m
//  Token
//
//  Created by Dave on 11/2/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "ShareTableViewController.h"

@interface ShareTableViewController ()

@end

@implementation ShareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    [self.navigationItem setTitle:@"SHARE"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    placeholderText = [[UILabel alloc] initWithFrame:CGRectMake(5, -4, 220, 40)];
    [placeholderText setFont:[UIFont systemFontOfSize:14]];
    [placeholderText setTextColor:[UIColor lightGrayColor]];
    [placeholderText setText:@"Description and hashtags"];
    
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width - 15, 55)];
    searchTextField.delegate = self;
    searchTextField.placeholder = @"Tag People";
    searchTextField.textAlignment = NSTextAlignmentCenter;
    searchTextField.font = [UIFont fontWithName:@"Helvetica" size:13];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        [placeholderText setHidden:NO];
        
    } else {
        [placeholderText setHidden:YES];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_5_DEVICE || IS_IPHONE_4S_DEVICE) {
        if (indexPath.section==0) {
            return 200;
        } else if (indexPath.section==1) {
            return 75;
        } else {
            return 50;
        }
    }
    
    if (indexPath.section==0) {
        return 250;
    } else if (indexPath.section==1) {
        return 75;
    } else {
        return 50;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    if (indexPath.section==0) {
        UITextView *postTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 20, 175)];
        [postTextView becomeFirstResponder];
        [postTextView setDelegate:self];
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [postTextView setDelegate:self];
        [postTextView setFont:[UIFont systemFontOfSize:14]];
        [postTextView setTextColor:[UIColor blackColor]];
        
        [postTextView addSubview:placeholderText];
        [cell addSubview:postTextView];
    }
    
    if (indexPath.section==1) {
        [cell addSubview:searchTextField];
    }
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
