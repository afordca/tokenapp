//
//  DetailedPhotoViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 4/9/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "DetailedPhotoViewController.h"
#import "UIColor+HEX.h"

@interface DetailedPhotoViewController ()

@property (strong, nonatomic) IBOutlet UIButton *buttonComment;
@property (strong, nonatomic) IBOutlet UIButton *buttonLike;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewDetailPhoto;

@end

@implementation DetailedPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imageViewDetailPhoto.image = self.detailPhoto;

    //Setup LoginButton Appearance
    CALayer *layerComment = self.buttonComment.layer;
    layerComment.backgroundColor = [[UIColor clearColor] CGColor];
    layerComment.borderColor = [[UIColor colorwithHexString:@"#72c74a" alpha:.9]CGColor];
    layerComment.borderWidth = 1.5f;

    CALayer *layerLike = self.buttonLike.layer;
    layerLike.backgroundColor = [[UIColor clearColor] CGColor];
    layerLike.borderColor = [[UIColor colorwithHexString:@"#72c74a" alpha:.9]CGColor];
    layerLike.borderWidth = 1.5f;

}



@end
