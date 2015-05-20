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

@property (nonatomic,strong) UIImage *profileImage;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *objectID;
@property (nonatomic,strong) NSString *Biography;
@property (nonatomic,strong) NSArray *arrayOfContent;
@property (nonatomic,strong) NSMutableArray *arrayOfUserActivity;
@property (nonatomic,strong) NSMutableArray *arrayOfFromUserActivity;
@property (nonatomic,strong) NSMutableArray *arrayOfFollowers;
@property (nonatomic,strong) NSMutableArray *arrayOfFollowing;
@property (nonatomic,strong) NSMutableArray *arrayOfNotificationComments;
@property (nonatomic,strong) NSMutableArray *arrayOfNotificationLikes;
@property (nonatomic,strong) NSMutableArray *arrayOfNotificationTags;

@property PFUser *pfUser;

-(id)initWithUser:(PFUser*)userNew;



@end
