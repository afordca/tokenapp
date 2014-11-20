//
//  SignUpTableViewCell.h
//  Token
//
//  Created by Dave on 10/21/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpTableViewCell : UITableViewCell
{
    UITextField *textField;
}

@property (nonatomic, retain) UITextField *textField;

- (void)setLoadedCell:(UITextField *)_textField;

@end
