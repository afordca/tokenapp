//
//  BalanceActivityTableViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 4/22/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "BalanceActivityTableViewController.h"
#import "BalanceActivtyTableViewCell.h"

#import "BalanceActivity.h"

@interface BalanceActivityTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation BalanceActivityTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Accessing User Singleton
    currentUser = [CurrentUser sharedSingleton];

    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height-self.tableView.frame.size.height) animated:YES];


}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return currentUser.arrayOfBalanceActivity.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BalanceActivtyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BalanceActivityCell"];

    BalanceActivity *activity = [currentUser.arrayOfBalanceActivity objectAtIndex:indexPath.row];

    cell.labelDateOfTransaction.text = activity.balanceDate;
    cell.labelDescriptionOfTransaction.text = activity.balanceDescription;
    cell.labelTransactionNumber.text = [activity.balanceTransactionNumber stringValue];
    cell.labelRunningTokenBalance.text = [activity.runningBalance stringValue];

    return cell;


}

@end
