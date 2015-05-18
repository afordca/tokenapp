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
#import "HomeFeedPost.h"
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
@synthesize numberOfPhotoTokens;
@synthesize arrayOfBalanceActivity;


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

-(void)loadArrayOfFollowers:(void (^)(BOOL))completionHandler
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

             completionHandler(YES);
         }

     }];
}

-(void)loadArrayOfFollowing:(BOOL)update row:(NSInteger)row completion:(void (^)(BOOL))completionHandler
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
             for (PFUser *userFollowing in result)
             {
                 User *following = [[User alloc]initWithUser:userFollowing];

                 [self.arrayOfFollowing addObject:following];
             }

             completionHandler(YES);

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
                             NSString *name= [[activity objectForKey:@"toUser"]objectForKey:@"username"];
                             NSString *photoID = [[activity objectForKey:@"photo"]objectId];
                             NSString *description = [[activity objectForKey:@"photo"]objectForKey:@"description"];
                             NSNumber *likes = [[activity objectForKey:@"photo"]objectForKey:@"numberOfLikes"];
                             NSInteger numberOfLikes = likes.integerValue;

                             Photo *activityPhoto = [[Photo alloc]initWithImage:photo name:name time:nil description:description photoID:photoID likes:numberOfLikes];
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
                        NSString *name= [[activity objectForKey:@"toUser"]objectForKey:@"username"];
                         NSString *photoID = [[activity objectForKey:@"photo"]objectId];
                         NSString *description = [[activity objectForKey:@"photo"]objectForKey:@"description"];
                         NSNumber *likes = [[activity objectForKey:@"photo"]objectForKey:@"numberOfLikes"];
                         NSInteger numberOfLikes = likes.integerValue;

                         Photo *activityPhoto = [[Photo alloc]initWithImage:photo name:name time:nil description: description photoID:photoID likes:numberOfLikes];
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

-(void)loadHomeFeedContent:(void (^)(BOOL))completionHandler
{
    self.arrayOfHomeFeedContent = [NSMutableArray new];

    if (!self.arrayOfHomeFeedActivity.count)
    {
        completionHandler(YES);
    }

    for (PFObject *homeFeedActivity in self.arrayOfHomeFeedActivity)
    {

        // PHOTO
        if ([[homeFeedActivity objectForKey:@"mediaType"]isEqualToString:@"photo"])
        {
            PFFile *parseFileWithImage = [[homeFeedActivity objectForKey:@"photo"]objectForKey:@"image"];
            NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
            NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data1, NSError *connectionError)
            {

                if (connectionError)
                {
                    NSLog(@"%@",[connectionError userInfo]);
                }
                else
                {
                    PFFile *parseProfileImage = [[homeFeedActivity objectForKey:@"fromUser"]objectForKey:@"profileImage"];
                    NSURL *urlProfile = [NSURL URLWithString:parseProfileImage.url];
                    NSURLRequest *requestURLProfile = [NSURLRequest requestWithURL:urlProfile];
                    [NSURLConnection sendAsynchronousRequest:requestURLProfile queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
                     {
                         self.homeFeedContent = [UIImage imageWithData:data1];
                         self.homeFeedProfilePic = [UIImage imageWithData:data];
                         NSString *name= [homeFeedActivity objectForKey:@"username"];
                         NSString *userID = [[homeFeedActivity objectForKey:@"fromUser"]objectId];
                         NSString *photoID = [[homeFeedActivity objectForKey:@"photo"]objectId];
                         NSString *description =[[homeFeedActivity objectForKey:@"photo"]objectForKey:@"description"];
                         PFUser *userWithContent = [homeFeedActivity objectForKey:@"fromUser"];
                         NSNumber *likes = [[homeFeedActivity objectForKey:@"photo"]objectForKey:@"numberOfLikes"];
                         NSInteger numberOfLikes = likes.integerValue;

                         Photo *photo = [[Photo alloc]initWithImage:self.homeFeedContent name:name time:nil description:description photoID:photoID likes:numberOfLikes];

                         User *userContent = [[User alloc]initWithUser:userWithContent];

                         HomeFeedPost *homeFeedPost = [[HomeFeedPost alloc]initWithUsername:name profilePic:self.homeFeedProfilePic timePosted:nil photo:photo post:nil video:nil link:nil mediaType:@"photo" userID:userID user:userContent];

                         [self.arrayOfHomeFeedContent addObject:homeFeedPost];

                         if (self.arrayOfHomeFeedContent.count == self.arrayOfHomeFeedActivity.count)
                         {
                             completionHandler(YES);
                         }

                     }];
                }
            }];
    }
        // Video
        if ([[homeFeedActivity objectForKey:@"mediaType"]isEqualToString:@"video"])
        {
            PFFile *parseFileWithVideo = [[homeFeedActivity objectForKey:@"video"]objectForKey:@"video"];
            PFFile *parseProfileImage = [[homeFeedActivity objectForKey:@"fromUser"]objectForKey:@"profileImage"];
            NSURL *urlProfile = [NSURL URLWithString:parseProfileImage.url];
            NSURLRequest *requestURLProfile = [NSURLRequest requestWithURL:urlProfile];
            [NSURLConnection sendAsynchronousRequest:requestURLProfile queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
             {

                 if (connectionError)
                 {
                     NSLog(@"%@",[connectionError userInfo]);
                 }
                 else
                 {
                     NSURL *url = [NSURL URLWithString:parseFileWithVideo.url];

                     NSString *name= [homeFeedActivity objectForKey:@"username"];
                      NSString *userID = [[homeFeedActivity objectForKey:@"fromUser"]objectId];
                     NSString *videoID = [[homeFeedActivity objectForKey:@"video"]objectId];
                     NSString *videoDescription = [[homeFeedActivity objectForKey:@"video"]objectForKey:@"description"];

                     self.homeFeedProfilePic = [UIImage imageWithData:data];
                     PFUser *userWithContent = [homeFeedActivity objectForKey:@"fromUser"];

                     NSNumber *likes = [[homeFeedActivity objectForKey:@"video"]objectForKey:@"numberOfLikes"];
                     NSInteger numberOfLikes = likes.integerValue;

                     Video *video = [[Video alloc]initWithUrl:url likes:numberOfLikes videoID:videoID videoDescription:videoDescription];
                     
                     User *userContent = [[User alloc]initWithUser:userWithContent];
         
                     HomeFeedPost *homeFeedPost = [[HomeFeedPost alloc]initWithUsername:name profilePic:self.homeFeedProfilePic timePosted:nil photo:nil post:nil video:video link:nil mediaType:@"video" userID:userID user:userContent];

                     [self.arrayOfHomeFeedContent addObject:homeFeedPost];
         
                     if (self.arrayOfHomeFeedContent.count == self.arrayOfHomeFeedActivity.count)
                     {
                         completionHandler(YES);
                     }
                 }
             }];
        }
        //LINK
        if ([[homeFeedActivity objectForKey:@"mediaType"]isEqualToString:@"link"])
        {
            PFFile *parseProfileImage = [[homeFeedActivity objectForKey:@"fromUser"]objectForKey:@"profileImage"];
            NSURL *urlProfile = [NSURL URLWithString:parseProfileImage.url];
            NSURLRequest *requestURLProfile = [NSURLRequest requestWithURL:urlProfile];
            [NSURLConnection sendAsynchronousRequest:requestURLProfile queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
             {
                 if (connectionError)
                 {
                     NSLog(@"%@",[connectionError userInfo]);
                 }
                 else
                 {
                     NSString *name= [homeFeedActivity objectForKey:@"username"];
                      NSString *userID = [[homeFeedActivity objectForKey:@"fromUser"]objectId];
                     NSString *linkID = [[homeFeedActivity objectForKey:@"link"]objectId];
                     NSString *linkDescription = [[homeFeedActivity objectForKey:@"link"]objectForKey:@"description"];
                     NSNumber *likes = [[homeFeedActivity objectForKey:@"link"]objectForKey:@"numberOfLikes"];
                     NSInteger numberOfLikes = likes.integerValue;
                     self.homeFeedProfilePic = [UIImage imageWithData:data];
                     PFUser *userWithContent = [homeFeedActivity objectForKey:@"fromUser"];



                     NSString *linkURL = [[homeFeedActivity objectForKey:@"link"]objectForKey:@"url"];

                     Link *link = [[Link alloc]initWithUrl:linkURL urlID:linkID description:linkDescription likes:numberOfLikes];
                     User *userContent = [[User alloc]initWithUser:userWithContent];

                     HomeFeedPost *homeFeedPost = [[HomeFeedPost alloc]initWithUsername:name profilePic:self.homeFeedProfilePic timePosted:nil photo:nil post:nil video:nil link:link mediaType:@"link" userID:userID user:userContent];

                     [self.arrayOfHomeFeedContent addObject:homeFeedPost];


                             if (self.arrayOfHomeFeedContent.count == self.arrayOfHomeFeedActivity.count)
                             {
                                 completionHandler(YES);
                             }
                 }
            }];
        }

        //POST
        if ([[homeFeedActivity objectForKey:@"mediaType"]isEqualToString:@"note"])
        {
            PFFile *parseProfileImage = [[homeFeedActivity objectForKey:@"fromUser"]objectForKey:@"profileImage"];
            NSURL *urlProfile = [NSURL URLWithString:parseProfileImage.url];
            NSURLRequest *requestURLProfile = [NSURLRequest requestWithURL:urlProfile];
            [NSURLConnection sendAsynchronousRequest:requestURLProfile queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
             {
                 if (connectionError)
                 {
                     NSLog(@"%@",[connectionError userInfo]);
                 }
                 else
                 {
                     NSString *name= [homeFeedActivity objectForKey:@"username"];
                      NSString *userID = [[homeFeedActivity objectForKey:@"fromUser"]objectId];
                     NSString *postID = [[homeFeedActivity objectForKey:@"post"]objectId];
                     NSString *postDescription = [[homeFeedActivity objectForKey:@"post"]objectForKey:@"description"];
                     NSNumber *likes = [[homeFeedActivity objectForKey:@"post"]objectForKey:@"numberOfLikes"];
                     NSInteger numberOfLikes = likes.integerValue;

                     self.homeFeedProfilePic = [UIImage imageWithData:data];


                     NSString *postMessage = [[homeFeedActivity objectForKey:@"note"]objectForKey:@"note"];
                     NSString *postHeader = [[homeFeedActivity objectForKey:@"note"]objectForKey:@"description"];
                     PFUser *userWithContent = [homeFeedActivity objectForKey:@"fromUser"];

                     Post *post = [[Post alloc]initWithDescription:postMessage header:postHeader postID:postID postDescription:postDescription likes:numberOfLikes];
                     User *userContent = [[User alloc]initWithUser:userWithContent];

                     HomeFeedPost *homeFeedPost = [[HomeFeedPost alloc]initWithUsername:name profilePic:self.homeFeedProfilePic timePosted:nil photo:nil post:post video:nil link:nil mediaType:@"post" userID:userID user:userContent];
                     
                     [self.arrayOfHomeFeedContent addObject:homeFeedPost];


                     if (self.arrayOfHomeFeedContent.count == self.arrayOfHomeFeedActivity.count)
                     {
                         completionHandler(YES);
                     }
                 }
             }];
        }

    }

}

-(void)loadHomeFeedActivity:(void (^)(BOOL))completionHandler
{
    self.arrayOfHomeFeedActivity = [NSMutableArray new];
    NSMutableArray *arrayOfUsernameFollowing = [NSMutableArray new];
    NSString *currentUsername = [[PFUser currentUser]username];

    for (User *following in self.arrayOfFollowing)
    {
        [arrayOfUsernameFollowing addObject:following.userName];
    }

    [arrayOfUsernameFollowing addObject:currentUsername];

    PFQuery *queryForActivity = [PFQuery queryWithClassName:@"Activity"];

    [queryForActivity whereKey:@"type" equalTo:@"post"];
    [queryForActivity whereKey:@"username" containedIn:arrayOfUsernameFollowing];
    [queryForActivity setLimit:10];
    [queryForActivity setSkip:0];
    [queryForActivity orderByDescending:@"createdAt"];
    [queryForActivity includeKey:@"fromUser"];
    [queryForActivity includeKey: @"toUser"];
    [queryForActivity includeKey:@"photo"];
    [queryForActivity includeKey:@"video"];
    [queryForActivity includeKey:@"link"];
    [queryForActivity includeKey:@"note"];

    [queryForActivity findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            for (PFObject *activity in objects)
            {
                [self.arrayOfHomeFeedActivity addObject:activity];
            }

            NSLog(@"%@",self.arrayOfHomeFeedActivity);
            completionHandler(YES);
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
            self.userID = user.objectId;
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
            [self loadArrayOfFollowing:YES row:row completion:^(BOOL result)
            {

            }];
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
            
            [self loadArrayOfFollowing:YES row:row completion:^(BOOL result) {

            }];
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


#pragma mark - TOKEN METHODS

-(NSNumber*)getNumberOfPhotoTokens
{
    numberOfPhotoTokens = [NSNumber numberWithInt:0];


    PFQuery *queryForActivity = [PFQuery queryWithClassName:@"Activity"];
    [queryForActivity whereKey:@"type" equalTo:@"viewed"];
    [queryForActivity whereKey:@"mediaType" equalTo:@"photo"];
    [queryForActivity findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (error)
        {
            NSLog(@"Error:%@",[error userInfo]);
        }
        else
        {

            for (PFObject *photo in objects)
            {
                int value = [numberOfPhotoTokens intValue];
                numberOfPhotoTokens = [NSNumber numberWithInt:value + 1];
            }

        }
        
    }];

    return numberOfPhotoTokens;

}

-(NSNumber *)getNumberOfVideoTokens
{
    return 0;
}

-(NSNumber *)getNumberOfLinkTokens
{
    return 0;
}

-(NSNumber *)getNumberOfPostTokens
{
    return 0;
}

    
    


@end