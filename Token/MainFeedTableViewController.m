//
//  MainFeedTableViewController.m
//  Token
//
//  Created by Dave on 10/28/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "MainFeedTableViewController.h"
#import "PhotoTableViewController.h"
#import "MainFeedTableViewCell.h"
#import "PostTableViewController.h"

@interface MainFeedTableViewController ()

@end

@implementation MainFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerClass:[MainFeedTableViewCell class] forCellReuseIdentifier:@"MainFeedCell"];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0]];
    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [titleView setImage:[UIImage imageNamed:@"MarkNav"]];
    [self.navigationItem setTitleView:titleView];
    
    profileImage01 = [[UIImageView alloc] initWithFrame:CGRectMake(2, 4, 30, 30)];
    [profileImage01 setImage:[UIImage imageNamed:@"ProfileImages_01"]];
    
    nameLabel01 = [[UILabel alloc] initWithFrame:CGRectMake(37, 14, 120, 14)];
    nameLabel01.text = @"Alex FC";
    nameLabel01.font = [UIFont fontWithName:@"Helvetica" size:12];
    nameLabel01.textColor = [UIColor grayColor];
    
    timeElapsedLabel01 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 14, 40, 14)];
    timeElapsedLabel01.text = @"3H";
    timeElapsedLabel01.font = [UIFont fontWithName:@"Helvetica" size:13];
    timeElapsedLabel01.textColor = [UIColor grayColor];
    
    postImageView01 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 37, self.view.frame.size.width, 313)];
    [postImageView01 setImage:[UIImage imageNamed:@"SampleData"]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    postImageView02 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 37, self.view.frame.size.width, 275)];
    [postImageView02 setImage:[UIImage imageNamed:@"SampleData_lebron"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 350;
    }
    
    if (indexPath.section==1) {
        return 312;
    }
    
    if (indexPath.section==2) {
        return 210;
    }
    
    if (indexPath.section==3) {
        return 220;
    }
    
    return 250;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MainFeedCell";
    
    MainFeedTableViewCell *mainFeedCell = (MainFeedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [mainFeedCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    // Checking to see if cell has already been set
    
    if (mainFeedCell==nil) {
        mainFeedCell = [[MainFeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if ([[[mainFeedCell contentView] subviews] count]==8) {
        return mainFeedCell;
    }
    
    if (mainFeedCell!=nil) {
        
        if (indexPath.section==0) {
            [mainFeedCell prepareLoadedCell];
            
            NSLog(@"Inside the first row of the mainFeed");
            [mainFeedCell.profileImage01 setImage:profileImage01.image];
            [mainFeedCell.nameLabel01 setText:nameLabel01.text];
            [mainFeedCell.timeElapsedLabel01 setText:timeElapsedLabel01.text];
            [mainFeedCell.postImageView01 setImage:postImageView01.image];
            return mainFeedCell;
        }
        
        
        if (indexPath.section==1) {
            NSLog(@"Inside the second row of the mainFeed");
            [mainFeedCell prepareLoadedCell];
            [mainFeedCell.profileImage01 setImage:profileImage01.image];
            [mainFeedCell.nameLabel01 setText:nameLabel01.text];
            [mainFeedCell.timeElapsedLabel01 setText:@"4H"];
            [mainFeedCell.postImageView01 setFrame:postImageView02.frame];
            [mainFeedCell.postImageView01 setImage:postImageView02.image];
            
            return mainFeedCell;
        }
        
        if (indexPath.section==2) {
            [mainFeedCell prepareLoadedCell];
            [mainFeedCell.profileImage01 setImage:profileImage01.image];
            [mainFeedCell.nameLabel01 setText:nameLabel01.text];
            [mainFeedCell.timeElapsedLabel01 setText:@"7H"];
            [mainFeedCell.randomText setText:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris sollicitudin, nibh eu pretium accumsan, ligula elit molestie purus, eget imperdiet enim mauris sit amet odio"];
            return mainFeedCell;
        }
        
        if (indexPath.section==3) {
            [mainFeedCell prepareLoadedCell];
            [mainFeedCell.profileImage01 setImage:[UIImage imageNamed:@"ProfileDefault"]];
            [mainFeedCell.timeElapsedLabel01 setText:@"3D"];
            [mainFeedCell.linkImageView setImage:[UIImage imageNamed:@"Sample_ellen"]];
            [mainFeedCell.linkTitle setText:@"Ellen's Oscar Selfie: Worth $1 Billion?"];
            [mainFeedCell.linkSumText setText:@"Apr 9, 2014 - Can a single selfie really be worth between $800 million and $1 billion?"];
            return mainFeedCell;
        }
    }
    
                return mainFeedCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        PhotoTableViewController *photoVC = [[PhotoTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [photoVC setPostedPhoto:postImageView01.image];
        [photoVC setNavTitle:@"PHOTO"];
        
        [self.navigationController pushViewController:photoVC animated:YES];
    }
    
    if (indexPath.section==1) {
        PhotoTableViewController *photoVC = [[PhotoTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [photoVC setPostedPhoto:postImageView02.image];
        [photoVC setNavTitle:@"VIDEO"];
        
        [self.navigationController pushViewController:photoVC animated:YES];
    }
    
    if (indexPath.section==2) {
        PostTableViewController *postVC = [[PostTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [postVC setNavTitle:@"POST"];
        [self.navigationController pushViewController:postVC animated:YES];
    }
    
    if (indexPath.section==3) {
        PostTableViewController *postVC = [[PostTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [postVC setNavTitle:@"LINK"];
        [self.navigationController pushViewController:postVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0) {
        return 0;
    }
    
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
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
