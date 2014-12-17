//
//  ProfileViewController.h
//  TokenApp
//
//  Created by Basel Farag on 12/5/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macros.h"

@interface ProfilePersonalViewController : UIViewController
{
    UIImageView *profileImageView;
    UILabel *nameLabel;
    UILabel *quoteLabel;
    UILabel *jobTitleLabel;
    UILabel *websiteLabel;
    UILabel *postsCountLabel;
    UILabel *postsCountTextLabel;
    UILabel *followersCountLabel;
    UIButton *followersTextButton;
    UILabel *followingCountLabel;
    UIButton *followingTextButton;
    UIButton *balanceImageView;
    UILabel *balanceLabelText;
    UIButton *followersButton;
    UIImageView *uploadedImageView02;
    UIImageView *uploadedImageView03;
    UIImageView *uploadedImageView04;
    UIImageView *uploadedImageView05;
    UIImageView *uploadedImageView06;
    UIButton *feedButton;
}
@property PFObject *user;

-(void)uploadImage:(NSData*)imageData;

@end
