//
//  PostTableViewController.h
//  Token
//
//  Created by Dave on 11/1/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTableViewController : UITableViewController
{
    UIImageView *userPhoto;
    UILabel *userName;
    UILabel *timeElapsed;
    UILabel *tokenLabel;
    UILabel *likesLabel;
    UILabel *descriptionLabel;
    UILabel *hashtagesLabel;
    UILabel *userNameCommentLabel;
    UIButton *likeButton;
    UIButton *shareButton;
    UIButton *commentButton;
    NSString *navTitle;
}

@property (nonatomic, copy) NSString *navTitle;

- (void)presentCommentView;

@end
