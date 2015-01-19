//
//  Constants.m
//  TokenApp
//
//  Created by BASEL FARAG on 12/18/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import "Constants.h"

#pragma mark - Launch URLs

NSString *const kTKLaunchURLHostTakePicture = @"camera";


#pragma mark - NSNotification 

NSString *const TKPhotoDetailsViewControllerUserDeletedPhotoNotification       = @"com.parse.TOKEN.photoDetailsViewController.userDeletedPhoto";
NSString *const TKTabBarControllerDidFinishImageFileUploadNotification         = @"com.parse.TOKEN.tabBarController.didFinishImageFileUploadNotification";
NSString *const TKUtilityUserLikedUnlikedPhotoCallbackFinishedNotification     = @"com.parse.TOKEN.utility.userLikedUnlikedPhotoCallbackFinished";
NSString *const TKTabBarControllerDidFinishEditingPhotoNotification            = @"com.parse.TOKEN.tabBarController.didFinishEditingPhoto";
NSString *const TKPhotoDetailsViewControllerUserCommentedOnPhotoNotification   = @"com.parse.TOKEN.photoDetailsViewController.userCommentedOnPhotoInDetailsViewNotification";


#pragma mark - NSUserDefaults
NSString *const kTKUserDefaultsActivityFeedViewControllerLastRefreshKey    = @"com.parse.Anypic.userDefaults.activityFeedViewController.lastRefresh";
NSString *const kTKUserDefaultsCacheFacebookFriendsKey                     = @"com.parse.Anypic.userDefaults.cache.facebookFriends";

#pragma mark - Activity Class
// Class key
NSString *const kPTKActivityClassKey = @"Activity";

// Field keys
NSString *const kPTKActivityTypeKey        = @"type";
NSString *const kPTKActivityFromUserKey    = @"fromUser";
NSString *const kPTKActivityToUserKey      = @"toUser";
NSString *const kPTKActivityContentKey     = @"content";
NSString *const kPTKActivityPhotoKey       = @"photo";

// Type values
NSString *const kPTKActivityTypeLike       = @"like";
NSString *const kPTKActivityTypeFollow     = @"follow";
NSString *const kPTKActivityTypeComment    = @"comment";
NSString *const kPTKActivityTypeJoined     = @"joined";

#pragma mark - User Class
// Field keys
NSString *const kTKUserDisplayNameKey                          = @"displayName";
NSString *const kPTKUserFacebookIDKey                           = @"facebookId";
NSString *const kPTKUserPhotoIDKey                              = @"photoId";
NSString *const kPTKUserProfilePicSmallKey                      = @"profilePictureSmall";
NSString *const kPTKUserProfilePicMediumKey                     = @"profilePictureMedium";
NSString *const kPTKUserFacebookFriendsKey                      = @"facebookFriends";
NSString *const kPTKUserAlreadyAutoFollowedFacebookFriendsKey   = @"userAlreadyAutoFollowedFacebookFriends";
NSString *const kPTKUserEmailKey                                = @"email";
NSString *const kPTKUserAutoFollowKey                           = @"autoFollow";

#pragma mark - Photo Class
// Class key
NSString *const kPTKPhotoClassKey = @"Photo";

// Field keys
NSString *const kPTKPhotoPictureKey         = @"image";
NSString *const kPTKPhotoThumbnailKey       = @"thumbnail";
NSString *const kPTKPhotoUserKey            = @"user";
NSString *const kPTKPhotoOpenGraphIDKey    = @"fbOpenGraphID";


#pragma mark - Cached Photo Attributes
// keys
NSString *const kPTKPhotoAttributesIsLikedByCurrentUserKey = @"isLikedByCurrentUser";
NSString *const kPTKPhotoAttributesLikeCountKey            = @"likeCount";
NSString *const kPTKPhotoAttributesLikersKey               = @"likers";
NSString *const kPTKPhotoAttributesCommentCountKey         = @"commentCount";
NSString *const kPTKPhotoAttributesCommentersKey           = @"commenters";

#pragma mark - Cached Video Attributes 
//keys
NSString *const kPTKVideoAttributesIsLikedByCurrentUserKey = @"isLikedByCurrentUser";
NSString *const kPTKVideoAttributesLikeCountKey            = @"likeCount";
NSString *const kPTKVideoAttibutesLikersKey                = @"likers";
NSString *const kPTKVideoAttributesCommentCountKey         = @"commentCount";
NSString *const kPTKVideoAttributesCommentersKey           = @"commenters";


#pragma mark - Cached User Attributes
// keys
NSString *const kPTKUserAttributesPhotoCountKey                 = @"photoCount";
NSString *const kPTKUserAttributesIsFollowedByCurrentUserKey    = @"isFollowedByCurrentUser";

#pragma mark - User Info Keys
NSString *const PTKPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey = @"liked";
NSString *const kPTKEditPhotoViewControllerUserInfoCommentKey = @"comment";

