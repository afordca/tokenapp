//
//  MarketplaceTableViewCell.h
//  Token
//
//  Created by Dave on 11/4/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarketplaceTableViewCell : UITableViewCell
{
    IBOutlet UIImageView *cardImageView;
    IBOutlet UILabel *giftCardValue;
    IBOutlet UIButton *redeemButton;
    IBOutlet UILabel *redeemPointsRequired;
}

@property (nonatomic, retain) IBOutlet UIImageView *cardImageView;
@property (nonatomic, retain) IBOutlet UILabel *giftCardValue;
@property (nonatomic, retain) IBOutlet UIButton *redeemButton;
@property (nonatomic, retain) IBOutlet UILabel *redeemPointsRequired;

@end
