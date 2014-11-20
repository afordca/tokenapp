//
//  MainFeedTableViewCell.h
//  Token
//
//  Created by Dave on 11/1/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainFeedTableViewCell : UITableViewCell
{
    UIImageView *profileImage01;
    UILabel *nameLabel01;
    UILabel *timeElapsedLabel01;
    UIImageView *postImageView01;
    UIImageView *profileImage02;
    UILabel *nameLabel02;
    UILabel *timeElapsedLabel02;
    UILabel *randomText;
    UILabel *linkTitle;
    UILabel *linkSumText;
    UIImageView *linkImageView;
}

@property (nonatomic, retain) UIImageView *profileImage01;
@property (nonatomic, retain) UILabel *nameLabel01;
@property (nonatomic, retain) UILabel *timeElapsedLabel01;
@property (nonatomic, retain) UIImageView *postImageView01;
@property (nonatomic, retain) UIImageView *linkImageView;
@property (nonatomic, retain) UILabel *linkTitle;
@property (nonatomic, retain) UILabel *linkSumText;
@property (nonatomic, retain) UILabel *randomText;

- (void)prepareLoadedCell;

@end
