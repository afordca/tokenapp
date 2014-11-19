//
//  MarketplaceTableViewController.m
//  Token
//
//  Created by Dave on 11/4/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "MarketplaceTableViewController.h"
#import "MarketplaceTableViewCell.h"
#import "MarketplaceClaimTableViewController.h"

@interface MarketplaceTableViewController ()

@end

@implementation MarketplaceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"MARKETPLACE"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MarketplaceTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"MarketplaceCell"];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0]}];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModalViewControllerAnimated:)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:@"MARKETPLACE"];
}

- (void)redeem25ButtonPressed
{
    MarketplaceClaimTableViewController *marketplaceCTVC = [[MarketplaceClaimTableViewController alloc] initWithStyle:UITableViewStylePlain];
    marketplaceCTVC.title = @"$25 Gift Card";
    [self.navigationController pushViewController:marketplaceCTVC animated:YES];
    
    NSLog(@"redeem $25 pressed!");
}

- (void)redeem50ButtonPressed
{
    MarketplaceClaimTableViewController *marketplaceCTVC = [[MarketplaceClaimTableViewController alloc] initWithStyle:UITableViewStylePlain];
    marketplaceCTVC.title = @"$50 Gift Card";
    [self.navigationController pushViewController:marketplaceCTVC animated:YES];
    
    NSLog(@"redeem $50 pressed!");
}

- (void)redeem100ButtonPressed
{
    MarketplaceClaimTableViewController *marketplaceCTVC = [[MarketplaceClaimTableViewController alloc] initWithStyle:UITableViewStylePlain];
    marketplaceCTVC.title = @"$100 Gift Card";
    [self.navigationController pushViewController:marketplaceCTVC animated:YES];
    
    NSLog(@"redeem $100 pressed!");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    MarketplaceTableViewCell *marketplaceCell = [tableView dequeueReusableCellWithIdentifier:@"MarketplaceCell" forIndexPath:indexPath];
    
    [marketplaceCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section==0) {
        [marketplaceCell.giftCardValue setText:@"$25 Gift Card"];
        [marketplaceCell.cardImageView setImage:[UIImage imageNamed:@"Card_25"]];
        [marketplaceCell.redeemPointsRequired setText:@"2500 Points Needed"];
        [marketplaceCell.redeemButton addTarget:self action:@selector(redeem25ButtonPressed) forControlEvents:UIControlEventTouchDown];
    }
    
    if (indexPath.section==1) {
        [marketplaceCell.giftCardValue setText:@"$50 Gift Card"];
        [marketplaceCell.cardImageView setImage:[UIImage imageNamed:@"Card_50"]];
        [marketplaceCell.redeemPointsRequired setText:@"4750 Points Needed"];
        [marketplaceCell.redeemButton addTarget:self action:@selector(redeem50ButtonPressed) forControlEvents:UIControlEventTouchDown];
    }
    
    if (indexPath.section==2) {
        [marketplaceCell.giftCardValue setText:@"$100 Gift Card"];
        [marketplaceCell.cardImageView setImage:[UIImage imageNamed:@"Card_100"]];
        [marketplaceCell.redeemPointsRequired setText:@"9500 Points Needed"];
        [marketplaceCell.redeemButton addTarget:self action:@selector(redeem100ButtonPressed) forControlEvents:UIControlEventTouchDown];
    }
    
    return marketplaceCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 246;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
