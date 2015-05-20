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
@property NSMutableArray *arrayOfFollowers;
@property NSMutableArray *arrayOfFollowing;
@property NSMutableArray *arrayOfDiscoverContent;
@property NSMutableArray *arrayOfDiscoverUsers;

+(NSMutableArray*)loadArrayOfContent;
-(void)loadFollowers:(NSString*)userID user:(PFUser*)user completion:(void (^)(BOOL result))completionHandler;
-(void)loadFollowing:(NSString*)userID completion:(void (^)(BOOL result))completionHandler;;

-(void)loadarrayOfActivity:(User*)user completion:(void (^)(BOOL result))completionHandler;
-(void)loadArrayOfOtherUserContent:(NSMutableArray*)activity completion:(void (^)(BOOL result))completionHandler;
-(void)loadDiscoverActivity:(void (^)(BOOL result))completionHandler;
-(void)loadDiscoverUsers:(void (^)(BOOL result))completionHandler;



@end
