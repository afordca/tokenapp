//
//  User.m
//  
//
//  Created by BASEL FARAG on 2/3/15.
//
//

#import "CurrentUser.h"
#import "User.h"
#import "Notification.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#import <MediaPlayer/MediaPlayer.h>


@implementation CurrentUser
{
    CurrentUser *anotherSingle;
}


@synthesize profileImage;
@synthesize userName;
@synthesize arrayOfFollowers;
@synthesize arrayOfNotifications;
@synthesize arrayOfFollowing;
@synthesize arrayOfPhotos;
@synthesize user;


+ (CurrentUser *)sharedSingleton
{
    static CurrentUser *single = nil;
    {

        //static dispatch_once onceToken;  * Look up

        if ( !single)
        {
            // allocate the shared instance, because it hasn't been done yet
            single = [[CurrentUser alloc] init];
        }

        return single;
    }
}

#pragma mark - LOAD ARRAY METHODS

-(void)loadArrayOfFollowers
{
    user = [PFUser currentUser];
    self.arrayOfFollowers = [NSMutableArray new];

    [PFCloud callFunctionInBackground:@"Followers" withParameters:@{@"objectId": user.objectId} block:^(NSArray *result, NSError *error)
     {
         if (error)
         {
             NSLog(@"%@", [error userInfo]);
         }
         else
         {
             for (PFUser *userFollower in result)
             {
                 User *follower = [[User alloc]initWithUser:userFollower];

                 [self.arrayOfFollowers addObject:follower];
             }
         }

     }];

}

-(void)loadArrayOfFollowing:(BOOL)update row:(NSInteger)row
{
    user = [PFUser currentUser];
    self.arrayOfFollowing = [NSMutableArray new];
//

    [PFCloud callFunctionInBackground:@"Following" withParameters:@{@"objectId": user.objectId} block:^(NSArray *result, NSError *error)
     {
         if (error)
         {
             NSLog(@"%@", [error userInfo]);
         }
         else
         {
             for (PFUser *userFollower in result)
             {
                 User *follower = [[User alloc]initWithUser:userFollower];

                 [self.arrayOfFollowing addObject:follower];
             }
             if (update) {
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

    for (PFObject *object in arrayOfNotifications)
    {
        PFUser *toUser = [object objectForKey:@"toUser"];
        NSString *stringType = [object objectForKey:@"type"];
        if ([toUser.objectId isEqual:user.objectId] && [stringType isEqualToString:@"commented on"])
        {
            //Creating Instance
            Notification *notificationComments = [Notification new];

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
            Notification *notificationTagged = [Notification new];

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
            Notification *notificationLikes = [Notification new];

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


    [PFCloud callFunctionInBackground:@"Photo" withParameters:@{@"userName": user.objectId} block:^(NSArray *result, NSError *error)
     {
         if (error)
         {
             NSLog(@"%@", [error userInfo]);
         }
         else
         {
             for (PFObject *photo in result)
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
                         UIImage *photo = [UIImage imageWithData:data];
                         Photo *newPhoto = [[Photo alloc]initWithImage:photo];
                         [self.arrayOfPhotos addObject:newPhoto];
                         // [self.arrayOfPhotos addObject:[UIImage imageWithData:data]];
                     }

                     [self.delegate reloadCollectionAfterArrayUpdate];
                 }];
             }
         }
     }];
}


-(void)loadArrayOfVideos
{
    user = [PFUser currentUser];
    self.arrayOfVideos = [NSMutableArray new];

    [PFCloud callFunctionInBackground:@"Video" withParameters:@{@"userName": user.objectId} block:^(NSArray *result, NSError *error)
     {
         if (error)
         {
             NSLog(@"%@", [error userInfo]);
         }
         else
         {
             NSLog(@"Worked Videos");

             for (PFObject *video in result)
             {
              PFFile *parseFileWithImage = [video objectForKey:@"video"];

                 NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
                 Video *video = [[Video alloc]initWithUrl:url];
                  [self.arrayOfVideos addObject:video];

             }

         }
     }];


}


-(void)loadArrayOfLinks
{
    user = [PFUser currentUser];
    self.arrayOfLinks = [NSMutableArray new];


    [PFCloud callFunctionInBackground:@"Link" withParameters:@{@"userName": user.objectId} block:^(NSArray *result, NSError *error)
     {
         if (error)
         {
             NSLog(@"%@", [error userInfo]);
         }
         else
         {
             NSLog(@"Worked Links");
             for (PFObject *link in result)
             {
                 NSString *linkURL = [link objectForKey:@"url"];
                 Link *link = [[Link alloc]initWithUrl:linkURL];
                 [self.arrayOfLinks addObject:link];

             }


             
         }
     }];
    
}

-(void)loadArrayOfPosts
{
    user = [PFUser currentUser];
    self.arrayOfPosts = [NSMutableArray new];


    [PFCloud callFunctionInBackground:@"Note" withParameters:@{@"userName": user.objectId} block:^(NSArray *result, NSError *error)
     {
         if (error)
         {
             NSLog(@"%@", [error userInfo]);
         }
         else
         {
             NSLog(@"Worked Posts");
         }
     }];
    
}

//Notifications
-(void)loadActivityToCurrentUser
{
    user = [PFUser currentUser];
    self.arrayOfNotifications = [NSMutableArray new];
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
                //PHOTO ACTIVITY
                if ([[activity objectForKey:@"mediaType"]isEqualToString:@"photo"])
                {
                    PFFile *parseFileWithImage = [[activity objectForKey:@"photo"]objectForKey:@"image"];
                    NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
                    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
                    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
                     {

                         if (connectionError)
                         {
                             NSLog(@"%@",[connectionError userInfo]);
                         }
                         else
                         {
                             UIImage *photo = [UIImage imageWithData:data];
                             Photo *activityPhoto = [[Photo alloc]initWithImage:photo];
                             NSString *typeOfActivity = [activity objectForKey:@"type"];
                             NSString *mediaType = [activity objectForKey:@"mediaType"];

                             User *fromUser = [[User alloc]initWithUser:[activity objectForKey:@"fromUser"]];
                             User *toUser = [[User alloc]initWithUser:[activity objectForKey:@"toUser"]];

                             
                             
                             [self.arrayOfNotifications addObject:activity];
                             
                         }
                         
                     }];
                    
                }

            }
        }
        [self loadArrayOfNotifications];
    }];
}

//Personal Activity
-(void)loadActivityFromCurrentUser
{
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
         else
         {
             for (PFObject *activity in objects)
             {
                 //PHOTO ACTIVITY
                 if ([[activity objectForKey:@"mediaType"]isEqualToString:@"photo"])
                 {
                 PFFile *parseFileWithImage = [[activity objectForKey:@"photo"]objectForKey:@"image"];
                 NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
                 NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
                 [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
                 {

                     if (connectionError)
                     {
                         NSLog(@"%@",[connectionError userInfo]);
                     }
                     else
                     {
                         UIImage *photo = [UIImage imageWithData:data];
                         Photo *activityPhoto = [[Photo alloc]initWithImage:photo];
                         NSString *typeOfActivity = [activity objectForKey:@"type"];
                         NSString *mediaType = [activity objectForKey:@"mediaType"];

                         User *fromUser = [[User alloc]initWithUser:[activity objectForKey:@"fromUser"]];
                         User *toUser = [[User alloc]initWithUser:[activity objectForKey:@"toUser"]];

                         Activity *activity = [[Activity alloc]initWithPhoto:fromUser toUser:toUser activity:typeOfActivity media:mediaType photo:activityPhoto];

                         [self.arrayOfFromUserActivity addObject:activity];

                     }

                 }];

                 }

             }
         }
     }];
}

#pragma mark - User Helper Methods

-(void)setUserProfile
{
        user = [PFUser currentUser];
        self.userClicked = NO;
        //Loading Profile Image
        PFFile *profileImageFile = [user objectForKey:@"profileImage"];
        PFImageView *imageView = [PFImageView new];
        imageView.file = profileImageFile;
        [imageView loadInBackground:^(UIImage *image, NSError *error) {
    
            //Setting image to singleton class USER
            self.profileImage = image;
    
            //Setting Username to singleton class USER
            if ([user objectForKey:@"username"])
            {
                self.userName = [user objectForKey:@"username"];
            } else
            {
                self.userName = user.username;
            }

            self.Firstname = [user objectForKey:@"Firstname"];
            self.Lastname = [user objectForKey:@"Lastname"];
            self.Phone = [user objectForKey:@"Phone"];
            self.Email = [user objectForKey:@"email"];
            self.Biography = [user objectForKey:@"Biography"];
            self.Birthday = [user objectForKey:@"Birthday"];
            self.Gender = [user objectForKey: @"Gender"];
            self.switchPostPrivate = [[user objectForKey:@"PostPrivate"]boolValue];
            self.switchTokensPrivate = [[user objectForKey:@"TokensPrivate"]boolValue];
    
        }];
}

-(BOOL)isFollowingFollower:(NSString *)follower
{
    // Determine if Current User is following follower
    for (User *userFollowed in self.arrayOfFollowing)
    {
        if ([follower isEqual:userFollowed.objectID])
        {
            return YES;
        }
    }
    return NO;
}

-(void)removeUserFromFollowing:(User *)follower row:(NSInteger)row
{
    // Remove follower from relation
    user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"Following"];



    PFQuery *queryUser = [PFUser query];
    [queryUser whereKey:@"objectId" equalTo:follower.objectID];
    PFObject *userFollower = [queryUser getFirstObject];



    [relation removeObject:userFollower];
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


-(void)addUserToFollowing:(User *)follower row:(NSInteger)row
{
    // Add follower to relation
    user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"Following"];

    PFQuery *queryUser = [PFUser query];
    [queryUser whereKey:@"objectId" equalTo:follower.objectID];
    PFObject *userFollower = [queryUser getFirstObject];

    [relation addObject:userFollower];

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


-(UIImage *)followerStatus:(NSString *)follower
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