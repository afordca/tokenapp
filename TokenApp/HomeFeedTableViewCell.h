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

@property (strong, nonatomic) IBOutlet UIImageView *imageViewVideoIcon;

@property (strong, nonatomic) IBOutlet UILabel *labelLinkURL;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewLinkURL;

@property (strong, nonatomic) IBOutlet UIView *viewLinkBlackBackground;
@property (strong, nonatomic) IBOutlet UILabel *labelHeader;
@property (strong, nonatomic) IBOutlet UILabel *lableNoteMessage;
@property (strong, nonatomic) IBOutlet UILabel *labelLinkTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelLinkDescription;


@end
