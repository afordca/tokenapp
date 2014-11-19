//
//  MarketplaceTableViewCell.m
//  Token
//
//  Created by Dave on 11/4/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "MarketplaceTableViewCell.h"

@implementation MarketplaceTableViewCell
@synthesize cardImageView, giftCardValue, redeemButton, redeemPointsRequired;

- (void)awakeFromNib {
    // Initialization code
    
    redeemButton.layer.cornerRadius = 2.0;
    redeemButton.layer.borderWidth = 1.0;
    redeemButton.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
    [redeemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
