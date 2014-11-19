//
//  ForgotPasswordTableViewController.h
//  Token
//
//  Created by Dave on 10/23/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordTableViewController : UITableViewController
<UITextFieldDelegate>
{
    UITextField *email;
    UIButton *resetPasswordButton;
}

- (void)setHeaderViewHeight;
- (void)setFooterViewHeight;
- (void)resetPassword;

@end
