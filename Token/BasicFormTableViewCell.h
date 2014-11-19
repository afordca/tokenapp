//
//  BasicFormTableViewCell.h
//  Token
//
//  Created by Dave on 11/5/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicFormTableViewCell : UITableViewCell
{
    UITextField *textField;
}

@property (nonatomic, retain) UITextField *textField;

- (void)setLoadedCell:(UITextField *)_textField;

@end
