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
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <ParseUI/ParseUI.h>

@interface User : NSObject

@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *objectID;
@property (nonatomic,strong) NSMutableArray *arrayOfContent;
@property (nonatomic,strong) NSMutableArray *arrayOfUserActivity;
@property (nonatomic,strong) NSMutableArray *arrayOfFromUserActivity;
@property (nonatomic,strong) NSMutableArray *arrayOfFollowers;
@property (nonatomic,strong) NSMutableArray *arrayOfFollowing;
@property (nonatomic,strong) NSMutableArray *arrayOfNotificationComments;
@property (nonatomic,strong) NSMutableArray *arrayOfNotificationLikes;
@property (nonatomic,strong) NSMutableArray *arrayOfNotificationTags;

-(id)initWithUser:(PFUser*)userNew;

-(NSMutableArray*)loadFollowers:(NSString*)userID;
-(NSMutableArray*)loadFollowing:(NSString*)userID;


@end
