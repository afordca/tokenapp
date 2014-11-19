//
//  MainFeedTableViewCell.m
//  Token
//
//  Created by Dave on 11/1/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import "MainFeedTableViewCell.h"

@implementation MainFeedTableViewCell
@synthesize profileImage01, nameLabel01, timeElapsedLabel01, postImageView01, randomText, linkImageView, linkTitle, linkSumText;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        profileImage01 = [[UIImageView alloc] initWithFrame:CGRectMake(2, 4, 30, 30)];
        nameLabel01 = [[UILabel alloc] initWithFrame:CGRectMake(37, 14, 120, 14)];
        timeElapsedLabel01 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 14, 40, 14)];
        postImageView01 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 37, [UIScreen mainScreen].bounds.size.width, 313)];
        
        linkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 37, 120, 120)];
        linkTitle = [[UILabel alloc] initWithFrame:CGRectMake(130, 27, 160, 60)];
        linkTitle.font = [UIFont boldSystemFontOfSize:14];
        linkTitle.numberOfLines = 2;
        
        linkSumText = [[UILabel alloc] initWithFrame:CGRectMake(130, 66, 160, 80)];
        linkSumText.font = [UIFont fontWithName:@"Helvetica" size:13];
        linkSumText.textColor = [UIColor lightGrayColor];
        linkSumText.numberOfLines = 4;
                        
        nameLabel01.font = [UIFont fontWithName:@"Helvetica" size:12];
        nameLabel01.textColor = [UIColor grayColor];
        
        timeElapsedLabel01.font = [UIFont fontWithName:@"Helvetica" size:13];
        timeElapsedLabel01.textColor = [UIColor grayColor];
        
        randomText = [[UILabel alloc] initWithFrame:CGRectMake(32, 5, [UIScreen mainScreen].bounds.size.width - 50, 230)];
        randomText.text = @"";
        randomText.numberOfLines = 6;
        
        
        NSLog(@"initWithStyle in MainFeedTableViewCell called!");
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (!self) {
        self = [super initWithFrame:frame];
    }
    return self;
}

- (void)awakeFromNib {
    
    profileImage01 = [[UIImageView alloc] initWithFrame:CGRectMake(2, 4, 30, 30)];
    nameLabel01 = [[UILabel alloc] initWithFrame:CGRectMake(37, 14, 120, 14)];
    timeElapsedLabel01 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 14, 40, 14)];
    postImageView01 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 37, [UIScreen mainScreen].bounds.size.width, 313)];
    NSLog(@"Awake from nib in MainFeedTableViewCell called!");
}

- (void)prepareLoadedCell
{
    [self.contentView addSubview:profileImage01];
    [self.contentView addSubview:nameLabel01];
    [self.contentView addSubview:timeElapsedLabel01];
    [self.contentView addSubview:postImageView01];
    [self.contentView addSubview:randomText];
    [self.contentView addSubview:linkImageView];
    [self.contentView addSubview:linkTitle];
    [self.contentView addSubview:linkSumText];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
