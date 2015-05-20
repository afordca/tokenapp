//
//  TK_Manager.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/26/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "TK_Manager.h"
#import <Parse/Parse.h>



@implementation TK_Manager

+(NSMutableArray *)loadArrayOfContent
{
    CurrentUser *user = [CurrentUser sharedSingleton];
    NSMutableArray * arrayOfContent = [NSMutableArray new];
    for (HomeFeedPost *post in user.arrayOfHomeFeedContent)
    {
        if ([post.userID isEqualToString:user.userID])
        {
            [arrayOfContent addObject:post];
        }
    }

    return arrayOfContent;
}

-(void)loadArrayOfOtherUserContent:(NSMutableArray *)activity completion:(void (^)(BOOL))completionHandler
{
    self.arrayOfUserContent = [NSMutableArray new];

    if (!activity.count)
    {
        completionHandler(YES);

    }

    for (PFObject *homeFeedActivity in activity)
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
                       UIImage *homeFeedContent = [UIImage imageWithData:data1];
                        UIImage *homeFeedProfilePic = [UIImage imageWithData:data];
                          NSString *name= [homeFeedActivity objectForKey:@"username"];
                          NSString *userID = [[homeFeedActivity objectForKey:@"photo"]objectId];
                          NSString *photoID = [[homeFeedActivity objectForKey:@"fromUser"]objectId];
                          NSString *description = [[homeFeedActivity objectForKey:@"photo"]objectForKey:@"description"];
                          PFUser *userWithContent = [homeFeedActivity objectForKey:@"fromUser"];
                          NSNumber *likes = [[homeFeedActivity objectForKey:@"photo"]objectForKey:@"numberOfLikes"];
                          NSInteger numberOfLikes = likes.integerValue;

                          Photo *photo = [[Photo alloc]initWithImage:homeFeedContent name:name time:nil description:description photoID:photoID likes:numberOfLikes];
                          User *userContent = [[User alloc]initWithUser:userWithContent];

                          HomeFeedPost *homeFeedPost = [[HomeFeedPost alloc]initWithUsername:name profilePic:homeFeedProfilePic timePosted:nil photo:photo post:nil video:nil link:nil mediaType:@"photo" userID:userID user:userContent];

                          [self.arrayOfUserContent addObject:homeFeedPost];

                          if (self.arrayOfUserContent.count == activity.count)
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


                     UIImage *homeFeedProfilePic = [UIImage imageWithData:data];
                     PFUser *userWithContent = [homeFeedActivity objectForKey:@"fromUser"];
                     NSNumber *likes = [[homeFeedActivity objectForKey:@"video"]objectForKey:@"numberOfLikes"];
                     NSInteger numberOfLikes = likes.integerValue;


                     Video *video = [[Video alloc]initWithUrl:url likes:numberOfLikes videoID:videoID videoDescription:videoDescription];
                     User *userContent = [[User alloc]initWithUser:userWithContent];

                     HomeFeedPost *homeFeedPost = [[HomeFeedPost alloc]initWithUsername:name profilePic:homeFeedProfilePic timePosted:nil photo:nil post:nil video:video link:nil mediaType:@"video" userID:userID user:userContent];

                     [self.arrayOfUserContent addObject:homeFeedPost];

                     if (self.arrayOfUserContent.count == activity.count)
                     {
                         completionHandler(YES);
                     }

                 }
             }];
        }
        //LINK
        if ([[homeFeedActivity objectForKey:@"mediaType"]isEqualToString:@"link"])
        {

            PFFile *parseFileWithImage = [[homeFeedActivity objectForKey:@"link"]objectForKey:@"imageLink"];
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
                     NSString *linkTitle = [[homeFeedActivity objectForKey:@"link"]objectForKey:@"linkTitle"];
                     UIImage *linkImage = [UIImage imageWithData:data1];
                     UIImage *homeFeedProfilePic = [UIImage imageWithData:data];
                     PFUser *userWithContent = [homeFeedActivity objectForKey:@"fromUser"];
                     NSNumber *likes = [[homeFeedActivity objectForKey:@"link"]objectForKey:@"numberOfLikes"];
                     NSInteger numberOfLikes = likes.integerValue;

                     NSString *linkURL = [[homeFeedActivity objectForKey:@"link"]objectForKey:@"url"];

                     Link *link = [[Link alloc]initWithUrl:linkURL linkImage:linkImage linkDescription:linkDescription linkTitle:linkTitle likes:numberOfLikes linkID:linkID];
                     User *userContent = [[User alloc]initWithUser:userWithContent];

                     HomeFeedPost *homeFeedPost = [[HomeFeedPost alloc]initWithUsername:name profilePic:homeFeedProfilePic timePosted:nil photo:nil post:nil video:nil link:link mediaType:@"link" userID:userID user:userContent];

                     [self.arrayOfUserContent addObject:homeFeedPost];

                     if (self.arrayOfUserContent.count == activity.count)
                     {
                         completionHandler(YES);
                     }
                 }
             }];
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
                     UIImage *homeFeedProfilePic = [UIImage imageWithData:data];

                     NSString *postMessage = [[homeFeedActivity objectForKey:@"note"]objectForKey:@"note"];
                     NSString *postHeader = [[homeFeedActivity objectForKey:@"note"]objectForKey:@"description"];
                     PFUser *userWithContent = [homeFeedActivity objectForKey:@"fromUser"];

                     Post *post = [[Post alloc]initWithDescription:postMessage header:postHeader];
                     User *userContent = [[User alloc]initWithUser:userWithContent];
                     
                     HomeFeedPost *homeFeedPost = [[HomeFeedPost alloc]initWithUsername:name profilePic:homeFeedProfilePic timePosted:nil photo:nil post:post video:nil link:nil mediaType:@"post" userID:userID user:userContent];
                     
                     [self.arrayOfUserContent addObject:homeFeedPost];
                     
                     
                     if (self.arrayOfUserContent.count == activity.count)
                     {
                         completionHandler(YES);
                     }
                 }
             }];
        }
    }
}

-(void)loadarrayOfActivity:(User *)user completion:(void (^)(BOOL))completionHandler
{
    self.arrayOfActivity = [NSMutableArray new];
    PFQuery *queryForActivity = [PFQuery queryWithClassName:@"Activity"];

    [queryForActivity orderByDescending:@"createdAt"];
    [queryForActivity whereKey:@"type" equalTo:@"post"];
    [queryForActivity includeKey:@"fromUser"];
    [queryForActivity includeKey:@"photo"];
    [queryForActivity includeKey:@"video"];
    [queryForActivity includeKey:@"link"];
    [queryForActivity includeKey:@"note"];

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
                 if ([[activity objectForKey:@"fromUserID"]isEqualToString:user.objectID])
                      {
                          [self.arrayOfActivity addObject:activity];
                      }
             }
             completionHandler(YES);
         }

     }];
}

-(void)loadFollowers:(NSString *)userID user:(PFUser *)user completion :(void (^)(BOOL))completionHandler
{
    self.arrayOfFollowers = [NSMutableArray new];
    PFQuery *queryFollowers = [PFQuery queryWithClassName:@"Activity"];

    [queryFollowers includeKey:@"fromUser"];
    [queryFollowers whereKey:@"type" equalTo:@"follow"];
    [queryFollowers whereKey:@"toUser" equalTo: user];
    [queryFollowers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error) {
             NSLog(@"%@",[error userInfo]);
         }
         else
         {
             for (PFObject *activity in objects)
             {
                 PFUser *pffollower = [activity objectForKey:@"fromUser"];
                 User *follower = [[User alloc]initWithUser:pffollower];

                 [self.arrayOfFollowers addObject:follower];
             }

             completionHandler(YES);
         }
     }];

}

-(void)loadFollowing:(NSString *)userID completion:(void (^)(BOOL))completionHandler
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
             for (PFUser *userFollowing in result)
             {
                 User *following = [[User alloc]initWithUser:userFollowing];
                 [self.arrayOfFollowing addObject:following];
             }

              completionHandler(YES);
         }
     }];
}

-(void)loadDiscoverActivity:(void (^)(BOOL))completionHandler
{
    self.arrayOfActivity = [NSMutableArray new];
    CurrentUser *currentUser = [CurrentUser sharedSingleton];
    PFQuery *queryForActivity = [PFQuery queryWithClassName:@"Activity"];

    [queryForActivity orderByDescending:@"createdAt"];
    [queryForActivity whereKey:@"type" equalTo:@"post"];

    [queryForActivity includeKey:@"fromUser"];
    [queryForActivity includeKey:@"photo"];
    [queryForActivity includeKey:@"video"];
    [queryForActivity includeKey:@"link"];
    [queryForActivity includeKey:@"note"];

//    [queryForActivity setLimit:20];
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
                 if (![[[activity objectForKey:@"fromUser"]objectId]isEqual:currentUser.userID]) {
                     [self.arrayOfActivity addObject:activity];
                 }

             }
             completionHandler(YES);
         }

     }];
}

-(void)loadDiscoverUsers:(void (^)(BOOL))completionHandler
{
    self.arrayOfDiscoverUsers = [NSMutableArray new];

    CurrentUser *currentUser = [CurrentUser sharedSingleton];
    PFQuery *queryForActivity = [PFQuery queryWithClassName:@"Activity"];

    [queryForActivity orderByDescending:@"createdAt"];
    [queryForActivity whereKey:@"type" equalTo:@"post"];

    [queryForActivity includeKey:@"fromUser"];
    [queryForActivity includeKey:@"photo"];
    [queryForActivity includeKey:@"video"];
    [queryForActivity includeKey:@"link"];
    [queryForActivity includeKey:@"note"];

    [queryForActivity setLimit:20];
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
                 if (![[[activity objectForKey:@"fromUser"]objectId]isEqual:currentUser.userID]) {

                     PFUser *user = [activity objectForKey:@"fromUser"];
                     User *discoverUser = [[User alloc]initWithUser:user];

                     if (![currentUser isFollowingFollower:discoverUser.objectID])
                     {
                          [self.arrayOfDiscoverUsers addObject:discoverUser];
                     }

                 }

             }
             completionHandler(YES);
         }
         
     }];
}

@end
