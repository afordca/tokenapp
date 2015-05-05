//
//  HomeFeedPost.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 4/28/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "HomeFeedPost.h"

@implementation HomeFeedPost

-(id)initWithUsername:(NSString *)name profilePic:(UIImage *)profilepic timePosted:(NSString *)time contentImage:(UIImage *)contentImage postMessage:(NSString *)message videoURL:(NSURL *)video linkURL:(NSString *)link mediaType:(NSString *)mediatype
{
    self.userName = name;
    self.userProfilePic = profilepic;
    self.timePosted = time;
    self.contentImage = contentImage;
    self.postMessage = message;
    self.videoURL = video;
    self.linkURL = link;
    self.mediaType = mediatype;

    return self;
}

@end
