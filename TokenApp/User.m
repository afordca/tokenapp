//
//  User.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/21/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "User.h"

@implementation User

-(id)initWithUser:(PFUser *)userNew
{
    PFFile *profileImageFile = [userNew objectForKey:@"profileImage"];
    PFImageView *imageView = [PFImageView new];
    imageView.file = profileImageFile;
    [imageView loadInBackground:^(UIImage *image, NSError *error) {

    self.profileImage = image;
    self.userName = [userNew objectForKey:@"username"];

    self.arrayOfFollowers = [self loadFollowers:userNew];
    self.arrayOfFollowing = [self loadFollowing:userNew];

    }];

     return self;
}


-(NSMutableArray*)loadFollowers:(PFUser *)user
{
    self.arrayOfFollowers = [NSMutableArray new];
    PFRelation *userFollowerRelation = [user relationForKey:@"Followers" ];
    PFQuery *queryForFollowers = userFollowerRelation.query;
    [queryForFollowers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"%@",[error userInfo]);
        }
        else
        {
            for (PFUser *userFollower in objects)
            {
                [self.arrayOfFollowers addObject:userFollower];
            }
        }
    }];

    return self.arrayOfFollowers;
}

-(NSMutableArray*)loadFollowing:(PFUser *)user
{
    self.arrayOfFollowing = [NSMutableArray new];
    PFRelation *userFollowingRelation = [user relationForKey:@"Following"];
    PFQuery *queryForFollowing = userFollowingRelation.query;
    [queryForFollowing findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"%@",[error userInfo]);
        }
        else
        {
            for (PFUser *userFollower in objects)
            {
                [self.arrayOfFollowing addObject:userFollower];
            }

        }
    }];

    return self.arrayOfFollowing;
}

@end
