//
//  FollowersTableViewCell.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/24/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FollowersTableViewCellDelegate <NSObject>;

-(void)followerFollowingPressed:(NSString*)status;

@end

@interface FollowersTableViewCell : UITableViewCell


@property id<FollowersTableViewCellDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewFollowerProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *labelUsername;
@property (strong, nonatomic) IBOutlet UIButton *buttonFollowerFollowing;
@property NSString *stringStatus;

@end
