//
//  TKProfileImageView.h
//  TokenApp
//
//  Created by BASEL FARAG on 1/10/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macros.h"
#import "ParseUI/ParseUI.h"


@class PFImageView;

@interface TKProfileImageView : UIView

@property (nonatomic, strong) UIButton *profileButton;
@property (nonatomic, strong) PFImageView *profileImageView;

- (void)setFile:(PFFile *)file;
- (void)setImage:(UIImage *)image;

@end
