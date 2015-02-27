//
//  TKHomeHeaderView.m
//  TokenApp
//
//  Created by BASEL FARAG on 2/23/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "TKHomeHeaderView.h"
#import "Macros.h"
#import "Constants.h"
#import "TKUtility.h"
#import "TKProfileImageView.h"


@interface TKHomeHeaderView ()
@property (nonatomic, strong) TKProfileImageView *avatarImageView;
@property (nonatomic, strong) UIButton *userButton;


@end



@implementation TKHomeHeaderView

#pragma mark - Initialization 

-(id)initWithFrame:(CGRect)frame buttons:(TKHomeHeaderButtons)otherButtons
{
    self = [super initWithFrame:frame];

    return self;
}

#pragma mark - TKPhotoHeaderView

-(void)setPhoto:(PFObject *)aPhoto
{
    self.photo = aPhoto;

    //Here we set the User's Avatar
    PFUser *user = [self.photo objectForKey:kPTKActivityPhotoKey];
    if ([TKUtility userHasProfilePictures:user]){
        PFFile *profilePictureSmall = [user objectForKey:kPTKUserProfilePicSmallKey];
        [self.avatarImageView setFile:profilePictureSmall];
    } else {
        [self.avatarImageView setImage:[TKUtility defaultProfilePicture]];
    }

    NSString *authorName = [user objectForKey:kTKUserDisplayNameKey];
    [self.userButton setTitle:authorName forState:UIControlStateNormal];
    
}

@end
