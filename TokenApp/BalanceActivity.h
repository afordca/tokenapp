//
//  BalanceActivity.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 4/23/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BalanceActivity : NSObject

@property (nonatomic,strong) NSString *balanceDate;
@property (nonatomic,strong) NSString *balanceDescription;
@property (nonatomic,strong) NSNumber *balanceTransactionNumber;
@property (nonatomic,strong) NSNumber *runningBalance;


-(id)initWithBalanceDescription:(NSString*)description balanceDate:(NSString*)date transactionNumber:(NSNumber*)transactionNumber runningBalance:(NSNumber*)runningBalance;


@end
