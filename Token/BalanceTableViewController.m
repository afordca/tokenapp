//
//  BalanceTableViewController.m
//  Token
//
//  Created by Dave on 10/28/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "BalanceTableViewController.h"
#import "BalanceTableViewCell.h"
#import "MarketplaceTableViewController.h"

@interface BalanceTableViewController ()

@end

@implementation BalanceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    float sysVersion;
    
    sysVersion = [UIDevice currentDevice].systemVersion.floatValue;
    
    if (sysVersion>=8.0) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    
    [self.navigationItem setTitle:@"BALANCE"];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0]}];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BalanceTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Marketplace"] style:UIBarButtonItemStylePlain target:self action:@selector(presentMarketplaceView)];
    
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentMarketplaceView
{
    MarketplaceTableViewController *marketVC = [[MarketplaceTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *marketNav = [[UINavigationController alloc] initWithRootViewController:marketVC];
    [self.navigationController presentViewController:marketNav animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    BalanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.row==0) {
        //cell.frame = CGRectMake(0, 0, self.view.frame.size.width, cell.frame.size.height);
    }
    
    // cell.separatorInset = UIEdgeInsetsZero;
    // cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 500;
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
