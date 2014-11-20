//
//  BalanceTableViewCell.h
//  Token
//
//  Created by Dave on 10/31/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BalanceTableViewCell : UITableViewCell
{
    IBOutlet UIImageView *profileImageView;
    IBOutlet UILabel *username;
    IBOutlet UIButton *redeemButton;
    IBOutlet UIButton *redeemText;
    IBOutlet UIButton *balContent;
    IBOutlet UIButton *balActivity;
}

@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;

@property (nonatomic, strong) IBOutlet UILabel *username;
@property (nonatomic, strong) IBOutlet UIButton *redeemButton;
@property (nonatomic, strong) IBOutlet IBOutlet UIButton *redeemText;
@property (nonatomic, strong) IBOutlet IBOutlet UIButton *balContent;
@property (nonatomic, strong) IBOutlet IBOutlet UIButton *balActivity;

@end
