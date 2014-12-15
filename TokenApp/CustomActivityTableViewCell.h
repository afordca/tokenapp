//
//  CustomActivityTableViewCell.h
//  TokenApp
//
//  Created by BASEL FARAG on 12/14/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomActivityTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *labelUsername;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewForPhotos;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *labelTimer;
@property (strong, nonatomic) IBOutlet UILabel *labelNumberOfLikes;
@property (strong, nonatomic) IBOutlet UILabel *labelImageDescription;
@property (strong, nonatomic) IBOutlet UILabel *labelComments;

@end
