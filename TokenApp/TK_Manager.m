//
//  TK_Manager.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/26/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "TK_Manager.h"

@implementation TK_Manager

-(User*)loadUser:(NSString *)userID
{
    User *userNew = [User new];

    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:userID];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
    {

        //Username
        userNew.userName = [object objectForKey:@"username"];

        //User Profile Pic
        PFFile *profileImageFile = [object objectForKey:@"profileImage"];
        PFImageView *imageView = [PFImageView new];
        imageView.file = profileImageFile;
        [imageView loadInBackground:^(UIImage *image, NSError *error)
        {
            userNew.profileImage = image;
        }];
    }];

    return userNew;

}




@end
