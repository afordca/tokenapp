//
//  BalanceTableViewController.m
//  TokenApp
//
//  Created by BASEL FARAG on 1/20/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "BalanceTableViewController.h"


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
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    BalanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

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

@end
