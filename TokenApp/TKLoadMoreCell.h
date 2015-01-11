//
//  TKLoadMoreCell.h
//  TokenApp
//
//  Created by BASEL FARAG on 1/10/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKLoadMoreCell : UITableViewCell

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *separatorImageTop;
@property (nonatomic, strong) UIImageView *separatorImageBottom;
@property (nonatomic, strong) UIImageView *loadMoreImageView;

@property (nonatomic, assign) BOOL hideSeparatorTop;
@property (nonatomic, assign) BOOL hideSeparatorBottom;

@property (nonatomic) CGFloat cellInsetWidth;

@end
