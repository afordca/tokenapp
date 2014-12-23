//
//  AppDelegate.h
//  TokenApp
//
//  Created by Basel Farag on 12/5/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NavTabBarController *tabBarController;
@property (nonatomic, strong) UINavigationController *navController;

@property (nonatomic, readonly) int networkStatus;

-(BOOL)isParseReachable;

-(void)presentLoginViewController;
-(void)presentLoginViewController:(BOOL)animated;
-(void)presentTabBarController;

-(void)logOut;

-(void)autoFollowUsers;

@end

