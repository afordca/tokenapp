//
//  ProfileCollectionReusableView.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/20/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CurrentUser.h"

@protocol CustomProfileDelegate <NSObject>

-(void)tapOnCamera;
-(void)tapOnLibrary;
-(void)presentActivityView;
-(void)presentFollowersView;
-(void)presentFollowingView;
-(void)presentNotificationsView;
-(void)followUser;

@end

@interface ProfileCollectionReusableView : UICollectionReusableView <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    CurrentUser *currentUser;
}


@property id<CustomProfileDelegate>delegate;

@property ProfileCollectionReusableView *profileCollectionView;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfilePic;

@property UIImagePickerController *imagePickerProfile;
@property (strong, nonatomic) IBOutlet UILabel *labelFollowersCount;

@property (strong, nonatomic) IBOutlet UILabel *labelFollowingCount;
@property (strong, nonatomic) IBOutlet UILabel *labelPostsCount;

@property (strong, nonatomic) IBOutlet UIButton *buttonFollowers;
@property (strong, nonatomic) IBOutlet UIButton *buttonFollowing;
@property (strong, nonatomic) IBOutlet UITextView *textViewBiography;


@end
