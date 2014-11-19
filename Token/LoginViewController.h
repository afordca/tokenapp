//
//  LoginViewController.h
//  Token
//
//  Created by Dave on 10/16/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    UIImageView *markImageView;
    UIImageView *logoImageView;
    UIButton *loginButton;
    UIButton *signUpButton;
}

@property (nonatomic, retain) UIImageView *markImageView;
@property (nonatomic, retain) UIImageView *logoImageView;
@property (strong) UIButton *loginButton;
@property (strong) UIButton *signUpButton;

- (void)determineLayout;

- (void)presentLoginViewController;
- (void)presentSignUpViewController;

@end
