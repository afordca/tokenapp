//
//  TKUtility.m
//  TokenApp
//
//  Created by BASEL FARAG on 12/19/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import "TKUtility.h"
#import "Macros.h"
#import "TKCache.h"
#import "Constants.h"

@implementation TKUtility

#pragma mark Like Photos

+ (void)likePhotoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kPTKActivityClassKey];
    [queryExistingLikes whereKey:kPTKActivityPhotoKey equalTo:photo];
    [queryExistingLikes whereKey:kPTKActivityTypeKey equalTo:kPTKActivityTypeKey];
    [queryExistingLikes whereKey:kPTKActivityFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity delete];
            }
        }

        // proceed to creating new like
        PFObject *likeActivity = [PFObject objectWithClassName:kPTKActivityClassKey];
        [likeActivity setObject:kPTKActivityTypeKey forKey:kPTKActivityTypeKey];
        [likeActivity setObject:[PFUser currentUser] forKey:kPTKActivityFromUserKey];
        [likeActivity setObject:[photo objectForKey:kPTKPhotoUserKey] forKey:kPTKActivityFromUserKey];
        [likeActivity setObject:photo forKey:kPTKActivityPhotoKey];

        PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [likeACL setPublicReadAccess:YES];
        [likeACL setWriteAccess:YES forUser:[photo objectForKey:kPTKPhotoUserKey]];
        likeActivity.ACL = likeACL;

        [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (completionBlock) {
                completionBlock(succeeded,error);
            }

            // refresh cache
            PFQuery *query = [TKUtility queryForActivitiesOnPhoto:photo cachePolicy:kPFCachePolicyNetworkOnly];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {

                    NSMutableArray *likers = [NSMutableArray array];
                    NSMutableArray *commenters = [NSMutableArray array];

                    BOOL isLikedByCurrentUser = NO;

                    for (PFObject *activity in objects) {
                        if ([[activity objectForKey:kPTKActivityTypeKey] isEqualToString:kPTKActivityTypeKey] && [activity objectForKey:kPTKActivityFromUserKey]) {
                            [likers addObject:[activity objectForKey:kPTKActivityFromUserKey]];
                        } else if ([[activity objectForKey:kPTKActivityTypeKey] isEqualToString:kPTKActivityTypeComment] && [activity objectForKey:kPTKActivityFromUserKey]) {
                            [commenters addObject:[activity objectForKey:kPTKActivityFromUserKey]];
                        }

                        if ([[[activity objectForKey:kPTKActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                            if ([[activity objectForKey:kPTKActivityTypeKey] isEqualToString:kPTKActivityTypeKey]) {
                                isLikedByCurrentUser = YES;
                            }
                        }
                    }

                    [[TKCache sharedCache] setAttributesForPhoto:photo likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
                }

                [[NSNotificationCenter defaultCenter] postNotificationName:PAPUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:photo userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:succeeded] forKey:PTKPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey]];
            }];
            
        }];
    }];
    
}

+ (void)unlikePhotoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kPTKActivityClassKey];
    [queryExistingLikes whereKey:kPTKActivityPhotoKey equalTo:photo];
    [queryExistingLikes whereKey:kPTKActivityTypeKey equalTo:kPTKActivityTypeKey];
    [queryExistingLikes whereKey:kPTKActivityFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity delete];
            }

            if (completionBlock) {
                completionBlock(YES,nil);
            }

            // refresh cache
            PFQuery *query = [TKUtility queryForActivitiesOnPhoto:photo cachePolicy:kPFCachePolicyNetworkOnly];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {

                    NSMutableArray *likers = [NSMutableArray array];
                    NSMutableArray *commenters = [NSMutableArray array];

                    BOOL isLikedByCurrentUser = NO;

                    for (PFObject *activity in objects) {
                        if ([[activity objectForKey:kPTKActivityTypeKey] isEqualToString:kPTKActivityTypeKey]) {
                            [likers addObject:[activity objectForKey:kPTKActivityFromUserKey]];
                        } else if ([[activity objectForKey:kPTKActivityTypeKey] isEqualToString:kPTKActivityTypeComment]) {
                            [commenters addObject:[activity objectForKey:kPTKActivityFromUserKey]];
                        }

                        if ([[[activity objectForKey:kPTKActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                            if ([[activity objectForKey:kPTKActivityTypeKey] isEqualToString:kPTKActivityTypeKey]) {
                                isLikedByCurrentUser = YES;
                            }
                        }
                    }

                    [[TKCache
                      sharedCache] setAttributesForPhoto:photo likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
                }

                [[NSNotificationCenter defaultCenter] postNotificationName:PTKUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:photo userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:PTKPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey]];
            }];

        } else {
            if (completionBlock) {
                completionBlock(NO,error);
            }
        }
    }];  
}


@end
