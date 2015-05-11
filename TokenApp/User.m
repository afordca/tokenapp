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
    self.objectID = userNew.objectId;

    self.arrayOfFollowers = [self loadFollowers:userNew.objectId];
    self.arrayOfFollowing = [self loadFollowing:userNew.objectId];

    }];

     return self;
}


-(NSMutableArray*)loadFollowers:(NSString *)userID
{
    self.arrayOfFollowers = [NSMutableArray new];
    [PFCloud callFunctionInBackground:@"Followers" withParameters:@{@"objectId": userID} block:^(NSArray *result, NSError *error)
     {
         if (error)
         {
             NSLog(@"%@", [error userInfo]);
         }
         else
         {
             for (PFUser *userFollower in result)
             {

                 [self.arrayOfFollowers addObject:userFollower];
             }
         }

     }];

    return self.arrayOfFollowers;
}

-(NSMutableArray*)loadFollowing:(NSString *)userID
{
    self.arrayOfFollowing = [NSMutableArray new];

    [PFCloud callFunctionInBackground:@"Following" withParameters:@{@"objectId": userID} block:^(NSArray *result, NSError *error)
     {
         if (error)
         {
             NSLog(@"%@", [error userInfo]);
         }
         else
         {
             for (PFUser *userFollower in result)
             {
                 [self.arrayOfFollowing addObject:userFollower];
             }

         }

     }];

    return self.arrayOfFollowing;
}

@end
