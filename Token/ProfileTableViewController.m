//
//  ProfileTableViewController.m
//  Token
//
//  Created by Dave on 10/28/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "ProfileTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UserObject.h"

@interface ProfileTableViewController ()

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.navigationItem setTitle:[[UserObject currentUser] username]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0]}];
    
    profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 75, 75)];
    profileImageView.layer.borderColor = [UIColor blackColor].CGColor;
    profileImageView.layer.borderWidth = 1.0;
    profileImageView.layer.cornerRadius = 2.0;
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3 - 25, 4, 185, 16)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    nameLabel.text = @"Alex Ford-Carther";
    
    quoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3 - 35, 25, 195, 16)];
    quoteLabel.numberOfLines = 1;
    quoteLabel.textAlignment = NSTextAlignmentCenter;
    quoteLabel.text = @"\"Striving to live life boldly with excellence\"";
    quoteLabel.textColor = [UIColor grayColor];
    quoteLabel.font = [UIFont fontWithName:@"Helvetica" size:9];
    
    jobTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3 - 35, 44, 195, 16)];
    jobTitleLabel.numberOfLines = 1;
    jobTitleLabel.textAlignment = NSTextAlignmentCenter;
    jobTitleLabel.text = @"Founder & Team Leader - TOKEN";
    jobTitleLabel.textColor = [UIColor grayColor];
    jobTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:9];
    
    websiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3 - 35, 64, 195, 16)];
    websiteLabel.numberOfLines = 1;
    websiteLabel.textAlignment = NSTextAlignmentCenter;
    websiteLabel.text = @"www.token.com";
    websiteLabel.textColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0];
    websiteLabel.font = [UIFont fontWithName:@"Helvetica" size:9];
    
    
    /*
    
    // The Color of Big Bold will be black
    UIFont *bigBoldNumber = [UIFont boldSystemFontOfSize:16];
    
    // The color of lil Bold will be gray
    UIFont *lilBoldText = [UIFont boldSystemFontOfSize:12];
    
    // The color that will be added to bigBoldNumber
    UIColor *bigBoldColor = [UIColor blackColor];
    
    // The color that will be added to lilBoldText
    UIColor *lilBoldColor = [UIColor grayColor];
    
    // Attributes for Big Bold Number
    NSDictionary *bigBoldAttr = [NSDictionary dictionaryWithObjectsAndKeys:bigBoldNumber, NSFontAttributeName, bigBoldColor, NSForegroundColorAttributeName, nil];
    
    // Attributes for lil Bold Text
    NSDictionary *lilBoldAttr = [NSDictionary dictionaryWithObjectsAndKeys:lilBoldText, NSFontAttributeName, lilBoldColor, NSForegroundColorAttributeName, nil];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"636 POSTS" attributes:bigBoldAttr];
    
    // Setting the range for Big Bold Number
    const NSRange range = NSMakeRange(3, 7);
    
    // Setting the text of lil Bold
    [attributedString setAttributes:lilBoldAttr range:range];
    
    postsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 72, 150, 16)];
    [postsCountLabel setAttributedText:attributedString];
     */
    
    postsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, 55, 18)];
    postsCountTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 102, 75, 16)];
    
    postsCountLabel.text = @"636";
    postsCountLabel.font = [UIFont boldSystemFontOfSize:18];
    
    postsCountTextLabel.text = @"POSTS";
    postsCountTextLabel.font = [UIFont boldSystemFontOfSize:12];
    postsCountTextLabel.textColor = [UIColor grayColor];
    
    followersCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3 - 15, 100, 55, 18)];
    followersTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3 + 20, 102, 90, 16)];
    
    followersCountLabel.text = @"237";
    followersCountLabel.font = [UIFont boldSystemFontOfSize:18];
    
    followersTextLabel.text = @"FOLLOWERS";
    followersTextLabel.font = [UIFont boldSystemFontOfSize:12];
    followersTextLabel.textColor = [UIColor grayColor];
    
    followingCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + 52.5, 100, 70, 18)];
    followingTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + 96, 102, 80, 16)];
    
    followingCountLabel.text = @"1085";
    followingCountLabel.font = [UIFont boldSystemFontOfSize:18];
    
    followingTextLabel.text = @"FOLLOWING";
    followingTextLabel.font = [UIFont boldSystemFontOfSize:12];
    followingTextLabel.textColor = [UIColor grayColor];
    
    followUserImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 60, 130, 40, 34)];
    [followUserImageView setImage:[UIImage imageNamed:@"FollowUser"]];
    
    balanceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + 30, 130, 40, 34)];
    [balanceImageView setImage:[UIImage imageNamed:@"Balance"]];
    
    balanceLabelText = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + 65, 145, 60, 15)];
    balanceLabelText.font = [UIFont boldSystemFontOfSize:15];
    balanceLabelText.textColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0];
    balanceLabelText.text = @"100,000";
    [profileImageView setImage:[UIImage imageNamed:@"ProfileImages_01"]];
    
    uploadedImageView02 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, self.view.frame.size.width/2 - 2.5, self.view.frame.size.width/2 - 2.5)];
    [uploadedImageView02 setImage:[UIImage imageNamed:@"ProfileImages_02"]];
    
    uploadedImageView03 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + 2.5, 3, self.view.frame.size.width/2 - 2.5, self.view.frame.size.width/2 - 2.5)];
    [uploadedImageView03 setImage:[UIImage imageNamed:@"ProfileImages_03"]];
    
    uploadedImageView04 = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width/2 + 3.5, self.view.frame.size.width/2 - 2.5, self.view.frame.size.width/2 - 2.5)];
    [uploadedImageView04 setImage:[UIImage imageNamed:@"ProfileImages_04"]];
    
    uploadedImageView05 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + 2.5, self.view.frame.size.width/2 + 3.5, self.view.frame.size.width/2 - 2.5, self.view.frame.size.width/2 - 2.5)];
    [uploadedImageView05 setImage:[UIImage imageNamed:@"ProfileImages_05"]];
    
    if (IS_IPHONE_4S_DEVICE || IS_IPHONE_5_DEVICE ) {
        [postsCountLabel setFrame:CGRectMake(5, 100, 55, 18)];
        [postsCountTextLabel setFrame:CGRectMake(40, 102, 75, 16)];
        
        [followersCountLabel setFrame:CGRectMake(self.view.frame.size.width/3 - 20, 100, 55, 18)];
        [followersTextLabel setFrame:CGRectMake(self.view.frame.size.width/3 + 13, 102, 90, 16)];
        
        [followingCountLabel setFrame:CGRectMake(self.view.frame.size.width/2 + 37.5, 100, 70, 18)];
        [followingTextLabel setFrame:CGRectMake(self.view.frame.size.width/2 + 83, 102, 80, 16)];
        
        [balanceImageView setFrame:CGRectMake(self.view.frame.size.width/2 + 10, 130, 40, 34)];
        [balanceLabelText setFrame:CGRectMake(self.view.frame.size.width/2 + 45, 145, 80, 15)];
    }
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.row==0) {
        /*
        for (UIImageView *imgView in cell.subviews) {
            if (imgView==profileImageView) {
                
                return cell;
            }
        }*/
        
        [cell addSubview:profileImageView];
        [cell addSubview:nameLabel];
        [cell addSubview:quoteLabel];
        [cell addSubview:jobTitleLabel];
        [cell addSubview:websiteLabel];
        [cell addSubview:postsCountLabel];
        [cell addSubview:postsCountTextLabel];
        [cell addSubview:followersCountLabel];
        [cell addSubview:followersTextLabel];
        [cell addSubview:followingCountLabel];
        [cell addSubview:followingTextLabel];
        [cell addSubview:followUserImageView];
        [cell addSubview:balanceImageView];
        [cell addSubview:balanceLabelText];
    }
    
    if (indexPath.row==1) {
        [cell addSubview:uploadedImageView02];
        [cell addSubview:uploadedImageView03];
        [cell addSubview:uploadedImageView04];
        [cell addSubview:uploadedImageView05];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        return 385;
    }
    
    return 175;
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
