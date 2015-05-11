//
//  User.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/21/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <ParseUI/ParseUI.h>

#import "Photo.h"
#import "Video.h"
#import "Post.h"
#import "Link.h"

#import "TK_Manager.h"

@interface User : NSObject

@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *objectID;
@property (nonatomic,strong) NSMutableArray *arrayOfPhotos;
@property (nonatomic,strong) NSMutableArray *arrayOfVideos;
@property (nonatomic,strong) NSMutableArray *arrayOfPosts;
@property (nonatomic,strong) NSMutableArray *arrayOfLinks;
@property (nonatomic,strong) NSArray *arrayOfContent;
@property (nonatomic,strong) NSMutableArray *arrayOfUserActivity;
@property (nonatomic,strong) NSMutableArray *arrayOfFromUserActivity;
@property (nonatomic,strong) NSMutableArray *arrayOfFollowers;
@property (nonatomic,strong) NSMutableArray *arrayOfFollowing;
@property (nonatomic,strong) NSMutableArray *arrayOfNotificationComments;
@property (nonatomic,strong) NSMutableArray *arrayOfNotificationLikes;
@property (nonatomic,strong) NSMutableArray *arrayOfNotificationTags;

-(id)initWithUser:(PFUser*)userNew;

//-(NSMutableArray*)loadFollowers:(NSString*)userID;
//-(NSMutableArray*)loadFollowing:(NSString*)userID;
//-(NSMutableArray*)loadArrayOfPhotos:(NSString*)userID;
//-(NSMutableArray*)loadArrayOfVideos:(NSString*)userID;
//-(NSMutableArray*)loadArrayOfLinks:(NSString*)userID;
//-(NSMutableArray*)loadArrayOfPosts:(NSString*)userID;


@end
