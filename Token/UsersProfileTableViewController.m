//
//  UsersProfileTableViewController.m
//  Token
//
//  Created by Dave on 11/6/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "UsersProfileTableViewController.h"
#import "UserObject.h"
#import "FollowersTableViewController.h"
#import "UserActivityTableViewController.h"
#import "FriendRequestsTableViewController.h"
#import "NotificationsTableViewController.h"
#import "EditProfileTableViewController.h"
#import "SettingsTableViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface UsersProfileTableViewController ()

@end

@implementation UsersProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(showProfileEditView)];
    [self.navigationItem setLeftBarButtonItem:leftButtonItem];
    
    [self.navigationItem setTitle:[[UserObject currentUser] username]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0]}];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0]];
    
    feedButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)/2 - 20, 125, 40, 40)];
    [feedButton setBackgroundImage:[UIImage imageNamed:@"Feed"] forState:UIControlStateNormal];
    
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
    
    postsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, 55, 18)];
    postsCountTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 102, 75, 16)];
    
    postsCountLabel.text = @"636";
    postsCountLabel.font = [UIFont boldSystemFontOfSize:18];
    
    postsCountTextLabel.text = @"POSTS";
    postsCountTextLabel.font = [UIFont boldSystemFontOfSize:12];
    postsCountTextLabel.textColor = [UIColor grayColor];
    
    followersCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3 - 15, 100, 55, 18)];
    followersTextButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3 + 20, 102, 90, 16)];
    
    followersCountLabel.text = @"237";
    followersCountLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [followersTextButton setTitle:@"FOLLOWERS" forState:UIControlStateNormal];
    followersTextButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [followersTextButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    followingCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + 52.5, 100, 70, 18)];
    followingTextButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + 96, 102, 80, 16)];
    
    followingCountLabel.text = @"1085";
    followingCountLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [followingTextButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    followingTextButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [followingTextButton setTitle:@"FOLLOWING" forState:UIControlStateNormal];
    
    followersButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 20, 130, 40, 34)];
    [followersButton setBackgroundImage:[UIImage imageNamed:@"Followers"] forState:UIControlStateNormal];
    
    balanceImageView = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.75 - 20, 130, 40, 34)];
    [balanceImageView setBackgroundImage:[UIImage imageNamed:@"Notification"] forState:UIControlStateNormal];
    
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
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings"] style:UIBarButtonItemStylePlain target:self action:@selector(showSettingsView)];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    if (IS_IPHONE_4S_DEVICE || IS_IPHONE_5_DEVICE) {
        [postsCountLabel setFrame:CGRectMake(5, 100, 55, 18)];
        [postsCountTextLabel setFrame:CGRectMake(40, 102, 75, 16)];
        
        [followersCountLabel setFrame:CGRectMake(self.view.frame.size.width/3 - 20, 100, 55, 18)];
        [followersTextButton setFrame:CGRectMake(self.view.frame.size.width/3 + 10, 102, 90, 16)];
        
        [followingCountLabel setFrame:CGRectMake(self.view.frame.size.width/2 + 37.5, 100, 70, 18)];
        [followingTextButton setFrame:CGRectMake(self.view.frame.size.width/2 + 83, 102, 80, 16)];
        
        [balanceImageView setFrame:CGRectMake(self.view.frame.size.width * 0.75 - 20, 130, 40, 34)];
        [balanceLabelText setFrame:CGRectMake(self.view.frame.size.width/2 + 45, 145, 80, 15)];
    }
    
    [followersTextButton addTarget:self action:@selector(showFollowersView) forControlEvents:UIControlEventTouchDown];
    [followingTextButton addTarget:self action:@selector(showFollowingView) forControlEvents:UIControlEventTouchDown];
    [feedButton addTarget:self action:@selector(showUsersFeedView) forControlEvents:UIControlEventTouchDown];
    [followersButton addTarget:self action:@selector(showRequestsView) forControlEvents:UIControlEventTouchDown];
    balanceLabelText = nil;
    [balanceImageView addTarget:self action:@selector(showNotificationsView) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:feedButton];
}

- (void)showSettingsView
{
    SettingsTableViewController *settingsTVC = [[SettingsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController *settingsNav = [[UINavigationController alloc] initWithRootViewController:settingsTVC];
    [self.navigationController presentViewController:settingsNav animated:YES completion:nil];
}

- (void)showProfileEditView
{
    EditProfileTableViewController *editProfileTVC = [[EditProfileTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController *editProfileNav = [[UINavigationController alloc] initWithRootViewController:editProfileTVC];
    [self.navigationController presentViewController:editProfileNav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showNotificationsView
{
    NotificationsTableViewController *notificationsTVC = [[NotificationsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [notificationsTVC setTitle:@"Notifications"];
    [self.navigationController pushViewController:notificationsTVC animated:YES];
}

- (void)showRequestsView
{
    FriendRequestsTableViewController *friendRequestsTVC = [[FriendRequestsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [friendRequestsTVC setTitle:@"REQUESTS"];
    [self.navigationController pushViewController:friendRequestsTVC animated:YES];
}

- (void)showUsersFeedView
{
    UserActivityTableViewController *userFeed = [[UserActivityTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [userFeed setTitle:@"My Activity Feed"];
    [self.navigationController pushViewController:userFeed animated:YES];
}

- (void)showFollowersView
{
    FollowersTableViewController *followersTVC = [[FollowersTableViewController alloc] initWithStyle:UITableViewStylePlain];
    followersTVC.title = @"FOLLOWERS";
    [self.navigationController pushViewController:followersTVC animated:YES];
}

- (void)showFollowingView
{
    FollowersTableViewController *followersTVC = [[FollowersTableViewController alloc] initWithStyle:UITableViewStylePlain];
    followersTVC.title = @"FOLLOWING";
    [self.navigationController pushViewController:followersTVC animated:YES];
}

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
        [cell addSubview:followersTextButton];
        [cell addSubview:followingCountLabel];
        [cell addSubview:followingTextButton];
        [cell addSubview:followersButton];
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
@end
