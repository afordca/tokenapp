//
//  User.m
//  
//
//  Created by BASEL FARAG on 2/3/15.
//
//

#import "User.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@implementation User
{
    User *anotherSingle;
}


@synthesize profileImage;
@synthesize userName;
@synthesize arrayOfFollowers;
@synthesize arrayOfUserActivity;
@synthesize arrayOfFollowing;
@synthesize arrayOfPhotos;
@synthesize user;


+ (User *)sharedSingleton
{
    static User *single = nil;
    {
        if ( !single)
        {
            // allocate the shared instance, because it hasn't been done yet
            single = [[User alloc] init];
        }

        return single;
    }
}

-(void)loadArrayOfFollowers
{
    user = [PFUser currentUser];
    self.arrayOfFollowers = [NSMutableArray new];
 //   Loading Array of Followers and setting it in singleton class USER
    for (PFObject *object in arrayOfUserActivity)
    {

        PFUser *toUser = [object objectForKey:@"toUser"];
        NSString *stringType = [object objectForKey:@"type"];
        if ([toUser.objectId isEqual:user.objectId] && [stringType isEqual:@"followed"])
        {
            PFUser *follower = [object objectForKey:@"fromUser"];
            [arrayOfFollowers addObject:follower];
        }
    }
}

-(void)loadPhotos
{
    user = [PFUser currentUser];
    self.arrayOfPhotos = [NSMutableArray new];
    //Loading Array of photos and setting it in singleton class USER
    PFQuery *queryForUserContent = [PFQuery queryWithClassName:@"Photo"];
    [queryForUserContent whereKey:@"userName" equalTo:user.objectId];
    [queryForUserContent findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"%@",[error userInfo]);
        }
        else
        {
            for (PFObject *photo in objects)
            {
                PFFile *parseFileWithImage = [photo objectForKey:@"image"];
                NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
                NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
                [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                    if (connectionError)
                    {
                        NSLog(@"%@",[connectionError userInfo]);
                    }
                    else
                    {
                        [self.arrayOfPhotos addObject:[UIImage imageWithData:data]];
                    }
                }];
            }
        }
    }];
}

-(void)setUserProfile
{
        user = [PFUser currentUser];
        //Loading Profile Image
        PFFile *profileImageFile = [user objectForKey:@"profileImage"];
        PFImageView *imageView = [PFImageView new];
        imageView.file = profileImageFile;
        [imageView loadInBackground:^(UIImage *image, NSError *error) {
    
            //Setting image to singleton class USER
            self.profileImage = image;
    
            //Settring Username to singleton class USER
            if ([user objectForKey:@"username"])
            {
                self.userName = [user objectForKey:@"username"];
            } else
            {
                self.userName = user.username;
            }
    
        }];
}

-(void)loadActivityToCurrentUser
{
        user = [PFUser currentUser];
        self.arrayOfUserActivity = [NSMutableArray new];
        PFQuery *queryForActivity = [PFQuery queryWithClassName:@"Activity"];
        [queryForActivity whereKey:@"toUser" equalTo:user];
        [queryForActivity includeKey:@"fromUser"];
        [queryForActivity includeKey: @"toUser"];
        [queryForActivity includeKey:@"photo"];
        [queryForActivity findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"%@",[error userInfo]);
            }
            else{
    
                for (PFObject *activity in objects)
                {
                    [self.arrayOfUserActivity addObject:activity];
                }
            }
             [self loadArrayOfFollowers];
        }];
}



@end