//
//  AppDelegate.m
//  TokenApp
//
//  Created by Basel Farag on 12/5/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//



#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
#import "Reachability.h"
#import "TKHomeViewController.h"
#import "TKWelcomeViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "TKCache.h"
#import "Constants.h"
#import "TKTabBarController.h"
#import "TKActivityFeedViewController.h"
#import "ProfilePersonalViewController.h"
#import "CreateContentViewController.h"
#import "BalanceTableViewController.h"

@interface AppDelegate ()



@end

@implementation AppDelegate

// [Parse setApplicationId:@"dNPSXSwJgJXVxTxkbta8EmoFFouOI4TIXlO1kTiz"
//clientKey:@"Dbxo2R7VxPwOv6ub5tQ9qK3sWwinkBCUQSqyUld3"];

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"dNPSXSwJgJXVxTxkbta8EmoFFouOI4TIXlO1kTiz"
                  clientKey:@"Dbxo2R7VxPwOv6ub5tQ9qK3sWwinkBCUQSqyUld3"];

    

    //Twitter setup
    [PFTwitterUtils initializeWithConsumerKey:@"zZ6XjwBvVEKbin2fr69ocsUqv"
                            consumerSecret:@"MOOl0dai4uxW6mIpEOBH1ogweVa2XNmiCaJwtR2NDathdAs0mk"];
    //Facebook setup
    [PFFacebookUtils initializeFacebook];

    ///Parse analytics
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    // Register for Push Notitications, if running iOS 8
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotifications];
    }

    [self SetUser];

    return YES;
}

- (BOOL)isParseReachable {
    return self.networkStatus != NotReachable;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    [self SetUser];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

-(void)SetUser
{
    PFUser *user = [PFUser currentUser];
    singleUser = [User sharedSingleton];
    singleUser.arrayOfPhotos = [NSMutableArray new];

    //Loading Profile Image
    PFFile *profileImageFile = [user objectForKey:@"profileImage"];
    PFImageView *imageView = [PFImageView new];
    imageView.file = profileImageFile;

    [imageView loadInBackground:^(UIImage *image, NSError *error) {

        //Setting image to singleton class USER

        singleUser.profileImage = image;

        //Setting Username to singleton class USER
        if ([user objectForKey:@"username"]) {
            singleUser.userName = [user objectForKey:@"username"];
        } else {
            singleUser.userName = user.username;

        }

    }];

 //   Loading Array of photos and setting it in singleton class USER

    PFQuery *queryForUserContent = [PFQuery queryWithClassName:@"Photo"];

    [queryForUserContent whereKey:@"userName" equalTo:user.objectId];
    [queryForUserContent findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@",[error userInfo]);
        }
        else
        {
            for (PFObject *photo in objects) {
                [singleUser.arrayOfPhotos addObject:photo];
            }
        }
    }];



}







@end
