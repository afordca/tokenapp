//
//  UploadViewController.h
//  Token
//
//  Created by Dave on 10/28/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadViewController : UIViewController
{
    UIButton *photoButton;
    UIButton *videoButton;
    UIButton *composeButton;
    UIButton *linkButton;
}

@property (nonatomic, strong) UIButton *photoButton;

- (void)selectPhotoFromLibrary;
- (void)selectVideoFromLibrary;
- (void)presentPostView;
- (void)presentLinkView;

@end
