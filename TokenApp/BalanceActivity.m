//
//  BalanceActivity.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 4/23/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "BalanceActivity.h"

@implementation BalanceActivity

-(id)initWithBalanceDescription:(NSString *)description balanceDate:(NSString *)date transactionNumber:(NSNumber *)transactionNumber runningBalance:(NSNumber *)runningBalance
{
    self.balanceDescription = description;
    self.balanceDate = date;
    self.balanceTransactionNumber = transactionNumber;
    self.runningBalance = runningBalance;

    return self;
}

@end
