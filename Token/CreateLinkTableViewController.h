//
//  CreateLinkTableViewController.h
//  Token
//
//  Created by Dave on 11/2/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateLinkTableViewController : UITableViewController
<UITextViewDelegate>
{
    UITextView *postTextView;
    UILabel *placeholderText;
}

- (void)shareView;

@end
