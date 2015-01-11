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

@interface AppDelegate (){
    BOOL firstLaunch;
}

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSTimer *autoFollowTimer;
@property (nonatomic, strong) TKWelcomeViewController *welcomeViewController;
@property (nonatomic, strong) TKHomeViewController *homeViewController;
@property (nonatomic, strong) TKActivityFeedViewController *activityViewController;
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
    [self monitorReachability];

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
    self.tabBarController = [[TKTabBarController alloc]init];
    self.homeViewController = [[TKHomeViewController alloc]initWithStyle:UITableViewStylePlain];
    [self.homeViewController setFirstLaunch:firstLaunch];
    //self.activityViewController = [[TKActivityFeedViewController alloc]initWithStyle:UITableViewStylePlain];

    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:self.homeViewController];
    UINavigationController *emptyNavigationController = [[UINavigationController alloc] init];
    //Temporary Test
    UINavigationController *activityFeedNavigationController = [[UINavigationController alloc] initWithRootViewController:self.homeViewController];

    UITabBarItem *homeTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Home", @"Home") image:[[UIImage imageNamed:@"IconHome.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"IconHomeSelected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [homeTabBarItem setTitleTextAttributes: @{ NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:13] } forState:UIControlStateSelected];
    [homeTabBarItem setTitleTextAttributes: @{ NSForegroundColorAttributeName: [UIColor colorWithRed:114.0f/255.0f green:114.0f/255.0f blue:114.0f/255.0f alpha:1.0f], NSFontAttributeName: [UIFont boldSystemFontOfSize:13] } forState:UIControlStateNormal];

    UITabBarItem *activityFeedTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Activity", @"Activity") image:[[UIImage imageNamed:@"IconTimeline.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"IconTimelineSelected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [activityFeedTabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:13] } forState:UIControlStateSelected];
    [activityFeedTabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithRed:114.0f/255.0f green:114.0f/255.0f blue:114.0f/255.0f alpha:1.0f], NSFontAttributeName: [UIFont boldSystemFontOfSize:13] } forState:UIControlStateNormal];

    [homeNavigationController setTabBarItem:homeTabBarItem];
    [activityFeedNavigationController setTabBarItem:activityFeedTabBarItem];

    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = @[ homeNavigationController, emptyNavigationController, activityFeedNavigationController];

    [self.navController setViewControllers:@[ self.welcomeViewController, self.tabBarController ] animated:NO];




//    TKHomeViewController *tkhomeFeedVC = [[TKHomeViewController alloc]init];
//      UITabBarItem *homeTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Home", @"Home") image:[[UIImage imageNamed:@"Profile.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"IconHomeSelected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [tkhomeFeedVC setTabBarItem:homeTabBarItem];

}

- (void)logOut {
    // clear cache
    [[TKCache sharedCache] clear];

//    // clear NSUserDefaults
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTKUserDefaultsCacheFacebookFriendsKey];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTKUserDefaultsCacheFacebookFriendsKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];

    // Clear all caches
    [PFQuery clearAllCachedResults];

    // Log out
    [PFUser logOut];
    [FBSession setActiveSession:nil];

    // clear out cached data, view controllers, etc
    [self.navController popToRootViewControllerAnimated:NO];

    [self presentLoginViewController];

    self.homeViewController = nil;
    //self.activityViewController = nil;
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
- (void)setupAppearance {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:254.0f/255.0f green:149.0f/255.0f blue:50.0f/255.0f alpha:1.0f]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];

    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor whiteColor]
                                                           }];

    [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleColor:[UIColor colorWithRed:254.0f/255.0f green:149.0f/255.0f blue:50.0f/255.0f alpha:1.0f]
     forState:UIControlStateNormal];

    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName:[UIColor colorWithRed:254.0f/255.0f green:149.0f/255.0f blue:50.0f/255.0f alpha:1.0f]
                                                           }
                                                forState:UIControlStateNormal];

    [[UISearchBar appearance] setTintColor:[UIColor colorWithRed:254.0f/255.0f green:149.0f/255.0f blue:50.0f/255.0f alpha:1.0f]];
}

- (void)monitorReachability {
    Reachability *hostReach = [Reachability reachabilityWithHostname:@"api.parse.com"];

    hostReach.reachableBlock = ^(Reachability*reach) {
        _networkStatus = [reach currentReachabilityStatus];

        if ([self isParseReachable] && [PFUser currentUser] && self.homeViewController.objects.count == 0) {
            // Refresh home timeline on network restoration. Takes care of a freshly installed app that failed to load the main timeline under bad network conditions.
            // In this case, they'd see the empty timeline placeholder and have no way of refreshing the timeline unless they followed someone.
            [self.homeViewController loadObjects];
        }
    };

    hostReach.unreachableBlock = ^(Reachability*reach) {
        _networkStatus = [reach currentReachabilityStatus];
    };
    
    [hostReach startNotifier];
}

#pragma mark passWord Recovery 
//-(void)passWordRecovery
//{
//    NSString *emailString = textfield.text
//    [PFUser requestPasswordResetForEmailInBackground:emailString block:^(BOOL succeeded, NSError *error) {
//        if (error){
//        UIAlertView *passwordError = [[UIAlertView alloc
//        }
//    }
//}




@end
