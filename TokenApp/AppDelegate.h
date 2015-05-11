//
//  AppDelegate.h
//  TokenApp
//
//  Created by Basel Farag on 12/5/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentUser.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
    CurrentUser *singleUser;

}

@property (nonatomic, readonly) int networkStatus;

- (BOOL)isParseReachable;

@property (strong, nonatomic) UIWindow *window;


@end

