//
//  LoginTableViewController.h
//  Token
//
//  Created by Dave on 10/23/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ForgotPasswordTableViewController;

@interface LoginTableViewController : UITableViewController
<UITextFieldDelegate>
{
    UITextField *username;
    UITextField *password;
    UIButton *forgotPasswordButton;
    ForgotPasswordTableViewController *forgotPasswordTVC;
    UIBarButtonItem *loginItem;
}

- (void)setFooterViewHeight;
- (void)presentForgotPasswordTVC;
- (void)login;
- (void)isLoginAvailable;

@end
