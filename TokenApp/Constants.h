//
//  Constants.h
//  
//
//  Created by BASEL FARAG on 12/18/14.
//
//
#import <Foundation/Foundation.h>

//Reserve space for TabBarEnum


#pragma mark - NSUserDefaults
extern NSString *const kTKUserDefaultsActivityFeedViewControllerLastRefreshKey;
extern NSString *const kTKUserDefaultsCacheFacebookFriendsKey;

#pragma mark - Launch URLs
extern NSString *const kTKLaunchURLHostTakePicture;


#pragma mark - PFObject Activity Class
// Class key
extern NSString *const kPTKActivityClassKey;

// Field keys
extern NSString *const kPTKActivityTypeKey;
extern NSString *const kPTKActivityFromUserKey;
extern NSString *const kPTKActivityToUserKey;
extern NSString *const kPTKActivityContentKey;
extern NSString *const kPTKActivityPhotoKey;

// Type values
extern NSString *const kPTKActivityTypeLike;
extern NSString *const kPTKActivityTypeFollow;
extern NSString *const kPTKActivityTypeComment;
extern NSString *const kPTKActivityTypeJoined;

#pragma mark - PFObject User Class
// Field keys
extern NSString *const kTKUserDisplayNameKey;
extern NSString *const kPTKUserFacebookIDKey;
extern NSString *const kPTKUserPhotoIDKey;
extern NSString *const kPTKUserProfilePicSmallKey;
extern NSString *const kPTKUserProfilePicMediumKey;
extern NSString *const kPTKUserFacebookFriendsKey;
extern NSString *const kPTKUserAlreadyAutoFollowedFacebookFriendsKey;
extern NSString *const kTKPUserEmailKey;
extern NSString *const kPTKPUserAutoFollowKey;

#pragma mark - PFObject Photo Class
// Class key
extern NSString *const kPTKPhotoClassKey;

// Field keys
extern NSString *const kPTKPhotoPictureKey;
extern NSString *const kPTKPhotoThumbnailKey;
extern NSString *const kPTKPhotoUserKey;
extern NSString *const kPTKPhotoOpenGraphIDKey;

#pragma mark - Cached Photo Attributes
// keys
extern NSString *const kPTKPhotoAttributesIsLikedByCurrentUserKey;
extern NSString *const kPTKPhotoAttributesLikeCountKey;
extern NSString *const kPTKPhotoAttributesLikersKey;
extern NSString *const kPTKPhotoAttributesCommentCountKey;
extern NSString *const kPTKPhotoAttributesCommentersKey;

#pragma mark - Cached User Attributes
// keys
extern NSString *const kPTKUserAttributesPhotoCountKey;
extern NSString *const kPTKUserAttributesIsFollowedByCurrentUserKey;


#pragma mark - User Info Keys
extern NSString *const PTKPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey;
extern NSString *const kPTKEditPhotoViewControllerUserInfoCommentKey;

#pragma mark - NSNotificaton 
extern NSString *const PTKPhotoDetailsViewControllerUserDeletedPhotoNotification;
extern NSString *const PTKTabBarControllerDidFinishEditingPhotoNotification;
extern NSString *const PAPUtilityUserLikedUnlikedPhotoCallbackFinishedNotification;

#pragma mark - NSNotification
extern NSString *const TKAppDelegateApplicationDidReceiveRemoteNotification;
extern NSString *const TKUtilityUserFollowingChangedNotification;
extern NSString *const TKUtilityUserLikedUnlikedPhotoCallbackFinishedNotification;
extern NSString *const TKUtilityDidFinishProcessingProfilePictureNotification;
extern NSString *const TKTabBarControllerDidFinishEditingPhotoNotification;
extern NSString *const TKTabBarControllerDidFinishImageFileUploadNotification;
extern NSString *const TKPhotoDetailsViewControllerUserDeletedPhotoNotification;
extern NSString *const TKPhotoDetailsViewControllerUserLikedUnlikedPhotoNotification;
extern NSString *const TKPhotoDetailsViewControllerUserCommentedOnPhotoNotification;



