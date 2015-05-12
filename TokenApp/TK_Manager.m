//
//  TK_Manager.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/26/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "TK_Manager.h"



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
                          NSString *userID = [[homeFeedActivity objectForKey:@"fromUser"]objectId];
                          PFUser *userWithContent = [homeFeedActivity objectForKey:@"fromUser"];

                          Photo *photo = [[Photo alloc]initWithImage:homeFeedContent name:name time:nil];
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
                     UIImage *homeFeedProfilePic = [UIImage imageWithData:data];
                     PFUser *userWithContent = [homeFeedActivity objectForKey:@"fromUser"];

                     Video *video = [[Video alloc]initWithUrl:url];
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
                     PFUser *userWithContent = [homeFeedActivity objectForKey:@"fromUser"];


                     NSString *linkURL = [[homeFeedActivity objectForKey:@"link"]objectForKey:@"url"];

                     Link *link = [[Link alloc]initWithUrl:linkURL];
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

+(NSMutableArray*)loadFollowers:(NSString *)userID
{
   NSMutableArray *arrayOfFollowers = [NSMutableArray new];
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

                 [arrayOfFollowers addObject:userFollower];
             }
         }

     }];

    return arrayOfFollowers;
}

+(NSMutableArray*)loadFollowing:(NSString *)userID
{
    NSMutableArray *arrayOfFollowing = [NSMutableArray new];

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
                 [arrayOfFollowing addObject:userFollower];
             }

         }

     }];

    return arrayOfFollowing;
}

@end
