//
//  ContentDetailTableViewCell.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 5/11/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageViewContent;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewLike;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewComment;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewShare;

@property (strong, nonatomic) IBOutlet UILabel *labelNumberOfTokens;

@property (strong, nonatomic) IBOutlet UILabel *labelNumberOfLikes;

@property (strong, nonatomic) IBOutlet UILabel *labelContentDescription;

@property (strong, nonatomic) IBOutlet UILabel *labelComment1;



@end
