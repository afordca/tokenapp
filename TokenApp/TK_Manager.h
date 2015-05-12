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
#import "CurrentUser.h"
#import "HomeFeedPost.h"

// define the protocol for the delegate
@protocol ManagerDelegate <NSObject>

-(void)reloadCollectionView;

@end

@interface TK_Manager : NSObject


// define delegate property
@property id <ManagerDelegate>delegate;

@property NSMutableArray *arrayOfActivity;
@property NSMutableArray *arrayOfUserContent;

+(NSMutableArray*)loadArrayOfContent;

-(void)loadarrayOfActivity:(User*)user completion:(void (^)(BOOL result))completionHandler;
-(void)loadArrayOfOtherUserContent:(NSMutableArray*)activity completion:(void (^)(BOOL result))completionHandler; ;

+(NSMutableArray*)loadFollowers:(NSString*)userID;
+(NSMutableArray*)loadFollowing:(NSString*)userID;


@end
