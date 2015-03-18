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
#import "Notifications.h"

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

        //static dispatch_once onceToken;  * Look up

        if ( !single)
        {
            // allocate the shared instance, because it hasn't been done yet
            single = [[User alloc] init];
        }

        return single;
    }
}

#pragma mark - LOAD ARRAY METHODS

-(void)loadArrayOfFollowers
{
    user = [PFUser currentUser];
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
}

-(void)loadArrayOfFollowing:(BOOL)update row:(NSInteger)row
{
    user = [PFUser currentUser];
    self.arrayOfFollowing = [NSMutableArray new];
    PFRelation *userFollowingRelation = [user relationForKey:@"Following" ];
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
            if (update)
            {
                [self.delegate reloadTableAfterArrayUpdate:row];
            }
        }
    }];

}

-(void)loadArrayOfNotifications
{
    self.arrayOfNotificationComments = [NSMutableArray new];
    self.arrayOfNotificationLikes = [NSMutableArray new];
    self.arrayOfNotificationTags = [NSMutableArray new];

    for (PFObject *object in arrayOfUserActivity)
    {
        PFUser *toUser = [object objectForKey:@"toUser"];
        NSString *stringType = [object objectForKey:@"type"];
        if ([toUser.objectId isEqual:user.objectId] && [stringType isEqualToString:@"commented on"])
        {
            //Creating Instance
            Notifications *notificationComments = [Notifications new];

            //Pull fromUserProfile Pic
            PFUser *fromUser = [object objectForKey:@"fromUser"];
            PFFile *parseFileWithImage = [fromUser objectForKey:@"profileImage"];
            NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
            NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
             {
                 //Setting Nofication Object properties
                 notificationComments.imageProfilePic = [UIImage imageWithData:data];
                 notificationComments.stringUsername = [fromUser objectForKey:@"username"];
                 notificationComments.stringType = [object objectForKey:@"type"];
                 notificationComments.stringMediaType = [object objectForKey:@"mediaType"];

                 //Adding Notification Object to Array
                 [self.arrayOfNotificationComments addObject:notificationComments];
             }];
        }
        else if ([toUser.objectId isEqual:user.objectId] && [stringType isEqualToString:@"tagged"])
        {
            //Creating Instance
            Notifications *notificationTagged = [Notifications new];

            //Pull fromUserProfile Pic
            PFUser *fromUser = [object objectForKey:@"fromUser"];
            PFFile *parseFileWithImage = [fromUser objectForKey:@"profileImage"];
            NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
            NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
             {
                 //Setting Nofication Object properties
                 notificationTagged.imageProfilePic = [UIImage imageWithData:data];
                 notificationTagged.stringUsername = [fromUser objectForKey:@"username"];
                 notificationTagged.stringType = [object objectForKey:@"type"];
                 notificationTagged.stringMediaType = [object objectForKey:@"mediaType"];

                 //Adding Notification Object to Array
                 [self.arrayOfNotificationTags addObject:notificationTagged];
             }];

        }
        else if ([toUser.objectId isEqual:user.objectId] && [stringType isEqualToString:@"liked"])
        {
            //Creating Instance
            Notifications *notificationLikes = [Notifications new];

            //Pull fromUserProfile Pic
            PFUser *fromUser = [object objectForKey:@"fromUser"];
            PFFile *parseFileWithImage = [fromUser objectForKey:@"profileImage"];
            NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
            NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
             {
                 //Setting Nofication Object properties
                 notificationLikes.imageProfilePic = [UIImage imageWithData:data];
                 notificationLikes.stringUsername = [fromUser objectForKey:@"username"];
                 notificationLikes.stringType = [object objectForKey:@"type"];
                 notificationLikes.stringMediaType = [object objectForKey:@"mediaType"];

                 //Adding Notification Object to Array
                 [self.arrayOfNotificationLikes addObject:notificationLikes];
             }];

        }

    }


}

-(void)loadArrayOfPhotos
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

                    [self.delegate reloadCollectionAfterArrayUpdate];
                }];
            }
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
        [self loadArrayOfNotifications];
    }];
}

-(void)loadActivityFromCurrentUser
{

//        self.arrayOfFromUserActivity = [NSMutableArray new];
//
//    [PFCloud callFunctionInBackground:@"Activity" withParameters:@{@"fromUser": @"ctqzn4n1Dj"} block:^(NSArray *result, NSError *error) {
//        if (error){
//            NSLog(@"%@", [error userInfo]);
//        }
//        else{
//
//            for (PFObject *activity in result) {
//                [self.arrayOfFromUserActivity addObject:activity];
//            }
//        }
//        [self loadArrayOfFollowing:nil row:0];
//    }];

    user = [PFUser currentUser];
    self.arrayOfFromUserActivity = [NSMutableArray new];
    PFQuery *queryForActivity = [PFQuery queryWithClassName:@"Activity"];
    [queryForActivity whereKey:@"fromUser" equalTo:user];
    [queryForActivity includeKey:@"fromUser"];
    [queryForActivity includeKey: @"toUser"];
    [queryForActivity includeKey:@"photo"];
    [queryForActivity findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error)
         {
             NSLog(@"%@",[error userInfo]);
         }
         else{

             for (PFObject *activity in objects)
             {
                 [self.arrayOfFromUserActivity addObject:activity];

             }
         }
         [self loadArrayOfFollowing:nil row:0];
     }];
}


#pragma mark - User Helper Methods

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

-(BOOL)isFollowingFollower:(PFUser *)follower
{
        // Determine if Current User is following follower
        for (PFUser *userFollowed in self.arrayOfFollowing)
        {
            if ([follower.objectId isEqual:userFollowed.objectId])
            {
                return YES;
            }
        }
    return NO;
}

-(void)removeUserFromFollowing:(PFUser *)follower row:(NSInteger)row
{
    // Remove follower from relation
    user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"Following"];
    PFObject *removedUser = follower;
    [relation removeObject:removedUser];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"%@",[error userInfo]);
        }
        else
        {
            NSLog(@"User has been removed from Following");
            [self loadArrayOfFollowing:YES row:row];
        }

     //   [self.delegate reloadTableAfterArrayUpdate:row];
        

    }];

}

-(void)addUserToFollowing:(PFUser *)follower row:(NSInteger)row
{
    // Add follower to relation
    user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"Following"];
    [relation addObject:follower];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"%@",[error userInfo]);
        }
        else
        {
            NSLog(@"User has been added to Following");
            [self loadArrayOfFollowing:YES row:row];
        }

        [self.delegate reloadTableAfterArrayUpdate:row];
       
    }];

}

-(UIImage *)followerStatus:(PFUser *)follower
{
      BOOL isFollowingFollower = [self isFollowingFollower:follower];

    if (isFollowingFollower)
    {
        return  [UIImage imageNamed:@"Following"];
    }
    else
    {
        return  [UIImage imageNamed:@"FollowAdd"];

    }
}




@end