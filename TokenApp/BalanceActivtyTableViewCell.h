//
//  BalanceActivtyTableViewCell.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 4/22/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BalanceActivtyTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *labelDateOfTransaction;
@property (strong, nonatomic) IBOutlet UILabel *labelDescriptionOfTransaction;

@property (strong, nonatomic) IBOutlet UILabel *labelTransactionNumber;

@property (strong, nonatomic) IBOutlet UILabel *labelRunningTokenBalance;


@end
