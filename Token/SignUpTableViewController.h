//
//  SignUpTableViewController.h
//  Token
//
//  Created by Dave on 10/17/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWSCore.h"
#import "Cognito.h"

@interface SignUpTableViewController : UITableViewController
<UITextFieldDelegate>
{
    UITextField *firstName;
    UITextField *lastName;
    UITextField *username;
    UITextField *password;
    UIButton *createAccountButton;
}

@property (nonatomic, retain) UITextField *firstName;
@property (nonatomic, retain) UITextField *lastName;
@property (nonatomic, retain) UITextField *username;
@property (nonatomic, retain) UITextField *password;

- (void)setFooterViewHeight;
- (void)signUp;

@end

