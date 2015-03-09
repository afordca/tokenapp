//
//  UserActivityTableViewCell.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/23/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserActivityTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfilePic;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewPhoto;
@property (strong, nonatomic) IBOutlet UILabel *labelUsername;

@end
