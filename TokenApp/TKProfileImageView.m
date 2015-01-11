//
//  TKProfileImageView.m
//  TokenApp
//
//  Created by BASEL FARAG on 1/10/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "TKProfileImageView.h"
#import "Constants.h"

@interface TKProfileImageView ()

@property (nonatomic, strong) UIImageView *borderImageview;
@end

@implementation TKProfileImageView

@synthesize borderImageview;
@synthesize profileImageView;
@synthesize profileButton;


#pragma mark - NSObject

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        self.profileImageView = [[PFImageView alloc] initWithFrame:frame];
        [self addSubview:self.profileImageView];

        self.profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.profileButton];

        [self addSubview:self.borderImageview];
    }
    return self;
}


#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self bringSubviewToFront:self.borderImageview];

    self.profileImageView.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    self.borderImageview.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    self.profileButton.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
}


#pragma mark - TKProfileImageView

- (void)setFile:(PFFile *)file {
    if (!file) {
        return;
    }

    //self.profileImageView.image = [UIImage imageNamed:@""];
    self.profileImageView.file = file;
    [self.profileImageView loadInBackground];
}

- (void)setImage:(UIImage *)image {
    self.profileImageView.image = image;
}

@end

