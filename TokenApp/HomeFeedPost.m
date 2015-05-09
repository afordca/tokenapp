//
//  HomeFeedPost.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 4/28/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "HomeFeedPost.h"

@implementation HomeFeedPost

-(id)initWithUsername:(NSString *)name profilePic:(UIImage *)profilepic timePosted:(NSString *)time photo:(Photo *)photo post:(Post *)message video:(Video *)video link:(Link *)link mediaType:(NSString *)mediatype userID:(NSString *)userID
{
    self.userName = name;
    self.userID = userID;
    self.userProfilePic = profilepic;
    self.timePosted = time;
    self.photoPost = photo;
    self.videoPost = video;
    self.linkPost = link;
    self.messagePost = message;
    self.mediaType = mediatype;

    return self;
}

@end
