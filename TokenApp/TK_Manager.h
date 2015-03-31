//
//  TK_Manager.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/26/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <ParseUI/ParseUI.h>
#import "User.h"

@interface TK_Manager : NSObject

{
    UIImage *profileImage;
    NSString *userName;
    NSMutableArray *arrayOfPhotos;
    NSMutableArray *arrayOfUserActivity;
    NSMutableArray *arrayOfFromUserActivity;
    NSMutableArray *arrayOfFollowers;
    NSMutableArray *arrayOfFollowing;
    NSMutableArray *arrayOfNotificationComments;
    NSMutableArray *arrayOfNotificationLikes;
    NSMutableArray *arrayOfNotificationTags;


}



@end
