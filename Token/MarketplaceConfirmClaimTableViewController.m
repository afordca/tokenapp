//
//  MarketplaceConfirmClaimTableViewController.m
//  Token
//
//  Created by Dave on 11/5/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "MarketplaceConfirmClaimTableViewController.h"
#import "MarketplaceConfirmationTableViewController.h"

@interface MarketplaceConfirmClaimTableViewController ()

@end

@implementation MarketplaceConfirmClaimTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.navigationController.navigationBar.topItem.title = @"";
    [self.navigationItem setTitle:@"CONFIRM ORDER"];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 200)];
    
    UIButton *redeemButton;
    
    if (IS_IPHONE_6_DEVICE) {

        redeemButton = [[UIButton alloc] initWithFrame:CGRectMake(62.5, 38, 250, 34)];
    }
    
    if (IS_IPHONE_5_DEVICE || IS_IPHONE_4S_DEVICE) {

        redeemButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 38, 200, 34)];
    }
    
    [redeemButton setTitle:@"Redeem" forState:UIControlStateNormal];
    redeemButton.layer.cornerRadius = 2.0;
    redeemButton.layer.borderWidth = 1.0;
    redeemButton.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
    [redeemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [redeemButton addTarget:self action:@selector(redeemGiftCard) forControlEvents:UIControlEventTouchDown];
    [footerView addSubview:redeemButton];
    
    self.tableView.tableFooterView = footerView;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)redeemGiftCard
{
    MarketplaceConfirmationTableViewController *marketplaceConfirmTVC = [[MarketplaceConfirmationTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:marketplaceConfirmTVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 50;
    } else {
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section==0) {
        return 6;
    } else {
        return 1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"CONFIRM YOUR ORDER";
            cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        }
        
        if (indexPath.row==1) {
            cell.textLabel.text = @"Name";
        }
        
        if (indexPath.row==2) {
            cell.textLabel.text = @"Address";
        }
        
        if (indexPath.row==3) {
            cell.textLabel.text = @"City";
        }
        
        if (indexPath.row==4) {
            cell.textLabel.text = @"Zip Code";
        }
        
        if (indexPath.row==5) {
            cell.textLabel.text = @"Card Description";
        }
        
    } else {
        UITextField *pinNumber = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 15, cell.frame.size.height)];
        pinNumber.placeholder = @"Enter your pin number";
        [pinNumber setDelegate:self];
        [cell addSubview:pinNumber];
    }
    
    
    return cell;
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
