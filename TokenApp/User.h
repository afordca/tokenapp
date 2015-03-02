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
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <ParseUI/ParseUI.h>

// define the protocol for the delegate
@protocol UserDelegate <NSObject>

-(void)reloadTableAfterArrayUpdate:(NSInteger)row;

@end

@interface User : NSObject
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
    PFUser *user;
    

}

@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSMutableArray *arrayOfPhotos;
@property (nonatomic,strong) NSMutableArray *arrayOfUserActivity;
@property (nonatomic,strong) NSMutableArray *arrayOfFromUserActivity;
@property (nonatomic,strong) NSMutableArray *arrayOfFollowers;
@property (nonatomic,strong) NSMutableArray *arrayOfFollowing;
@property (nonatomic,strong) NSMutableArray *arrayOfNotificationComments;
@property (nonatomic,strong) NSMutableArray *arrayOfNotificationLikes;
@property (nonatomic,strong) NSMutableArray *arrayOfNotificationTags;


@property PFUser *user;

// This is the method to access this Singleton class
+ (User *)sharedSingleton;


// define delegate property
@property id <UserDelegate>delegate;

//Array Methods
-(void)loadArrayOfFollowers;
-(void)loadArrayOfFollowing:(BOOL)update row:(NSInteger)row;
-(void)loadArrayOfPhotos;
-(void)loadArrayOfNotifications;
-(void)loadActivityToCurrentUser;
-(void)loadActivityFromCurrentUser;

//Helper Methods
-(void)setUserProfile;
-(BOOL)isFollowingFollower:(PFUser*)follower;
-(void)removeUserFromFollowing:(PFUser*)follower row:(NSInteger)row;
-(void)addUserToFollowing:(PFUser*)follower row:(NSInteger)row;
-(UIImage *)followerStatus:(PFUser *)follower;




@end