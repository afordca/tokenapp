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
#import <PFFacebookUtils.h>
#import "UIImage+ResizeAdditions.h"

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

                [[NSNotificationCenter defaultCenter] postNotificationName:TKUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:photo userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:succeeded] forKey:PTKPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey]];
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

                [[NSNotificationCenter defaultCenter] postNotificationName:TKUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:photo userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:PTKPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey]];
            }];

        } else {
            if (completionBlock) {
                completionBlock(NO,error);
            }
        }
    }];  
}

+ (BOOL)userHasValidFacebookData:(PFUser *)user {
    // Check that PFUser has valid fbid that matches current FBSessions userId
    NSString *facebookId = [user objectForKey:kPTKUserFacebookIDKey];
    return (facebookId && facebookId.length > 0 && [facebookId isEqualToString:[[[PFFacebookUtils session] accessTokenData] userID]]);
}

+ (void)processFacebookProfilePictureData:(NSData *)newProfilePictureData {
    NSLog(@"Processing profile picture of size: %@", @(newProfilePictureData.length));
    if (newProfilePictureData.length == 0) {
        return;
    }

    UIImage *image = [UIImage imageWithData:newProfilePictureData];

    UIImage *mediumImage = [image thumbnailImage:280 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
    UIImage *smallRoundedImage = [image thumbnailImage:64 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationLow];

    NSData *mediumImageData = UIImageJPEGRepresentation(mediumImage, 0.5); // using JPEG for larger pictures
    NSData *smallRoundedImageData = UIImagePNGRepresentation(smallRoundedImage);

    if (mediumImageData.length > 0) {
        PFFile *fileMediumImage = [PFFile fileWithData:mediumImageData];
        [fileMediumImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[PFUser currentUser] setObject:fileMediumImage forKey:kPTKUserProfilePicMediumKey];
                [[PFUser currentUser] saveInBackground];
            }
        }];
    }

    if (smallRoundedImageData.length > 0) {
        PFFile *fileSmallRoundedImage = [PFFile fileWithData:smallRoundedImageData];
        [fileSmallRoundedImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[PFUser currentUser] setObject:fileSmallRoundedImage forKey:kPTKUserProfilePicMediumKey];
                [[PFUser currentUser] saveInBackground];
            }
        }];
    }
    NSLog(@"Processed profile picture");
}



@end
