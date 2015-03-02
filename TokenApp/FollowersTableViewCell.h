//
//  FollowersTableViewCell.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/24/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol FollowersTableViewCellDelegate <NSObject>;

-(void)followerFollowingPressed:(PFUser*)user row:(NSInteger)row;

@end

@interface FollowersTableViewCell : UITableViewCell
{
    User *user;
}


@property id<FollowersTableViewCellDelegate>delegate;

@property PFUser *userFollower;
@property NSInteger row;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewFollowerProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *labelUsername;
@property NSString *stringStatus;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewFollowStatus;


@end
