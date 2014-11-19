//
//  UsersProfileTableViewController.h
//  Token
//
//  Created by Dave on 11/6/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsersProfileTableViewController : UITableViewController
{
    UIImageView *profileImageView;
    UILabel *nameLabel;
    UILabel *quoteLabel;
    UILabel *jobTitleLabel;
    UILabel *websiteLabel;
    UILabel *postsCountLabel;
    UILabel *postsCountTextLabel;
    UILabel *followersCountLabel;
    UIButton *followersTextButton;
    UILabel *followingCountLabel;
    UIButton *followingTextButton;
    UIButton *balanceImageView;
    UILabel *balanceLabelText;
    UIButton *followersButton;
    UIImageView *uploadedImageView02;
    UIImageView *uploadedImageView03;
    UIImageView *uploadedImageView04;
    UIImageView *uploadedImageView05;
    UIImageView *uploadedImageView06;
    UIButton *feedButton;
}

- (void)showFollowersView;
- (void)showFollowingView;
- (void)showUsersFeedView;
- (void)showRequestsView;
- (void)showNotificationsView;
- (void)showProfileEditView;
- (void)showSettingsView;
 

@end
