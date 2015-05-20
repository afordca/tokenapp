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
    self.Biography = [userNew objectForKey:@"Biography"];
    self.pfUser = userNew;

    }];

     return self;
}

@end
