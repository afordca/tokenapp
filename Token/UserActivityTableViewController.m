//
//  UserActivityTableViewController.m
//  Token
//
//  Created by Dave on 11/6/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "UserActivityTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface UserActivityTableViewController ()

@end

@implementation UserActivityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    // NSLog(@"background color %@", self.navigationController.navigationBar.backgroundColor);
    
    UIView *fv = [UIView new];
    segCon = [[UISegmentedControl alloc] initWithItems:@[[UIImage imageNamed:@"Feed"], [UIImage imageNamed:@"Followers"], [UIImage imageNamed:@"Notification"]]];
    float value = [UIScreen mainScreen].bounds.size.width * 0.75;
    NSLog(@"Value is %f", value);
    NSLog(@"The width of segmented control is %f", [UIScreen mainScreen].bounds.size.width * 0.75);
    segCon.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - value)/2, 8, [UIScreen mainScreen].bounds.size.width * 0.75, 25);
    [segCon setSelectedSegmentIndex:0];
    fv.backgroundColor = [UIColor colorWithRed:0.97254902 green:0.97254902 blue:0.97254902 alpha:1.0];
    self.tableView.tableHeaderView = fv;
    
    // [fv addSubview:segCon];
    //self.tableView.tableHeaderView = fv;
    //self.tableView.tableHeaderView = segmentedControl;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return segCon.frame.size.height + 15;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.backgroundColor = [UIColor blackColor].CGColor;
    UIView *view = [UIView new];
    NSLog(@"UIView's frame %@", NSStringFromCGRect(view.frame));
    
    
    bottomBorder.frame = CGRectMake(0, segCon.frame.size.height + 15, [UIScreen mainScreen].bounds.size.width, 0.5);
    
    // [view setBackgroundColor:[UIColor grayColor]];
    [view setBackgroundColor:[[UIColor colorWithRed:0.97254902 green:0.97254902 blue:0.97254902 alpha:1.0] colorWithAlphaComponent:1.0]];
    [view addSubview:segCon];
    [view.layer addSublayer:bottomBorder];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    int i;
    int j = 0;
    
    if (indexPath.row==0) {
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 240, 18)];
        textLabel.text = @"Username liked 4 photos";
        textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        [cell addSubview:textLabel];
        
        for (i = 0; i < 4; i++) {
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15 + j, 55, 30, 30)];
            [img setImage:[UIImage imageNamed:@"Sample_ellen"]];
            [cell addSubview:img];
            j = j + 40;
        }
    }
    
    if (indexPath.row==1) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 240, 18)];
        textLabel.text = @"Username commented on 3 photos";
        textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        [cell addSubview:textLabel];
        
        for (i = 0; i < 3; i++) {
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15 + j, 55, 30, 30)];
            [img setImage:[UIImage imageNamed:@"Sample_ellen"]];
            [cell addSubview:img];
            j = j + 40;
        }
    }
    
    if (indexPath.row==2) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 240, 18)];
        textLabel.text = @"Username commented on 2 photos";
        textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        [cell addSubview:textLabel];
        
        for (i = 0; i < 2; i++) {
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15 + j, 55, 30, 30)];
            [img setImage:[UIImage imageNamed:@"Sample_ellen"]];
            [cell addSubview:img];
            j = j + 40;
        }
    }
    
    if (indexPath.row==3) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 240, 18)];
        textLabel.text = @"Username shared 6 links";
        textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        [cell addSubview:textLabel];
        
        for (i = 0; i < 6; i++) {
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15 + j, 55, 30, 30)];
            [img setImage:[UIImage imageNamed:@"Sample_ellen"]];
            [cell addSubview:img];
            j = j + 40;
        }
    }
    
    if (indexPath.row==4) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 240, 18)];
        textLabel.text = @"Username liked 5 photos";
        textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        [cell addSubview:textLabel];
        
        for (i = 0; i < 5; i++) {
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15 + j, 55, 30, 30)];
            [img setImage:[UIImage imageNamed:@"Sample_ellen"]];
            [cell addSubview:img];
            j = j + 40;
        }
    }
    
    if (indexPath.row==5) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 240, 18)];
        textLabel.text = @"Username commented on 4 photos";
        textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        [cell addSubview:textLabel];
        
        for (i = 0; i < 4; i++) {
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15 + j, 55, 30, 30)];
            [img setImage:[UIImage imageNamed:@"Sample_ellen"]];
            [cell addSubview:img];
            j = j + 40;
        }
    }
    
    if (indexPath.row==6) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 240, 18)];
        textLabel.text = @"Username liked 4 photos";
        textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        [cell addSubview:textLabel];
        
        for (i = 0; i < 4; i++) {
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15 + j, 55, 30, 30)];
            [img setImage:[UIImage imageNamed:@"Sample_ellen"]];
            [cell addSubview:img];
            j = j + 40;
        }
    }
    
    // cell.textLabel.text = @"David followed users";
    return cell;
}



@end
