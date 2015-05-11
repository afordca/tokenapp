//
//  ProfileCollectionViewCell.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/18/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfileContent;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewVideoIcon;

@property (strong, nonatomic) IBOutlet UILabel *labelLinkURL;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewLinkURL;
@property (strong, nonatomic) IBOutlet UILabel *labelNoteMessage;
@property (strong, nonatomic) IBOutlet UILabel *labelNoteHeader;

@end
