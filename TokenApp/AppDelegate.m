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


@interface AppDelegate (){
    BOOL firstLaunch;
}

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSTimer *autoFollowTimer;
//@property (nonatomic, strong) HomeFeedViewController **activityViewController;


-(void)setupAppearance;
-(BOOL)shouldProceedToMainInterface:(PFUser*)user;
-(BOOL)handleActionURL:(NSURL *)url;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"dNPSXSwJgJXVxTxkbta8EmoFFouOI4TIXlO1kTiz"
                  clientKey:@"Dbxo2R7VxPwOv6ub5tQ9qK3sWwinkBCUQSqyUld3"];

    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];


    return YES;
}

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

-(void)presentLoginViewController {
    [self presentLoginViewController:YES];
}

//-(void)presenTabBarController {
//    self.tabBarController = [[NavTabBarController alloc]init];
//    //Set up so that home view controller is firstLaunch
//    self.activityViewController = [[HomeFeedViewController alloc]init];
//
//    UINavigationController *activityFeedNavigationController = [[UINavigationController alloc]init];
//
// image:<#(UIImage *)#> selectedImage:<#(UIImage *)#>]
//
//
//}

@end
