//
//  Activity.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/21/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "Activity.h"

@implementation Activity

-(id)initWithPhoto:(User *)fromUser toUser:(User *)toUser activity:(NSString *)activityType media:(NSString *)mediaType photo:(Photo *)photo
{
    self.fromUser = fromUser;
    self.toUser = toUser;
    self.activityType = activityType;
    self.typeOfMedia = mediaType;
    self.photo = photo;
    self.video = nil;
    self.link = nil;
    self.post = nil;

    return self;
}

-(id)initWithVideo:(User *)fromUser toUser:(User *)toUser activity:(NSString *)activityType media:(NSString *)mediaType video:(Video *)video
{
    self.fromUser = fromUser;
    self.toUser = toUser;
    self.activityType = activityType;
    self.typeOfMedia = mediaType;
    self.photo = nil;
    self.video = video;
    self.link = nil;
    self.post = nil;

    return self;
}

-(id)initWithLink:(User *)fromUser toUser:(User *)toUser activity:(NSString *)activityType media:(NSString *)mediaType photo:(Link *)link
{
    self.fromUser = fromUser;
    self.toUser = toUser;
    self.activityType = activityType;
    self.typeOfMedia = mediaType;
    self.photo = nil;
    self.video = nil;
    self.link = link;
    self.post = nil;

    return self;
}

-(id)initWithPost:(User *)fromUser toUser:(User *)toUser activity:(NSString *)activityType media:(NSString *)mediaType photo:(Post *)post
{
    self.fromUser = fromUser;
    self.toUser = toUser;
    self.activityType = activityType;
    self.typeOfMedia = mediaType;
    self.photo = nil;
    self.video = nil;
    self.link = nil;
    self.post = post;

    return self;
}

@end
