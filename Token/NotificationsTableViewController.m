//
//  NotificationsTableViewController.m
//  Token
//
//  Created by Dave on 11/6/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "NotificationsTableViewController.h"

@interface NotificationsTableViewController ()

@end

@implementation NotificationsTableViewController

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
    [segCon setSelectedSegmentIndex:2];
    fv.backgroundColor = [UIColor colorWithRed:0.97254902 green:0.97254902 blue:0.97254902 alpha:1.0];
    self.tableView.tableHeaderView = fv;
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

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section==0) {
        return 1;
    }
    
    if (section==1) {
        return 4;
    }
    
    if (section==2) {
        return 3;
    }
    
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
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
    
    UIView *view = [UIView new];
    
    if (section==1) {
        UIView *view = [UIView new];
        [view setBackgroundColor:[[UIColor colorWithRed:0.97254902 green:0.97254902 blue:0.97254902 alpha:1.0] colorWithAlphaComponent:1.0]];
        
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 200, 20)];
        commentLabel.text = @"COMMENTS";
        [view addSubview:commentLabel];
        return view;
    }
    
    if (section==2) {
        UIView *view = [UIView new];
        [view setBackgroundColor:[[UIColor colorWithRed:0.97254902 green:0.97254902 blue:0.97254902 alpha:1.0] colorWithAlphaComponent:1.0]];
        
        UILabel *likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 200, 20)];
        likesLabel.text = @"LIKES";
        [view addSubview:likesLabel];
        return view;
    }
    
    return view;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    if (indexPath.section==0 && indexPath.row==0) {
        cell.textLabel.text = @"FOLLOWER REQUESTS";
        cell.detailTextLabel.numberOfLines = 2;
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        cell.detailTextLabel.text = @"You have #0Request follower requests waiting your approval";
    }
    
    if (indexPath.section==1 && indexPath.row==0) {
        [cell.imageView setImage:[UIImage imageNamed:@"SampleData_lebron"]];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        cell.textLabel.text = @"Username commented on your post";
    }
    
    if (indexPath.section==1 && indexPath.row==1) {
        [cell.imageView setImage:[UIImage imageNamed:@"SampleData_lebron"]];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        cell.textLabel.text = @"Username commented on your photo";
    }
    
    if (indexPath.section==1 && indexPath.row==2) {
        [cell.imageView setImage:[UIImage imageNamed:@"SampleData_lebron"]];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        cell.textLabel.text = @"Username commented on your link";
    }
    
    if (indexPath.section==1 && indexPath.row==3) {
        [cell.imageView setImage:[UIImage imageNamed:@"SampleData_lebron"]];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        cell.textLabel.text = @"Username commented on your video";
    }
    
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            [cell.imageView setImage:[UIImage imageNamed:@"Sample_ellen"]];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
            cell.textLabel.text = @"Username liked your photo";
        }
        
        if (indexPath.row==1) {
            [cell.imageView setImage:[UIImage imageNamed:@"Sample_ellen"]];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
            cell.textLabel.text = @"Username liked your link";
        }
        
        if (indexPath.row==2) {
            [cell.imageView setImage:[UIImage imageNamed:@"Sample_ellen"]];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
            cell.textLabel.text = @"Username liked your comment";
        }
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
