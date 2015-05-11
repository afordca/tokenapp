//
//  FollowersTableViewCell.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/24/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentUser.h"
#import "NimbusKitAttributedLabel.h"

#import "User.h"

@protocol FollowersTableViewCellDelegate <NSObject>;

//-(void)followerFollowingPressed:(PFUser*)user row:(NSInteger)row;

-(void)followerFollowingPressed:(User*)user row:(NSInteger)row;

@end

@interface FollowersTableViewCell : UITableViewCell
{
    CurrentUser *user;
}


@property id<FollowersTableViewCellDelegate>delegate;

//@property PFUser *userFollower;
@property User *userFollower;
@property NSInteger row;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewFollowerProfilePic;

@property NSString *stringStatus;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewFollowStatus;

@property (strong, nonatomic) IBOutlet NIAttributedLabel *labelUsername;


@end
