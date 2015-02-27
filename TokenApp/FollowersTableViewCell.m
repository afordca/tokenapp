
//
//  FollowersTableViewCell.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/24/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "FollowersTableViewCell.h"

@implementation FollowersTableViewCell

- (IBAction)buttonPressFollowFollowing:(id)sender
{
    if ([self.buttonFollowerFollowing.imageView.image isEqual:[UIImage imageNamed:@"Following"]])
    {
        self.stringStatus = @"Following";
    }
    else
    {
       self.stringStatus = @"Follower";
    }


    [self.delegate followerFollowingPressed:self.stringStatus];
}

@end
