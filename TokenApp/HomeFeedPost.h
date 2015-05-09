//
//  HomeFeedPost.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 4/28/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Photo.h"
#import "Video.h"
#import "Link.h"
#import "Post.h"

@interface HomeFeedPost : NSObject

@property (nonatomic,strong) UIImage *userProfilePic;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *timePosted;
@property (nonatomic,strong) NSString *mediaType;
@property (nonatomic,strong) Photo *photoPost;
@property (nonatomic,strong) Post *messagePost;
@property (nonatomic,strong) Video *videoPost;
@property (nonatomic,strong) Link *linkPost;


-(id)initWithUsername:(NSString*)name profilePic:(UIImage*)profilepic timePosted:(NSString*)time photo:(Photo*)photo post:(Post*)message video:(Video*)video link:(Link*)link mediaType:(NSString*)mediatype userID:(NSString*)userID;

@end
