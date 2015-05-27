//
//  User.h
//  
//
//  Created by BASEL FARAG on 2/3/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <TwitterKit/TwitterKit.h>

#import "User.h"
#import "Photo.h"
#import "Video.h"
#import "Link.h"
#import "Post.h"
#import "Activity.h"
#include "Notification.h"

// define the protocol for the delegate
@protocol UserDelegate <NSObject>

-(void)reloadTableAfterArrayUpdate:(NSInteger)row;
-(void)reloadCollectionAfterArrayUpdate;

@end

@interface CurrentUser : NSObject

@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSMutableArray *arrayOfPhotos;
@property (nonatomic,strong) NSMutableArray *arrayOfVideos;
@property (nonatomic,strong) NSMutableArray *arrayOfLinks;
@property (nonatomic,strong) NSMutableArray *arrayOfPosts;
@property (nonatomic,strong) NSMutableArray *arrayOfNotifications;
@property (nonatomic,strong) NSMutableArray *arrayOfPersonalActivity;
@property (nonatomic,strong) NSMutableArray *arrayOfUserActivity;
@property (nonatomic,strong) NSMutableArray *arrayOfFollowers;
@property (nonatomic,strong) NSMutableArray *arrayOfFollowing;
@property (nonatomic,strong) NSMutableArray *arrayOfNotificationComments;
@property (nonatomic,strong) NSMutableArray *arrayOfNotificationLikes;
@property (nonatomic,strong) NSMutableArray *arrayOfNotificationTags;
@property (nonatomic,strong) NSMutableArray *arrayOfBalanceActivity;
@property (nonatomic,strong) NSMutableArray *arrayOfHomeFeedActivity;
@property (nonatomic,strong) NSMutableArray *arrayOfHomeFeedContent;
@property (nonatomic,strong) NSMutableArray *arrayOfPersonalActivityContent;

@property (strong, nonatomic)  NSString *Firstname;
@property (strong, nonatomic)  NSString *Lastname;
@property (strong, nonatomic)  NSString *Username;
@property (strong, nonatomic)  NSString *Biography;

@property (strong, nonatomic)  NSString *Email;
@property (strong, nonatomic)  NSString *Phone;
@property (strong, nonatomic)  NSString *Gender;
@property (strong, nonatomic)  NSString *Birthday;

@property BOOL switchPostPrivate;
@property BOOL switchTokensPrivate;
@property BOOL userClicked;
@property BOOL justPosted;

@property (nonatomic,weak) User *clickedUser;


@property NSNumber *numberOfTotalTokens;
@property NSNumber *numberOfPhotoTokens;
@property NSNumber *numberOfVideoTokens;
@property NSNumber *numberOfLinkTokens;
@property NSNumber *numberOfBlogTokens;
@property NSNumber *numberOfLoginBonusTokens;
@property NSNumber *numberOfInviteBonusTokens;
@property NSNumber *BalanceTransactionNumber;
@property NSNumber *runningBalance;


@property UIImage *homeFeedProfilePic;
@property UIImage *homeFeedContent;

@property PFUser *user;


// This is the method to access this Singleton class
+ (CurrentUser *)sharedSingleton;


// define delegate property
@property id <UserDelegate>delegate;

//Array Methods
-(void)loadArrayOfFollowers: (void (^)(BOOL result))completionHandler;
-(void)loadArrayOfFollowing:(BOOL)update row:(NSInteger)row completion:(void (^)(BOOL result))completionHandler;

-(void)loadHomeFeedActivity:(NSInteger)skip limit:(NSInteger)limit type:(NSString*)type completion:(void (^)(BOOL result))completionHandler;
-(void)loadHomeFeedContent:(void (^)(BOOL result))completionHandler;
-(void)loadPersonalActivityContent:(void (^)(BOOL result))completionHandler;


-(void)loadArrayOfNotifications;
-(void)loadActivityToCurrentUser;

//Helper Methods
-(void)setUserProfile;
-(BOOL)isFollowingFollower:(NSString*)follower;
-(void)removeUserFromFollowing:(User*)follower row:(NSInteger)row;
-(void)addUserToFollowing:(User*)follower row:(NSInteger)row;
-(UIImage *)followerStatus:(NSString *)follower;

//#ofViews/Tokens
-(NSNumber*)getNumberOfPhotoTokens;
-(NSNumber*)getNumberOfVideoTokens;
-(NSNumber*)getNumberOfLinkTokens;
-(NSNumber*)getNumberOfPostTokens;


@end