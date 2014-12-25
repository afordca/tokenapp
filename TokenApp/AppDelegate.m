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
#import "HomeFeedViewController.h"
#import "TKWelcomeViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface AppDelegate (){
    BOOL firstLaunch;
}

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSTimer *autoFollowTimer;
@property TKWelcomeViewController *welcomeViewController;
//@property (nonatomic, strong) HomeFeedViewController **activityViewController;


-(void)setupAppearance;
-(BOOL)shouldProceedToMainInterface:(PFUser*)user;
-(BOOL)handleActionURL:(NSURL *)url;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"dNPSXSwJgJXVxTxkbta8EmoFFouOI4TIXlO1kTiz"
                  clientKey:@"Dbxo2R7VxPwOv6ub5tQ9qK3sWwinkBCUQSqyUld3"];
    //Track app open
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];

    //Enable Public Read Access

    //Set up global UI Appearance

    //Use Reachability to monitor connectivity
    [self monitorReachibility];

    self.welcomeViewController = [[TKWelcomeViewController alloc]init];

    self.navController = [[UINavigationController alloc]initWithRootViewController:self.welcomeViewController];
    self.navController.navigationBarHidden = YES;

    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];

    //Handle Push notifications here

    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL wasHandled = false;

    if ([PFFacebookUtils session]) {
        wasHandled |= [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
    } else {
        wasHandled |= [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    }
    wasHandled |= [self handleActionURL:url];

    return wasHandled;

}

#pragma Notification beginning implementation

//-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    if (application.applicationIconBadgeNumber != 0) {
//        application.applicationIconBadgeNumber = 0;
//    }
//
//    PFInstallation
//}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - UITabBarControllerDelegate 

//-(BOOL)tabBarController:(UITabBarController*)aTabBarController shouldSelectViewController:(UIViewController *)viewController{
//    //
//}

#pragma mark - AppDelegate

-(BOOL)isParseReachable {
    return self.networkStatus != NotReachable;
}

-(void)presentLoginViewController:(BOOL)animated {
    [self.welcomeViewController presentLoginViewController:animated];
}

-(void)presentLoginViewController{
    [self presentLoginViewController:YES];
}


-(void)presentTabBarViewController {
    self.tabBarController = [[NavTabBarController alloc]init];
    [self presentLoginViewController:YES];

    HomeFeedViewController *homeFeedVC = [[HomeFeedViewController alloc]init];
      UITabBarItem *homeTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Home", @"Home") image:[[UIImage imageNamed:@"Profile.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"IconHomeSelected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [homeFeedVC setTabBarItem:homeTabBarItem];

}

- (void)logOut {
    // clear cache
    [[PAPCache sharedCache] clear];

    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsCacheFacebookFriendsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // Unsubscribe from push notifications by removing the user association from the current installation.
    [[PFInstallation currentInstallation] removeObjectForKey:kPAPInstallationUserKey];
    [[PFInstallation currentInstallation] saveInBackground];

    // Clear all caches
    [PFQuery clearAllCachedResults];

    // Log out
    [PFUser logOut];
    [FBSession setActiveSession:nil];

    // clear out cached data, view controllers, etc
    [self.navController popToRootViewControllerAnimated:NO];

    [self presentLoginViewController];

    self.homeViewController = nil;
    self.activityViewController = nil;
}

//-(void)presenTabBarController {
//    self.tabBarController = [[NavTabBarController alloc]init];
//    //Set up so that home view controller is firstLaunch
//    self.activityViewController = [[HomeFeedViewController alloc]init];
//
//    UINavigationController *activityFeedNavigationController = [[UINavigationController alloc]init];
//
// image:selectedImage:
//
//
//}


#pragma mark - ()

// Set up appearance parameters to achieve Anypic's custom look and feel
//- (void)setupAppearance

- (void)monitorReachability {
    Reachability *hostReach = [Reachability reachabilityWithHostname:@"api.parse.com"];

    hostReach.reachableBlock = ^(Reachability*reach) {
        _networkStatus = [reach currentReachabilityStatus];

        if ([self isParseReachable] && [PFUser currentUser] && self.welcomeViewController.objects.count == 0) {
            // Refresh home timeline on network restoration. Takes care of a freshly installed app that failed to load the main timeline under bad network conditions.
            // In this case, they'd see the empty timeline placeholder and have no way of refreshing the timeline unless they followed someone.
            [self.welcomeViewController loadObjects];
        }
    };

    hostReach.unreachableBlock = ^(Reachability*reach) {
        _networkStatus = [reach currentReachabilityStatus];
    };

    [hostReach startNotifier];
}






@end
