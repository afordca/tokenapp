//
//  BalanceTableViewCell.m
//  Token
//
//  Created by Dave on 10/31/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "BalanceTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation BalanceTableViewCell
@synthesize profileImageView, username, redeemButton, redeemText, balContent, balActivity;

- (void)awakeFromNib {
    // Initialization code
    //self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 398);
    username.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
    
    [profileImageView setImage:[UIImage imageNamed:@"ProfileImages_01"]];
    [redeemButton setBackgroundImage:[UIImage imageNamed:@"BalRedeem"] forState:UIControlStateNormal];
    [redeemButton setTitle:@"" forState:UIControlStateNormal];
    redeemText.layer.cornerRadius = 2.0;
    redeemText.layer.borderWidth = 1.0;
    redeemText.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
    
    [balContent setBackgroundImage:[UIImage imageNamed:@"BalContent"] forState:UIControlStateNormal];
    [balContent setTitle:@"" forState:UIControlStateNormal];
    
    [balActivity setBackgroundImage:[UIImage imageNamed:@"BalActivity"] forState:UIControlStateNormal];
    [balActivity setTitle:@"" forState:UIControlStateNormal];
    
    [self setFrame:[UIScreen mainScreen].bounds];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
