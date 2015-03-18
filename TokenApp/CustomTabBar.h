//
//  CustomTabBar.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/12/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Camera.h"

// define the protocol for the delegate
@protocol CustomTabBarDelegate <NSObject>

// define protocol functions that can be used in any class using this delegate
-(void)onClickHomeFeed;
-(void)onClickDiscover;
-(void)onClickCreate;
-(void)onClickProfile;
-(void)onClickBalance;

@end

@interface CustomTabBar : UIView

@property UIButton *btnHomeFeed;
@property UIButton *btnDiscover;
@property UIButton *btnCreate;
@property UIButton *btnProfile;
@property UIButton *btnBalance;

// define delegate property
@property id <CustomTabBarDelegate> delegate;

// define public functions
-(void)clickHome;
-(void)clickDiscover;
-(void)clickCreate;
-(void)clickProfile;
-(void)clickBalance;

@end
