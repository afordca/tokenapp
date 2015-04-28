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
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <ParseUI/ParseUI.h>
#import "User.h"

// define the protocol for the delegate
@protocol ManagerDelegate <NSObject>

-(void)reloadCollectionView;

@end

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


// define delegate property
@property id <ManagerDelegate>delegate;

+(NSArray*)loadArrayOfContent:(NSMutableArray*)photos arrayOfVideos:(NSMutableArray*)videos arrayOfLinks:(NSMutableArray*)links;

+(NSMutableArray*)loadFollowers:(NSString*)userID;
+(NSMutableArray*)loadFollowing:(NSString*)userID;
+(NSMutableArray*)loadArrayOfPhotos:(NSString*)userID;
+(NSMutableArray*)loadArrayOfVideos:(NSString*)userID;
+(NSMutableArray*)loadArrayOfLinks:(NSString*)userID;
+(NSMutableArray*)loadArrayOfPosts:(NSString*)userID;

@end
