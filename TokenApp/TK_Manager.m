//
//  TK_Manager.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/26/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "TK_Manager.h"

@implementation TK_Manager

+(NSArray *)loadArrayOfContent:(NSMutableArray *)photos arrayOfVideos:(NSMutableArray *)videos arrayOfLinks:(NSMutableArray *)links
{
    NSArray *arrayOfContent = [NSMutableArray new];
    arrayOfContent = [NSArray arrayWithArray:[photos arrayByAddingObjectsFromArray:videos]];
    arrayOfContent = [arrayOfContent arrayByAddingObjectsFromArray:links];

    //    NSSortDescriptor *sortDescriptor;
    //    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt"
    //                                                 ascending:YES];
    //    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    //    NSArray *sortedArray;
    //    sortedArray = [arrayOfContent sortedArrayUsingDescriptors:sortDescriptors];

    return arrayOfContent;
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

+(NSMutableArray*)loadArrayOfPhotos:(NSString *)userID
{
    NSMutableArray *arrayOfPhotos = [NSMutableArray new];


    [PFCloud callFunctionInBackground:@"Photo" withParameters:@{@"userName": userID} block:^(NSArray *result, NSError *error)
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
                         UIImage *imagePhoto = [UIImage imageWithData:data];
                         NSString *name = [photo objectForKey:@"userName"];
                         Photo *newPhoto = [[Photo alloc]initWithImage:imagePhoto name:name time:nil];
                         [arrayOfPhotos addObject:newPhoto];
                     }
                 }];
             }
         }
     }];

    return arrayOfPhotos;
}

+(NSMutableArray*)loadArrayOfVideos:(NSString *)userID
{
    NSMutableArray *arrayOfVideos = [NSMutableArray new];

    [PFCloud callFunctionInBackground:@"Video" withParameters:@{@"userName": userID} block:^(NSArray *result, NSError *error)
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
                 [arrayOfVideos addObject:video];

             }

         }
     }];

    return arrayOfVideos;
}

+(NSMutableArray*)loadArrayOfPosts:(NSString *)userID
{
    NSMutableArray *arrayOfPosts = [NSMutableArray new];


    [PFCloud callFunctionInBackground:@"Note" withParameters:@{@"userName": userID} block:^(NSArray *result, NSError *error)
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

    return arrayOfPosts;
}

+(NSMutableArray*)loadArrayOfLinks:(NSString *)userID
{
    NSMutableArray *arrayOfLinks = [NSMutableArray new];


    [PFCloud callFunctionInBackground:@"Link" withParameters:@{@"userName": userID} block:^(NSArray *result, NSError *error)
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
                 [arrayOfLinks addObject:link];
                 
             }
             
         }
     }];
    
    return arrayOfLinks;
}

@end
