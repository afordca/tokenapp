//
//  User.m
//  
//
//
//

#import "CurrentUser.h"
#import "User.h"
#import "Notification.h"
#import "HomeFeedPost.h"
#import "Activity.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#import <MediaPlayer/MediaPlayer.h>


@implementation CurrentUser
{
    CurrentUser *anotherSingle;
}


@synthesize profileImage;
@synthesize userName;
@synthesize arrayOfFollowers;
@synthesize arrayOfNotifications;
@synthesize arrayOfFollowing;
@synthesize arrayOfPhotos;
@synthesize user;
@synthesize numberOfPhotoTokens;
@synthesize arrayOfBalanceActivity;


+ (CurrentUser *)sharedSingleton
{
    static CurrentUser *single = nil;
    {
        //static dispatch_once onceToken;  * Look up
        if ( !single)
        {
            // allocate the shared instance, because it hasn't been done yet
            single = [[CurrentUser alloc] init];
        }
        return single;
    }
}

#pragma mark - LOAD ARRAY METHODS

-(void)loadArrayOfFollowers:(void (^)(BOOL))completionHandler
{
    user = [PFUser currentUser];
    self.arrayOfFollowers = [NSMutableArray new];

    PFQuery *queryFollowers = [PFQuery queryWithClassName:@"Activity"];

    [queryFollowers includeKey:@"fromUser"];
    [queryFollowers whereKey:@"type" equalTo:@"follow"];
    [queryFollowers whereKey:@"toUser" equalTo: user];
    [queryFollowers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error) {
             NSLog(@"%@",[error userInfo]);
         }
         else
         {
             for (PFObject *activity in objects)
             {
                 PFUser *pffollower = [activity objectForKey:@"fromUser"];
                 User *follower = [[User alloc]initWithUser:pffollower];

                 [self.arrayOfFollowers addObject:follower];
             }

             completionHandler(YES);
         }
     }];
}

-(void)loadArrayOfFollowing:(BOOL)update row:(NSInteger)row completion:(void (^)(BOOL))completionHandler
{
    user = [PFUser currentUser];
    self.arrayOfFollowing = [NSMutableArray new];
//

    [PFCloud callFunctionInBackground:@"Following" withParameters:@{@"objectId": user.objectId} block:^(NSArray *result, NSError *error)
     {
         if (error)
         {
             NSLog(@"%@", [error userInfo]);
         }
         else
         {
             for (PFUser *userFollowing in result)
             {
                 User *following = [[User alloc]initWithUser:userFollowing];

                 [self.arrayOfFollowing addObject:following];
             }

             completionHandler(YES);

             if (update) {
                  [self.delegate reloadTableAfterArrayUpdate:row];
             }
         }

     }];

}

-(void)loadHomeFeedContent:(void (^)(BOOL))completionHandler
{
    if (!self.arrayOfHomeFeedActivity.count)
    {
        completionHandler(YES);
    }

    // HOMEFEED CONTENT
    if (!self.arrayOfHomeFeedContent.count)
    {
        self.arrayOfHomeFeedContent = [NSMutableArray new];
    }

    for (PFObject *homeFeedActivity in self.arrayOfHomeFeedActivity)
    {
        // PHOTO
        if ([[homeFeedActivity objectForKey:@"mediaType"]isEqualToString:@"photo"])
        {
            PFFile *parseFileWithImage = [[homeFeedActivity objectForKey:@"photo"]objectForKey:@"image"];
            NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
            NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data1, NSError *connectionError)
            {

                if (connectionError)
                {
                    NSLog(@"%@",[connectionError userInfo]);
                }
                else
                {
                    PFFile *parseProfileImage = [[homeFeedActivity objectForKey:@"fromUser"]objectForKey:@"profileImage"];
                    NSURL *urlProfile = [NSURL URLWithString:parseProfileImage.url];
                    NSURLRequest *requestURLProfile = [NSURLRequest requestWithURL:urlProfile];
                    [NSURLConnection sendAsynchronousRequest:requestURLProfile queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
                     {
                         self.homeFeedContent = [UIImage imageWithData:data1];
                         self.homeFeedProfilePic = [UIImage imageWithData:data];
                         NSString *name= [homeFeedActivity objectForKey:@"username"];
                         NSString *userID = [[homeFeedActivity objectForKey:@"fromUser"]objectId];
                         NSString *photoID = [[homeFeedActivity objectForKey:@"photo"]objectId];
                         NSString *description =[[homeFeedActivity objectForKey:@"photo"]objectForKey:@"description"];
                         PFUser *userWithContent = [homeFeedActivity objectForKey:@"fromUser"];
                         NSNumber *likes = [[homeFeedActivity objectForKey:@"photo"]objectForKey:@"numberOfLikes"];
                         NSInteger numberOfLikes = likes.integerValue;

                         Photo *photo = [[Photo alloc]initWithImage:self.homeFeedContent name:name time:nil description:description photoID:photoID likes:numberOfLikes];
                         User *userContent = [[User alloc]initWithUser:userWithContent];

                         HomeFeedPost *homeFeedPost = [[HomeFeedPost alloc]initWithUsername:name profilePic:self.homeFeedProfilePic timePosted:nil photo:photo post:nil video:nil link:nil mediaType:@"photo" userID:userID user:userContent];

                         [self.arrayOfHomeFeedContent addObject:homeFeedPost];

                         if (self.arrayOfHomeFeedContent.count == self.arrayOfHomeFeedActivity.count)
                         {
                             completionHandler(YES);
                         }

                     }];
                }
            }];
    }
        // Video
        if ([[homeFeedActivity objectForKey:@"mediaType"]isEqualToString:@"video"])
        {
            PFFile *parseFileWithVideo = [[homeFeedActivity objectForKey:@"video"]objectForKey:@"video"];
            PFFile *parseProfileImage = [[homeFeedActivity objectForKey:@"fromUser"]objectForKey:@"profileImage"];
            NSURL *urlProfile = [NSURL URLWithString:parseProfileImage.url];
            NSURLRequest *requestURLProfile = [NSURLRequest requestWithURL:urlProfile];
            [NSURLConnection sendAsynchronousRequest:requestURLProfile queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
             {

                 if (connectionError)
                 {
                     NSLog(@"%@",[connectionError userInfo]);
                 }
                 else
                 {
                     NSURL *url = [NSURL URLWithString:parseFileWithVideo.url];

                     NSString *name= [homeFeedActivity objectForKey:@"username"];
                     NSString *userID = [[homeFeedActivity objectForKey:@"fromUser"]objectId];
                     NSString *videoID = [[homeFeedActivity objectForKey:@"video"]objectId];
                     NSString *videoDescription = [[homeFeedActivity objectForKey:@"video"]objectForKey:@"description"];

                     self.homeFeedProfilePic = [UIImage imageWithData:data];
                     PFUser *userWithContent = [homeFeedActivity objectForKey:@"fromUser"];

                     NSNumber *likes = [[homeFeedActivity objectForKey:@"video"]objectForKey:@"numberOfLikes"];
                     NSInteger numberOfLikes = likes.integerValue;

                     Video *video = [[Video alloc]initWithUrl:url likes:numberOfLikes videoID:videoID videoDescription:videoDescription];
                     User *userContent = [[User alloc]initWithUser:userWithContent];
         
                     HomeFeedPost *homeFeedPost = [[HomeFeedPost alloc]initWithUsername:name profilePic:self.homeFeedProfilePic timePosted:nil photo:nil post:nil video:video link:nil mediaType:@"video" userID:userID user:userContent];

                     [self.arrayOfHomeFeedContent addObject:homeFeedPost];

                     if (self.arrayOfHomeFeedContent.count == self.arrayOfHomeFeedActivity.count)
                     {
                         completionHandler(YES);
                     }
                 }
             }];
        }
        //LINK
        if ([[homeFeedActivity objectForKey:@"mediaType"]isEqualToString:@"link"])
        {

            PFFile *parseFileWithImage = [[homeFeedActivity objectForKey:@"link"]objectForKey:@"imageLink"];
            NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
            NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data1, NSError *connectionError)
             {

                 if (connectionError)
                 {
                     NSLog(@"%@",[connectionError userInfo]);
                 }
                 else
                 {
            PFFile *parseProfileImage = [[homeFeedActivity objectForKey:@"fromUser"]objectForKey:@"profileImage"];
            NSURL *urlProfile = [NSURL URLWithString:parseProfileImage.url];
            NSURLRequest *requestURLProfile = [NSURLRequest requestWithURL:urlProfile];
            [NSURLConnection sendAsynchronousRequest:requestURLProfile queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
             {
                 if (connectionError)
                 {
                     NSLog(@"%@",[connectionError userInfo]);
                 }
                 else
                 {
                     NSString *name= [homeFeedActivity objectForKey:@"username"];
                     NSString *userID = [[homeFeedActivity objectForKey:@"fromUser"]objectId];
                     NSString *linkID = [[homeFeedActivity objectForKey:@"link"]objectId];

                     NSString *linkDescription = [[homeFeedActivity objectForKey:@"link"]objectForKey:@"description"];

                     self.homeFeedProfilePic = [UIImage imageWithData:data];
                     UIImage *imageLink = [UIImage imageWithData:data1];

                     PFUser *userWithContent = [homeFeedActivity objectForKey:@"fromUser"];
                     NSString *linkURL = [[homeFeedActivity objectForKey:@"link"]objectForKey:@"url"];
                     NSString *linkTitle = [[homeFeedActivity objectForKey:@"link"]objectForKey:@"linkTitle"];
                     NSNumber *likes = [[homeFeedActivity objectForKey:@"link"]objectForKey:@"numberOfLikes"];
                     NSInteger numberOfLikes = likes.integerValue;

                     Link *link = [[Link alloc]initWithUrl:linkURL linkImage:imageLink linkDescription:linkDescription linkTitle:linkTitle likes:numberOfLikes linkID:linkID];
                     User *userContent = [[User alloc]initWithUser:userWithContent];

                     HomeFeedPost *homeFeedPost = [[HomeFeedPost alloc]initWithUsername:name profilePic:self.homeFeedProfilePic timePosted:nil photo:nil post:nil video:nil link:link mediaType:@"link" userID:userID user:userContent];

                     [self.arrayOfHomeFeedContent addObject:homeFeedPost];

                     if (self.arrayOfHomeFeedContent.count == self.arrayOfHomeFeedActivity.count)
                     {
                         completionHandler(YES);
                     }
                 }
            }];
                 }
             }];
        }

        //POST
        if ([[homeFeedActivity objectForKey:@"mediaType"]isEqualToString:@"note"])
        {
            PFFile *parseProfileImage = [[homeFeedActivity objectForKey:@"fromUser"]objectForKey:@"profileImage"];
            NSURL *urlProfile = [NSURL URLWithString:parseProfileImage.url];
            NSURLRequest *requestURLProfile = [NSURLRequest requestWithURL:urlProfile];
            [NSURLConnection sendAsynchronousRequest:requestURLProfile queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
             {
                 if (connectionError)
                 {
                     NSLog(@"%@",[connectionError userInfo]);
                 }
                 else
                 {
                     NSString *name= [homeFeedActivity objectForKey:@"username"];
                     NSString *userID = [[homeFeedActivity objectForKey:@"fromUser"]objectId];
                     self.homeFeedProfilePic = [UIImage imageWithData:data];

                     NSString *noteID = [[homeFeedActivity objectForKey:@"note"]objectId];
                     NSString *postMessage = [[homeFeedActivity objectForKey:@"note"]objectForKey:@"note"];
                     NSString *postHeader = [[homeFeedActivity objectForKey:@"note"]objectForKey:@"description"];
                     PFUser *userWithContent = [homeFeedActivity objectForKey:@"fromUser"];
                     NSNumber *likes = [[homeFeedActivity objectForKey:@"note"]objectForKey:@"numberOfLikes"];
                     NSInteger numberOfLikes = likes.integerValue;

                     Post *post = [[Post alloc]initWithDescription:postMessage header:postHeader likes:numberOfLikes postID:noteID];
                     User *userContent = [[User alloc]initWithUser:userWithContent];

                     HomeFeedPost *homeFeedPost = [[HomeFeedPost alloc]initWithUsername:name profilePic:self.homeFeedProfilePic timePosted:nil photo:nil post:post video:nil link:nil mediaType:@"post" userID:userID user:userContent];

                     [self.arrayOfHomeFeedContent addObject:homeFeedPost];

                     if (self.arrayOfHomeFeedContent.count == self.arrayOfHomeFeedActivity.count)
                     {
                         completionHandler(YES);
                     }

                 }
             }];
        }
    }
}

-(void)loadPersonalActivityContent:(void (^)(BOOL))completionHandler
{
    if (!self.arrayOfPersonalActivity.count)
    {
        completionHandler(YES);
    }

        self.arrayOfPersonalActivityContent = [NSMutableArray new];


    for (PFObject *personalActivity in self.arrayOfPersonalActivity)
    {
        //Following Activity
        if ([[personalActivity objectForKey:@"type"]isEqual:@"followed"])
        {
            NSString *followedName = [[personalActivity objectForKey:@"toUser"]username];
            NSString *activity = [personalActivity objectForKey:@"type"];
            NSString *mediaType = [personalActivity objectForKey:@"mediaType"];
            PFFile *profileImageFile = [[personalActivity objectForKey:@"toUser"]objectForKey:@"profileImage"];
            PFImageView *imageView = [PFImageView new];
            imageView.file = profileImageFile;
            [imageView loadInBackground:^(UIImage *image, NSError *error)
             {
                 Activity *activityFollow = [[Activity alloc]initWithImage:nil activity:activity media:mediaType photo:nil video:nil post:nil link:nil toUserImage:image toUserName:followedName];

                 [self.arrayOfPersonalActivityContent addObject:activityFollow];

                 if (self.arrayOfPersonalActivityContent.count == self.arrayOfPersonalActivity.count)
                 {
                     completionHandler(YES);
                 }

             }];
        }
         else if ([[personalActivity objectForKey:@"mediaType"]isEqual:@"photo"]) {
                // Add Photo Logic
                NSString *followedName = [[personalActivity objectForKey:@"toUser"]username];
                NSString *activity = [personalActivity objectForKey:@"type"];
                NSString *mediaType = [personalActivity objectForKey:@"mediaType"];
                PFFile *contentImageFile = [[personalActivity objectForKey:@"photo"]objectForKey:@"image"];
                PFImageView *imageView = [PFImageView new];
                imageView.file = contentImageFile;
                [imageView loadInBackground:^(UIImage *image, NSError *error)
                 {
                     NSString *name= [personalActivity objectForKey:@"username"];
                     NSString *photoID = [[personalActivity objectForKey:@"photo"]objectId];
                     NSString *description =[[personalActivity objectForKey:@"photo"]objectForKey:@"description"];
                     NSNumber *likes = [[personalActivity objectForKey:@"photo"]objectForKey:@"numberOfLikes"];
                     NSInteger numberOfLikes = likes.integerValue;

                     Photo *photo = [[Photo alloc]initWithImage:image name:name time:nil description:description photoID:photoID likes:numberOfLikes];

                     Activity *activityFollow = [[Activity alloc]initWithImage:image activity:activity media:mediaType photo:photo video:nil post:nil link:nil toUserImage:nil toUserName:followedName];

                     [self.arrayOfPersonalActivityContent addObject:activityFollow];

                     if (self.arrayOfPersonalActivityContent.count == self.arrayOfPersonalActivity.count)
                     {
                         completionHandler(YES);
                     }
                     
                 }];
            }
         else if ([[personalActivity objectForKey:@"mediaType"]isEqual:@"video"]) {
                // Add Video Logic
                NSString *followedName = [[personalActivity objectForKey:@"toUser"]username];
                NSString *activity = [personalActivity objectForKey:@"type"];
                NSString *mediaType = [personalActivity objectForKey:@"mediaType"];
                PFFile *parseFileWithVideo = [[personalActivity objectForKey:@"video"]objectForKey:@"video"];

                NSURL *url = [NSURL URLWithString:parseFileWithVideo.url];

                UIImage *thumbnail = nil;
                AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
                AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                generator.appliesPreferredTrackTransform = YES;
                NSError *error = nil;
                CMTime time = CMTimeMake(0, 1); // 3/1 = 3 second(s)
                CGImageRef imgRef = [generator copyCGImageAtTime:time actualTime:nil error:&error];
                if (error != nil)
                    NSLog(@"%@: %@", self, error);
                thumbnail = [[UIImage alloc] initWithCGImage:imgRef];
                CGImageRelease(imgRef);

                NSString *videoID = [[personalActivity objectForKey:@"video"]objectId];
                NSString *videoDescription = [[personalActivity objectForKey:@"video"]objectForKey:@"description"];
                NSNumber *likes = [[personalActivity objectForKey:@"video"]objectForKey:@"numberOfLikes"];
                NSInteger numberOfLikes = likes.integerValue;

                Video *video = [[Video alloc]initWithUrl:url likes:numberOfLikes videoID:videoID videoDescription:videoDescription];

                Activity *activityFollow = [[Activity alloc]initWithImage:thumbnail activity:activity media:mediaType photo:nil video:video post:nil link:nil toUserImage:nil toUserName:followedName];

                [self.arrayOfPersonalActivityContent addObject:activityFollow];

                if (self.arrayOfPersonalActivityContent.count == self.arrayOfPersonalActivity.count)
                {
                    completionHandler(YES);
                }

            }
          else if ([[personalActivity objectForKey:@"mediaType"]isEqual:@"link"]) {
                // Add Link Logic

              NSString *linkID = [[personalActivity objectForKey:@"link"]objectId];
              NSString *linkDescription = [[personalActivity objectForKey:@"link"]objectForKey:@"description"];
              NSString *followedName = [[personalActivity objectForKey:@"toUser"]username];
              NSString *activity = [personalActivity objectForKey:@"type"];
              NSString *mediaType = [personalActivity objectForKey:@"mediaType"];
              NSString *linkURL = [[personalActivity objectForKey:@"link"]objectForKey:@"url"];
              NSString *linkTitle = [[personalActivity objectForKey:@"link"]objectForKey:@"linkTitle"];
              NSNumber *likes = [[personalActivity objectForKey:@"link"]objectForKey:@"numberOfLikes"];
              NSInteger numberOfLikes = likes.integerValue;

                PFFile *parseFileWithImage = [[personalActivity objectForKey:@"link"]objectForKey:@"imageLink"];
                NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
                NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
                [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data1, NSError *connectionError)
                 {

                     if (connectionError)
                     {
                         NSLog(@"%@",[connectionError userInfo]);
                     }
                     else
                     {
                         UIImage *imageLink = [UIImage imageWithData:data1];

                         Link *link = [[Link alloc]initWithUrl:linkURL linkImage:imageLink linkDescription:linkDescription linkTitle:linkTitle likes:numberOfLikes linkID:linkID];

                         Activity *activityFollow = [[Activity alloc]initWithImage:imageLink activity:activity media:mediaType photo:nil video:nil post:nil link:link toUserImage:nil toUserName:followedName];

                         [self.arrayOfPersonalActivityContent addObject:activityFollow];

                         if (self.arrayOfPersonalActivityContent.count == self.arrayOfPersonalActivity.count)
                         {
                             completionHandler(YES);
                         }
                     }
                 }];
            }
            else if ([[personalActivity objectForKey:@"mediaType"]isEqual:@"note"]) {
                // Add Note Logic
                NSString *activity = [personalActivity objectForKey:@"type"];
                NSString *mediaType = [personalActivity objectForKey:@"mediaType"];
                NSString *noteID = [[personalActivity objectForKey:@"note"]objectId];
                NSString *postMessage = [[personalActivity objectForKey:@"note"]objectForKey:@"note"];
                NSString *postHeader = [[personalActivity objectForKey:@"note"]objectForKey:@"description"];
                NSNumber *likes = [[personalActivity objectForKey:@"note"]objectForKey:@"numberOfLikes"];
                NSInteger numberOfLikes = likes.integerValue;

                PFFile *profileImageFile = [[personalActivity objectForKey:@"toUser"]objectForKey:@"profileImage"];
                PFImageView *imageView = [PFImageView new];
                imageView.file = profileImageFile;
                [imageView loadInBackground:^(UIImage *image, NSError *error)
                 {
                     Post *post = [[Post alloc]initWithDescription:postMessage header:postHeader likes:numberOfLikes postID:noteID];

                     Activity *activityFollow = [[Activity alloc]initWithImage:nil activity:activity media:mediaType photo:nil video:nil post:post link:nil toUserImage:image toUserName:nil];

                     [self.arrayOfPersonalActivityContent addObject:activityFollow];

                     if (self.arrayOfPersonalActivityContent.count == self.arrayOfPersonalActivity.count)
                     {
                         completionHandler(YES);
                     }
                 }];
            }
    }
    
}


-(void)loadHomeFeedActivity:(NSInteger)skip limit:(NSInteger)limit type:(NSString *)type completion:(void (^)(BOOL))completionHandler
{
    PFQuery *queryForActivity = [PFQuery queryWithClassName:@"Activity"];

    //HomeFeed Activity
    if ([type isEqualToString:@"home"])
    {
        self.arrayOfHomeFeedActivity = [NSMutableArray new];
        NSMutableArray *arrayOfUsernameFollowing = [NSMutableArray new];
        NSString *currentUsername = [[PFUser currentUser]username];
        for (User *following in self.arrayOfFollowing)
        {
            [arrayOfUsernameFollowing addObject:following.userName];
        }
        [arrayOfUsernameFollowing addObject:currentUsername];
        [queryForActivity whereKey:@"type" equalTo:@"posted"];
        [queryForActivity whereKey:@"username" containedIn:arrayOfUsernameFollowing];
    }

    else
    {
        //Personal Activity
        self.arrayOfPersonalActivity = [NSMutableArray new];
        PFUser *userActivity = [PFUser currentUser];
        [queryForActivity whereKey:@"fromUser" equalTo:userActivity];
    }

    [queryForActivity setLimit:limit];
    [queryForActivity setSkip:skip];
    [queryForActivity orderByDescending:@"createdAt"];
    [queryForActivity includeKey:@"fromUser"];
    [queryForActivity includeKey: @"toUser"];
    [queryForActivity includeKey:@"photo"];
    [queryForActivity includeKey:@"video"];
    [queryForActivity includeKey:@"link"];
    [queryForActivity includeKey:@"note"];

    [queryForActivity findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             for (PFObject *activity in objects)
             {
                 if ([type isEqualToString:@"home"])
                 {
                     [self.arrayOfHomeFeedActivity addObject:activity];
                 }
                 else
                 {
                     [self.arrayOfPersonalActivity addObject:activity];
                 }
             }

             if (!objects.count) {
                 completionHandler(NO);

             }
             else
             {

             completionHandler(YES);
             }
         }
     }];
}

#pragma mark - User Helper Methods

-(void)setUserProfile
{
        user = [PFUser currentUser];
        self.userClicked = NO;
        //Loading Profile Image
        PFFile *profileImageFile = [user objectForKey:@"profileImage"];
        PFImageView *imageView = [PFImageView new];
        imageView.file = profileImageFile;
        [imageView loadInBackground:^(UIImage *image, NSError *error) {
    
            //Setting image to singleton class USER
            self.profileImage = image;
    
            //Setting Username to singleton class USER
            if ([user objectForKey:@"username"])
            {
                self.userName = [user objectForKey:@"username"];
            } else
            {
                self.userName = user.username;
            }
            self.userID = user.objectId;
            self.Firstname = [user objectForKey:@"Firstname"];
            self.Lastname = [user objectForKey:@"Lastname"];
            self.Phone = [user objectForKey:@"Phone"];
            self.Email = [user objectForKey:@"email"];
            self.Biography = [user objectForKey:@"Biography"];
            self.Birthday = [user objectForKey:@"Birthday"];
            self.Gender = [user objectForKey: @"Gender"];
            self.switchPostPrivate = [[user objectForKey:@"PostPrivate"]boolValue];
            self.switchTokensPrivate = [[user objectForKey:@"TokensPrivate"]boolValue];
    
        }];
}

-(BOOL)isFollowingFollower:(NSString *)follower
{
    // Determine if Current User is following follower
    for (User *userFollowed in self.arrayOfFollowing)
    {
        if ([follower isEqual:userFollowed.objectID])
        {
            return YES;
        }
    }
    return NO;
}

-(void)removeUserFromFollowing:(User *)follower row:(NSInteger)row
{
    // Remove follower from relation
    user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"Following"];

    PFQuery *queryUser = [PFUser query];
    [queryUser whereKey:@"objectId" equalTo:follower.objectID];
    PFObject *userFollower = [queryUser getFirstObject];

    [relation removeObject:userFollower];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"%@",[error userInfo]);
        }
        else
        {
            NSLog(@"User has been removed from Following");
            [self loadArrayOfFollowing:YES row:row completion:^(BOOL result)
            {

            }];
        }

    }];
    
}


-(void)addUserToFollowing:(User *)follower row:(NSInteger)row
{
    // Add follower to relation
    user = [PFUser currentUser];
    PFRelation *relationFollowing = [user relationForKey:@"Following"];

    PFQuery *queryUser = [PFUser query];
    [queryUser whereKey:@"objectId" equalTo:follower.objectID];

    PFObject *userFollower = [queryUser getFirstObject];
    [relationFollowing addObject:userFollower];

    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"%@",[error userInfo]);
        }
        else
        {
            NSLog(@"User has been added to Following");
            NSLog(@"Current User is now a follower");

            [self loadArrayOfFollowing:YES row:row completion:^(BOOL result) {

            }];
        }

        [self.delegate reloadTableAfterArrayUpdate:row];

    }];
    
}

-(UIImage *)followerStatus:(NSString *)follower
{
    BOOL isFollowingFollower = [self isFollowingFollower:follower];

    if (isFollowingFollower)
    {
        return  [UIImage imageNamed:@"Following"];
    }
    else
    {
        return  [UIImage imageNamed:@"FollowAdd"];
    }
}

-(void)loadArrayOfNotifications
{
    self.arrayOfNotificationComments = [NSMutableArray new];
    self.arrayOfNotificationLikes = [NSMutableArray new];
    self.arrayOfNotificationTags = [NSMutableArray new];

    for (PFObject *object in self.arrayOfUserActivity)
    {
        PFUser *toUser = [object objectForKey:@"toUser"];
        NSString *stringType = [object objectForKey:@"type"];
        if ([toUser.objectId isEqual:user.objectId] && [stringType isEqualToString:@"commented on"])
        {
            //Creating Instance
            Notification *notificationComments = [Notification new];

            //Pull fromUserProfile Pic
            PFUser *fromUser = [object objectForKey:@"fromUser"];
            PFFile *parseFileWithImage = [fromUser objectForKey:@"profileImage"];
            NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
            NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
             {
                 //Setting Nofication Object properties
                 notificationComments.imageProfilePic = [UIImage imageWithData:data];
                 notificationComments.stringUsername = [fromUser objectForKey:@"username"];
                 notificationComments.stringType = [object objectForKey:@"type"];
                 notificationComments.stringMediaType = [object objectForKey:@"mediaType"];

                 //Adding Notification Object to Array
                 [self.arrayOfNotificationComments addObject:notificationComments];
             }];
        }
        else if ([toUser.objectId isEqual:user.objectId] && [stringType isEqualToString:@"tagged"])
        {
            //Creating Instance
            Notification *notificationTagged = [Notification new];

            //Pull fromUserProfile Pic
            PFUser *fromUser = [object objectForKey:@"fromUser"];
            PFFile *parseFileWithImage = [fromUser objectForKey:@"profileImage"];
            NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
            NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
             {
                 //Setting Nofication Object properties
                 notificationTagged.imageProfilePic = [UIImage imageWithData:data];
                 notificationTagged.stringUsername = [fromUser objectForKey:@"username"];
                 notificationTagged.stringType = [object objectForKey:@"type"];
                 notificationTagged.stringMediaType = [object objectForKey:@"mediaType"];

                 //Adding Notification Object to Array
                 [self.arrayOfNotificationTags addObject:notificationTagged];
             }];

        }
        else if ([toUser.objectId isEqual:user.objectId] && [stringType isEqualToString:@"liked"])
        {
            //Creating Instance
            Notification *notificationLikes = [Notification new];

            //Pull fromUserProfile Pic
            PFUser *fromUser = [object objectForKey:@"fromUser"];
            PFFile *parseFileWithImage = [fromUser objectForKey:@"profileImage"];
            NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
            NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
             {
                 //Setting Nofication Object properties
                 notificationLikes.imageProfilePic = [UIImage imageWithData:data];
                 notificationLikes.stringUsername = [fromUser objectForKey:@"username"];
                 notificationLikes.stringType = [object objectForKey:@"type"];
                 notificationLikes.stringMediaType = [object objectForKey:@"mediaType"];

                 //Adding Notification Object to Array
                 [self.arrayOfNotificationLikes addObject:notificationLikes];
             }];
            
        }
        
    }

}

-(void)loadActivityToCurrentUser
{
    user = [PFUser currentUser];
    self.arrayOfUserActivity = [NSMutableArray new];
    PFQuery *queryForActivity = [PFQuery queryWithClassName:@"Activity"];
    [queryForActivity whereKey:@"toUser" equalTo:user];
    [queryForActivity includeKey:@"fromUser"];
    [queryForActivity includeKey: @"toUser"];
    [queryForActivity includeKey:@"photo"];
    [queryForActivity includeKey:@"video"];
    [queryForActivity includeKey:@"link"];
    [queryForActivity includeKey:@"note"];
    [queryForActivity findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@",[error userInfo]);
        }
        else{

            for (PFObject *activity in objects)
            {
                [self.arrayOfUserActivity addObject:activity];
            }
        }
        [self loadArrayOfNotifications];
    }];
}

@end