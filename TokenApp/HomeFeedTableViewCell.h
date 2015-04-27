//
//  HomeFeedTableViewCell.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 4/26/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeFeedTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageViewHomeFeedProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *labelHomeFeedUsername;
@property (strong, nonatomic) IBOutlet UILabel *labelHomeFeedTime;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewHomeFeedContent;


@end
