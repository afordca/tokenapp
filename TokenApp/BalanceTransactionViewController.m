//
//  BalanceTransactionViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 4/24/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "BalanceTransactionViewController.h"

#import "BalanceActivtyTableViewCell.h"

#import "BalanceActivity.h"

@interface BalanceTransactionViewController ()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation BalanceTransactionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    currentUser = [CurrentUser sharedSingleton];
}

#pragma mark - UITableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return currentUser.arrayOfBalanceActivity.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BalanceActivtyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"balanceActivityCell"];

    BalanceActivity *activity = [currentUser.arrayOfBalanceActivity objectAtIndex:indexPath.row];

    cell.labelDateOfTransaction.text = activity.balanceDate;
    cell.labelDescriptionOfTransaction.text = activity.balanceDescription;
    cell.labelTransactionNumber.text = [activity.balanceTransactionNumber stringValue];
    cell.labelRunningTokenBalance.text = [activity.runningBalance stringValue];

    return cell;
}

@end
