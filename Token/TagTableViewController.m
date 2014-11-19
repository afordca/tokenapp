//
//  TagTableViewController.m
//  Token
//
//  Created by Dave on 11/2/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "TagTableViewController.h"

@interface TagTableViewController ()

@end

@implementation TagTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.navigationController.navigationBar.topItem.title = @"";
    
    [self.navigationItem setTitle:@"TAG USERS"];
    
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width - 15, 55)];
    searchTextField.delegate = self;
    searchTextField.placeholder = @"SEARCH FOR USERNAME OR #HASHTAG";
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section==0)  {
        [cell addSubview:searchTextField];
        return cell;
    }
    
    if (indexPath.section==1) {
        UILabel *search1 = [[UILabel alloc] initWithFrame:CGRectMake(18, 12, 100, 20)];
        search1.text = @"Result 1";
        [cell addSubview:search1];
    }
    
    if (indexPath.section==2) {
        UILabel *search1 = [[UILabel alloc] initWithFrame:CGRectMake(18, 12, 100, 20)];
        search1.text = @"Result 2";
        [cell addSubview:search1];
    }
    
    if (indexPath.section==3) {
        UILabel *search1 = [[UILabel alloc] initWithFrame:CGRectMake(18, 12, 100, 20)];
        search1.text = @"Result 3";
        [cell addSubview:search1];
    }
    
    if (indexPath.section==4) {
        UILabel *search1 = [[UILabel alloc] initWithFrame:CGRectMake(18, 12, 100, 20)];
        search1.text = @"Result 4";
        [cell addSubview:search1];
    }
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 75;
    } else if (indexPath.section==1) {
        return 50;
    } else {
        return 50;
    }
    
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
