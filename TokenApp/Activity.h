//
//  Activity.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/21/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"
#import "Photo.h"
#import "Video.h"
#import "Post.h"
#import "Link.h"

@interface Activity : NSObject

@property (nonatomic,strong) User *fromUser;
@property (nonatomic,strong) User *toUser;
@property (nonatomic,strong) NSString *activityType;
@property  NSInteger *mediaContentCount;
@property (nonatomic,strong) NSString *typeOfMedia;

@property (nonatomic,strong) Photo *photo;
@property (nonatomic,strong) Video *video;
@property (nonatomic,strong) Post *post;
@property (nonatomic,strong) Link *link;


-(id)initWithPhoto:(User*)fromUser toUser:(User*)toUser activity:(NSString*)activityType media:(NSString*)mediaType photo:(Photo*)photo;
-(id)initWithVideo:(User*)fromUser toUser:(User*)toUser activity:(NSString*)activityType media:(NSString*)mediaType video:(Video*)video;
-(id)initWithPost:(User*)fromUser toUser:(User*)toUser activity:(NSString*)activityType media:(NSString*)mediaType post:(Post*)post;
-(id)initWithLink:(User*)fromUser toUser:(User*)toUser activity:(NSString*)activityType media:(NSString*)mediaType link:(Link*)link;


@end
