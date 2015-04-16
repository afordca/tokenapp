//
//  TKCache.h
//  TokenApp
//
//  Created by BASEL FARAG on 12/18/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

//The purpose of this Support file is to provide custom caching behavior that can be used to quickly display up to date information about media. When the current user likes or comment on a given media we manually update the local cache as soon as the request is sent. This allows us to propogate the model change throughout the app without need to wait for the initial save request to finish and then refreshing the content.
//So for example we can manually manage the like and comment information of images so that the UI stays responsive and accurate when the user likes and comments on photos. 

#import <Foundation/Foundation.h>
#import "Macros.h"

@interface TKCache : NSObject

+ (id)sharedCache;

- (void)clear;
- (void)setAttributesForPhoto:(PFObject *)photo likers:(NSArray *)likers commenters:(NSArray *)commenters likedByCurrentUser:(BOOL)likedByCurrentUser;
-(void)setAttributesForVideo:(PFObject *)video likers:(NSArray *)likers commenters:(NSArray *)commenters likedByCurrentUser:(BOOL)likedByCurrentUser;


#pragma Attributes for photo

- (NSDictionary *)attributesForPhoto:(PFObject *)photo;
- (NSNumber *)likeCountForPhoto:(PFObject *)photo;
- (NSNumber *)commentCountForPhoto:(PFObject *)photo;
- (NSArray *)likersForPhoto:(PFObject *)photo;
- (NSArray *)commentersForPhoto:(PFObject *)photo;
- (void)setPhotoIsLikedByCurrentUser:(PFObject *)photo liked:(BOOL)liked;
- (BOOL)isPhotoLikedByCurrentUser:(PFObject *)photo;
- (void)incrementLikerCountForPhoto:(PFObject *)photo;
- (void)decrementLikerCountForPhoto:(PFObject *)photo;
- (void)incrementCommentCountForPhoto:(PFObject *)photo;
- (void)decrementCommentCountForPhoto:(PFObject *)photo;

#pragma Attributes for video

-(NSDictionary *)attributesForVideo:(PFObject *)video;
-(NSNumber *)likeCountForVideo:(PFObject *)video;
- (NSNumber *)commentCountForVideo:(PFObject *)video;
- (NSArray *)likersForVideo:(PFObject *)video;
- (NSArray *)commentersForVideo:(PFObject *)video;
- (void)setVideoIsLikedByCurrentUser:(PFObject *)video liked:(BOOL)liked;
- (BOOL)isVideoLikedByCurrentUser:(PFObject *)video;
- (void)incrementLikerCountForVideo:(PFObject *)video;
- (void)decrementLikerCountForVideo:(PFObject *)video;
- (void)incrementCommentCountForVideo:(PFObject *)video;
- (void)decrementCommentCountForVideo:(PFObject *)video;

#pragma Attributes for Post 

//-(NSDictionary *)attributesForVideo:(PFObject *)video;
//-(NSNumber *)likeCountForVideo:(PFObject *)video;
//- (NSNumber *)commentCountForVideo:(PFObject *)video;
//- (NSArray *)likersForVideo:(PFObject *)video;
//- (NSArray *)commentersForVideo:(PFObject *)video;
//- (void)setVideoIsLikedByCurrentUser:(PFObject *)video liked:(BOOL)liked;
//- (BOOL)isVideoLikedByCurrentUser:(PFObject *)video;
//- (void)incrementLikerCountForVideo:(PFObject *)video;
//- (void)decrementLikerCountForVideo:(PFObject *)video;
//- (void)incrementCommentCountForVideo:(PFObject *)video;
//- (void)decrementCommentCountForVideo:(PFObject *)video;

#pragma Attributes for Link


- (NSDictionary *)attributesForUser:(PFUser *)user;
- (NSNumber *)photoCountForUser:(PFUser *)user;
- (BOOL)followStatusForUser:(PFUser *)user;
- (void)setPhotoCount:(NSNumber *)count user:(PFUser *)user;
- (void)setVideoCount:(NSNumber *)count user:(PFUser *)user;
- (void)setNoteCount: (NSNumber *)count user:(PFUser *)user;
- (void)setLinkCount: (NSNumber *)count user:(PFUser *)user;
- (void)setFollowStatus:(BOOL)following user:(PFUser *)user;

- (void)setFacebookFriends:(NSArray *)friends;
- (NSArray *)facebookFriends;

@end
