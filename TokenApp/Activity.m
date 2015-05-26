//
//  Activity.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/21/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "Activity.h"
#import <ParseUI/ParseUI.h>


@implementation Activity

-(id)initWithImage:(UIImage *)image activity:(NSString *)activityType media:(NSString *)typeOfMedia photo:(Photo *)photo video:(Video *)video post:(Post *)post link:(Link *)link toUserImage:(UIImage *)toUserImage toUserName:(NSString *)toUserName
{
    self.imageContent = image;
    self.activityType = activityType;
    self.typeOfMedia = typeOfMedia;
    self.photo = photo;
    self.video = video;
    self.post = post;
    self.link = link;
    self.toUserProfilepic = toUserImage;
    self.toUserName = toUserName;

    return self;

}

@end
